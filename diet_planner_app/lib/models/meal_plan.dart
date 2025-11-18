import 'meal.dart';

/// Represents a complete meal plan for a specific date
class MealPlan {
  final String id;
  final DateTime date;
  final List<Meal> meals;
  final String? notes;

  MealPlan({
    required this.id,
    required this.date,
    required this.meals,
    this.notes,
  });

  double get totalCalories => meals.fold(0.0, (sum, m) => sum + m.totalCalories);
  double get totalProtein => meals.fold(0.0, (sum, m) => sum + m.totalProtein);
  double get totalCarbs => meals.fold(0.0, (sum, m) => sum + m.totalCarbs);
  double get totalFat => meals.fold(0.0, (sum, m) => sum + m.totalFat);

  MealPlan copyWith({
    String? id,
    DateTime? date,
    List<Meal>? meals,
    String? notes,
  }) {
    return MealPlan(
      id: id ?? this.id,
      date: date ?? this.date,
      meals: meals ?? this.meals,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'meals': meals.map((m) => m.toJson()).toList(),
        'notes': notes,
      };

  factory MealPlan.fromJson(Map<String, dynamic> json) => MealPlan(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        meals: (json['meals'] as List<dynamic>)
            .map((m) => Meal.fromJson(m as Map<String, dynamic>))
            .toList(),
        notes: json['notes'] as String?,
      );

  /// Creates an empty meal plan for a given date with default meal types
  factory MealPlan.empty(DateTime date) {
    final dateStr = date.toIso8601String().split('T')[0];
    return MealPlan(
      id: 'plan_$dateStr',
      date: DateTime(date.year, date.month, date.day),
      meals: [
        Meal(
          id: 'meal_${dateStr}_breakfast',
          type: MealType.breakfast,
          foods: [],
          scheduledTime: DateTime(date.year, date.month, date.day, 8, 0),
        ),
        Meal(
          id: 'meal_${dateStr}_lunch',
          type: MealType.lunch,
          foods: [],
          scheduledTime: DateTime(date.year, date.month, date.day, 12, 30),
        ),
        Meal(
          id: 'meal_${dateStr}_dinner',
          type: MealType.dinner,
          foods: [],
          scheduledTime: DateTime(date.year, date.month, date.day, 18, 30),
        ),
        Meal(
          id: 'meal_${dateStr}_snack',
          type: MealType.snack,
          foods: [],
        ),
      ],
    );
  }
}
