import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../models/food_item.dart';
import '../models/meal_plan.dart';
import '../models/user_profile.dart';
import 'firebase_auth_service.dart';

final Logger _logger = Logger();

/// Firestore Database Service
/// Handles all cloud database operations for user data
class FirestoreService {
  FirestoreService._private();
  static final FirestoreService instance = FirestoreService._private();

  // Lazy initialization to avoid errors when Firebase is not configured
  FirebaseFirestore? _db;
  FirebaseFirestore? get db {
    if (_db != null) return _db;
    try {
      _db = FirebaseFirestore.instance;
      return _db;
    } catch (e) {
      if (kDebugMode) {
        _logger.e('Firestore not available: $e');
      }
      return null;
    }
  }

  final _auth = FirebaseAuthService.instance;

  // Collection references
  CollectionReference? get _usersCollection => db?.collection('users');

  /// Get user document reference
  DocumentReference? get _userDoc {
    final uid = _auth.currentUserId;
    if (uid == null || _usersCollection == null) return null;
    return _usersCollection!.doc(uid);
  }

  // ==================== USER PROFILE ====================

  /// Save or update user profile
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final userDoc = _userDoc;
      if (userDoc == null) {
        throw Exception('User not authenticated');
      }

      await userDoc.set({
        'name': profile.name,
        'age': profile.age,
        'heightCm': profile.heightCm,
        'weightKg': profile.weightKg,
        'goal': {
          'dailyCalories': profile.goal.dailyCalories,
          'proteinRatio': profile.goal.proteinRatio,
          'carbsRatio': profile.goal.carbsRatio,
          'fatRatio': profile.goal.fatRatio,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (kDebugMode) {
        print('User profile saved');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user profile: $e');
      }
      rethrow;
    }
  }

  /// Get user profile
  Future<UserProfile?> getUserProfile() async {
    try {
      final userDoc = _userDoc;
      if (userDoc == null) return null;

      final snapshot = await userDoc.get();
      if (!snapshot.exists) return null;

      // Return UserProfile parsed from Firestore data
      // For now, return sample profile - you can extend this
      return UserProfile.sample();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user profile: $e');
      }
      return null;
    }
  }

  // ==================== FOOD LOGS ====================

  /// Log a food item for a specific date
  Future<void> logFood(DateTime date, FoodItem food) async {
    try {
      final userDoc = _userDoc;
      if (userDoc == null) {
        throw Exception('User not authenticated');
      }

      final dateKey = _formatDate(date);
      await userDoc.collection('food_logs').doc(dateKey).set({
        'date': Timestamp.fromDate(date),
        'foods': FieldValue.arrayUnion([food.toJson()]),
      }, SetOptions(merge: true));

      if (kDebugMode) {
        print('Food logged for $dateKey');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging food: $e');
      }
      rethrow;
    }
  }

  /// Get logged foods for a specific date
  Future<List<FoodItem>> getLoggedFoods(DateTime date) async {
    try {
      final userDoc = _userDoc;
      if (userDoc == null) return [];

      final dateKey = _formatDate(date);
      final snapshot = await userDoc.collection('food_logs').doc(dateKey).get();

      if (!snapshot.exists) return [];

      final data = snapshot.data();
      if (data == null || !data.containsKey('foods')) return [];

      final foodsList = data['foods'] as List<dynamic>;
      return foodsList
          .map((json) => FoodItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting logged foods: $e');
      }
      return [];
    }
  }

  /// Remove a logged food item
  Future<void> removeLoggedFood(DateTime date, FoodItem food) async {
    try {
      final userDoc = _userDoc;
      if (userDoc == null) {
        throw Exception('User not authenticated');
      }

      final dateKey = _formatDate(date);
      await userDoc.collection('food_logs').doc(dateKey).update({
        'foods': FieldValue.arrayRemove([food.toJson()]),
      });

      if (kDebugMode) {
        print('Food removed from log');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error removing food: $e');
      }
      rethrow;
    }
  }

  // ==================== MEAL PLANS ====================

  /// Save a meal plan
  Future<void> saveMealPlan(MealPlan plan) async {
    try {
      final userDoc = _userDoc;
      if (userDoc == null) {
        throw Exception('User not authenticated');
      }

      final dateKey = _formatDate(plan.date);
      await userDoc.collection('meal_plans').doc(dateKey).set({
        'date': Timestamp.fromDate(plan.date),
        'plan': plan.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Meal plan saved for $dateKey');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving meal plan: $e');
      }
      rethrow;
    }
  }

  /// Get meal plan for a specific date
  Future<MealPlan?> getMealPlan(DateTime date) async {
    try {
      final userDoc = _userDoc;
      if (userDoc == null) return null;

      final dateKey = _formatDate(date);
      final snapshot = await userDoc
          .collection('meal_plans')
          .doc(dateKey)
          .get();

      if (!snapshot.exists) return null;

      final data = snapshot.data();
      if (data == null || !data.containsKey('plan')) return null;

      return MealPlan.fromJson(data['plan'] as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting meal plan: $e');
      }
      return null;
    }
  }

  /// Delete a meal plan
  Future<void> deleteMealPlan(DateTime date) async {
    try {
      final userDoc = _userDoc;
      if (userDoc == null) {
        throw Exception('User not authenticated');
      }

      final dateKey = _formatDate(date);
      await userDoc.collection('meal_plans').doc(dateKey).delete();

      if (kDebugMode) {
        print('Meal plan deleted for $dateKey');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting meal plan: $e');
      }
      rethrow;
    }
  }

  /// Get meal plans for a date range
  Future<List<MealPlan>> getMealPlansInRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final userDoc = _userDoc;
      if (userDoc == null) return [];

      final snapshot = await userDoc
          .collection('meal_plans')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            if (!data.containsKey('plan')) return null;
            return MealPlan.fromJson(data['plan'] as Map<String, dynamic>);
          })
          .whereType<MealPlan>()
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting meal plans in range: $e');
      }
      return [];
    }
  }

  // ==================== FAVORITES ====================

  /// Add food to favorites
  Future<void> addFavoriteFood(FoodItem food) async {
    try {
      final userDoc = _userDoc;
      if (userDoc == null) {
        throw Exception('User not authenticated');
      }

      await userDoc.collection('favorites').doc(food.id).set(food.toJson());

      if (kDebugMode) {
        print('Food added to favorites');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding favorite: $e');
      }
      rethrow;
    }
  }

  /// Get favorite foods
  Future<List<FoodItem>> getFavoriteFoods() async {
    try {
      final userDoc = _userDoc;
      if (userDoc == null) return [];

      final snapshot = await userDoc.collection('favorites').get();

      return snapshot.docs.map((doc) => FoodItem.fromJson(doc.data())).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting favorites: $e');
      }
      return [];
    }
  }

  /// Remove food from favorites
  Future<void> removeFavoriteFood(String foodId) async {
    try {
      final userDoc = _userDoc;
      if (userDoc == null) {
        throw Exception('User not authenticated');
      }

      await userDoc.collection('favorites').doc(foodId).delete();

      if (kDebugMode) {
        print('Food removed from favorites');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error removing favorite: $e');
      }
      rethrow;
    }
  }

  // ==================== HELPER METHODS ====================

  /// Format date to YYYY-MM-DD string for document IDs
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Clear all user data (for testing or account deletion)
  Future<void> clearAllUserData() async {
    try {
      final userDoc = _userDoc;
      if (userDoc == null) {
        throw Exception('User not authenticated');
      }

      // Delete all subcollections
      final collections = ['food_logs', 'meal_plans', 'favorites'];
      for (final collection in collections) {
        final snapshot = await userDoc.collection(collection).get();
        for (final doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }

      if (kDebugMode) {
        print('All user data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing user data: $e');
      }
      rethrow;
    }
  }
}
