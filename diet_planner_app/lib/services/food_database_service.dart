import 'dart:collection';
import 'package:logger/logger.dart';

import '../models/food_item.dart';
import 'enhanced_api_service.dart';
import 'firestore_service.dart';
import 'firebase_auth_service.dart';

final Logger _logger = Logger();

/// Food database with local cache and Firebase sync
/// Uses in-memory storage with optional cloud persistence
class FoodDatabaseService {
  FoodDatabaseService._privateConstructor();
  static final FoodDatabaseService instance =
      FoodDatabaseService._privateConstructor();

  final List<FoodItem> _foods = [];
  final Map<DateTime, List<FoodItem>> _logs = {};

  // Lazy initialization - only access when Firebase is configured
  FirestoreService? _firestore;
  FirestoreService get firestore {
    try {
      _firestore ??= FirestoreService.instance;
      return _firestore!;
    } catch (e) {
      // Return a dummy instance if Firebase not available
      _firestore ??= FirestoreService.instance;
      return _firestore!;
    }
  }

  FirebaseAuthService? _auth;
  FirebaseAuthService get auth {
    try {
      _auth ??= FirebaseAuthService.instance;
      return _auth!;
    } catch (e) {
      _auth ??= FirebaseAuthService.instance;
      return _auth!;
    }
  }

  UnmodifiableListView<FoodItem> get foods => UnmodifiableListView(_foods);

  void addFood(FoodItem item) {
    if (!_foods.any((f) => f.id == item.id)) _foods.add(item);
  }

  List<FoodItem> search(String query) {
    final q = query.toLowerCase();
    return _foods.where((f) => f.name.toLowerCase().contains(q)).toList();
  }

  /// Search remote APIs (Enhanced multi-API search) and return normalized FoodItems.
  Future<List<FoodItem>> searchRemote(String query) async {
    try {
      final list = await EnhancedApiService.instance.smartFoodSearch(query);
      // add to local cache
      for (final f in list) {
        addFood(f);
      }
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Lookup a food by barcode using remote APIs. If found,
  /// it's added to the local cache and returned.
  Future<FoodItem?> fetchFoodByBarcode(String barcode) async {
    try {
      final item = await EnhancedApiService.instance.fetchFoodByBarcode(
        barcode,
      );
      if (item != null) addFood(item);
      return item;
    } catch (_) {
      return null;
    }
  }

  /// Log food - saves to local memory and syncs to Firebase if user is signed in
  void logFood(DateTime date, FoodItem item) {
    final day = DateTime(date.year, date.month, date.day);
    _logs.putIfAbsent(day, () => []).add(item);
    addFood(item);

    // Sync to Firebase if user is signed in
    try {
      final authService = auth;
      if (authService.auth != null && authService.isSignedIn) {
        firestore.logFood(date, item).catchError((e) {
          // Silently fail - Firebase not available
        });
      }
    } catch (e) {
      // Firebase not configured, skip sync - this is normal in guest mode
    }
  }

  /// Remove a single occurrence of [item] from the logs for [date].
  /// Returns true if an item was removed, false otherwise.
  bool removeLoggedFood(DateTime date, FoodItem item) {
    final day = DateTime(date.year, date.month, date.day);
    final list = _logs[day];
    if (list == null || list.isEmpty) return false;
    // Remove only one matching instance (by id if available, else by equality)
    final idx = list.indexWhere((f) => f.id == item.id);
    if (idx == -1) return false;
    list.removeAt(idx);
    if (list.isEmpty) _logs.remove(day);

    // Sync to Firebase if user is signed in
    try {
      final authService = auth;
      if (authService.auth != null && authService.isSignedIn) {
        firestore.removeLoggedFood(date, item).catchError((e) {
          // Silently fail - Firebase not available
        });
      }
    } catch (e) {
      // Firebase not configured, skip sync - this is normal in guest mode
    }

    return true;
  }

  /// Get logged foods - fetches from Firebase if user is signed in
  Future<List<FoodItem>> getLoggedFoodsAsync(DateTime date) async {
    final day = DateTime(date.year, date.month, date.day);

    // If user is signed in, fetch from Firebase
    try {
      final authService = auth;
      if (authService.auth != null && authService.isSignedIn) {
        final cloudFoods = await firestore.getLoggedFoods(date);
        _logs[day] = cloudFoods;
        return cloudFoods;
      }
    } catch (e) {
      // Firebase not available - fall back to local cache
    }

    return _logs[day] ?? [];
  }

  /// Get logged foods synchronously from local cache
  List<FoodItem> getLoggedFoods(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return List.unmodifiable(_logs[day] ?? []);
  }

  double caloriesFor(DateTime date) {
    final list = getLoggedFoods(date);
    return list.fold(0.0, (s, f) => s + f.calories);
  }

  /// Load user data from Firebase (call after sign in)
  Future<void> loadUserData() async {
    try {
      final authService = auth;
      if (authService.auth == null || !authService.isSignedIn) return;

      // Load recent food logs (last 30 days)
      final now = DateTime.now();
      for (int i = 0; i < 30; i++) {
        final date = now.subtract(Duration(days: i));
        final foods = await firestore.getLoggedFoods(date);
        if (foods.isNotEmpty) {
          final day = DateTime(date.year, date.month, date.day);
          _logs[day] = foods;
          for (final food in foods) {
            addFood(food);
          }
        }
      }
    } catch (e) {
      // Firebase not configured or error loading
      _logger.w(
        'Firebase not available or error loading user data: $e',
        error: e,
      );
    }
  }

  /// Clear local cache
  void clearCache() {
    _foods.clear();
    _logs.clear();
  }
}
