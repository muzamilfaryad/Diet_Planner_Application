import 'dart:collection';
import 'package:logger/logger.dart';
import '../models/meal_plan.dart';
import '../models/meal.dart';
import '../models/food_item.dart';
import 'firestore_service.dart';
import 'firebase_auth_service.dart';

final Logger _logger = Logger();

/// Service for managing meal plans with Firebase sync
class MealPlanService {
  MealPlanService._privateConstructor();
  static final MealPlanService instance = MealPlanService._privateConstructor();

  final Map<String, MealPlan> _plans = {};

  // Lazy initialization - only access when Firebase is configured
  FirestoreService? _firestore;
  FirestoreService get firestore {
    _firestore ??= FirestoreService.instance;
    return _firestore!;
  }

  FirebaseAuthService? _auth;
  FirebaseAuthService get auth {
    _auth ??= FirebaseAuthService.instance;
    return _auth!;
  }

  UnmodifiableMapView<String, MealPlan> get plans =>
      UnmodifiableMapView(_plans);

  /// Get meal plan for a specific date (creates empty one if doesn't exist)
  MealPlan getPlanForDate(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final key = _dateKey(day);
    return _plans.putIfAbsent(key, () => MealPlan.empty(day));
  }

  /// Save or update a meal plan - syncs to Firebase if user is signed in
  void savePlan(MealPlan plan) {
    final key = _dateKey(plan.date);
    _plans[key] = plan;

    // Sync to Firebase if user is signed in
    try {
      final authService = auth;
      if (authService.auth != null && authService.isSignedIn) {
        firestore.saveMealPlan(plan).catchError((e) {
          // Silently fail - Firebase not available
        });
      }
    } catch (e) {
      // Firebase not configured, skip sync - this is normal in guest mode
    }
  }

  /// Delete a meal plan - syncs deletion to Firebase
  bool deletePlan(DateTime date) {
    final key = _dateKey(date);
    final removed = _plans.remove(key) != null;

    // Sync to Firebase if user is signed in
    try {
      final authService = auth;
      if (removed && authService.auth != null && authService.isSignedIn) {
        firestore.deleteMealPlan(date).catchError((e) {
          // Silently fail - Firebase not available
        });
      }
    } catch (e) {
      // Firebase not configured, skip sync - this is normal in guest mode
    }

    return removed;
  }

  /// Add a food item to a specific meal in a plan
  void addFoodToMeal(DateTime date, MealType mealType, FoodItem food) {
    final plan = getPlanForDate(date);
    final mealIndex = plan.meals.indexWhere((m) => m.type == mealType);

    if (mealIndex != -1) {
      final meal = plan.meals[mealIndex];
      final updatedFoods = List<FoodItem>.from(meal.foods)..add(food);
      final updatedMeal = meal.copyWith(foods: updatedFoods);

      final updatedMeals = List<Meal>.from(plan.meals);
      updatedMeals[mealIndex] = updatedMeal;

      savePlan(plan.copyWith(meals: updatedMeals));
    }
  }

  /// Remove a food item from a specific meal
  bool removeFoodFromMeal(DateTime date, MealType mealType, FoodItem food) {
    final plan = getPlanForDate(date);
    final mealIndex = plan.meals.indexWhere((m) => m.type == mealType);

    if (mealIndex != -1) {
      final meal = plan.meals[mealIndex];
      final foodIndex = meal.foods.indexWhere((f) => f.id == food.id);

      if (foodIndex != -1) {
        final updatedFoods = List<FoodItem>.from(meal.foods)
          ..removeAt(foodIndex);
        final updatedMeal = meal.copyWith(foods: updatedFoods);

        final updatedMeals = List<Meal>.from(plan.meals);
        updatedMeals[mealIndex] = updatedMeal;

        savePlan(plan.copyWith(meals: updatedMeals));
        return true;
      }
    }
    return false;
  }

  /// Get all plans in date range
  List<MealPlan> getPlansInRange(DateTime start, DateTime end) {
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);

    final result = <MealPlan>[];
    for (
      var day = startDay;
      day.isBefore(endDay.add(const Duration(days: 1)));
      day = day.add(const Duration(days: 1))
    ) {
      final key = _dateKey(day);
      if (_plans.containsKey(key)) {
        result.add(_plans[key]!);
      }
    }
    return result;
  }

  /// Copy a meal plan to another date
  void copyPlanToDate(DateTime sourceDate, DateTime targetDate) {
    final sourcePlan = getPlanForDate(sourceDate);
    final targetDay = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    final newMeals = sourcePlan.meals.map((meal) {
      final dateStr = targetDay.toIso8601String().split('T')[0];
      return Meal(
        id: 'meal_${dateStr}_${meal.type.name}',
        type: meal.type,
        foods: List.from(meal.foods),
        scheduledTime: meal.scheduledTime != null
            ? DateTime(
                targetDay.year,
                targetDay.month,
                targetDay.day,
                meal.scheduledTime!.hour,
                meal.scheduledTime!.minute,
              )
            : null,
      );
    }).toList();

    final newPlan = MealPlan(
      id: 'plan_${targetDay.toIso8601String().split('T')[0]}',
      date: targetDay,
      meals: newMeals,
      notes: sourcePlan.notes,
    );

    savePlan(newPlan);
  }

  /// Update meal plan notes
  void updateNotes(DateTime date, String notes) {
    final plan = getPlanForDate(date);
    savePlan(plan.copyWith(notes: notes));
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Clear all meal plans
  void clearAll() {
    _plans.clear();
  }

  /// Load meal plans from Firebase (call after sign in)
  Future<void> loadMealPlans() async {
    try {
      final authService = auth;
      if (authService.auth == null || !authService.isSignedIn) return;

      // Load meal plans for last 30 days and next 30 days
      final now = DateTime.now();
      final start = now.subtract(const Duration(days: 30));
      final end = now.add(const Duration(days: 30));

      final plans = await firestore.getMealPlansInRange(start, end);
      for (final plan in plans) {
        final key = _dateKey(plan.date);
        _plans[key] = plan;
      }
    } catch (e) {
      // Firebase not configured or error loading
      _logger.w(
        'Firebase not available or error loading meal plans: $e',
        error: e,
      );
    }
  }

  /// Get meal plan async - fetches from Firebase if available
  Future<MealPlan?> getPlanForDateAsync(DateTime date) async {
    final day = DateTime(date.year, date.month, date.day);
    final key = _dateKey(day);

    // Check local cache first
    if (_plans.containsKey(key)) {
      return _plans[key];
    }

    // Fetch from Firebase if user is signed in
    try {
      final authService = auth;
      if (authService.auth != null && authService.isSignedIn) {
        final plan = await firestore.getMealPlan(date);
        if (plan != null) {
          _plans[key] = plan;
          return plan;
        }
      }
    } catch (e) {
      // Firebase not configured or error fetching
      _logger.w(
        'Firebase not available or error fetching meal plan: $e',
        error: e,
      );
    }

    // Return empty plan if not found
    final emptyPlan = MealPlan.empty(day);
    _plans[key] = emptyPlan;
    return emptyPlan;
  }
}
