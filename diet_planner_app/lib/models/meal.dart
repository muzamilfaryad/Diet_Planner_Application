import 'food_item.dart';

/// Represents a meal type (Breakfast, Lunch, Dinner, Snack)
enum MealType {
  breakfast,
  lunch,
  dinner,
  snack;

  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
    }
  }
}

/// Represents a single meal with multiple food items
class Meal {
  final String id;
  final MealType type;
  final List<FoodItem> foods;
  final DateTime? scheduledTime;

  Meal({
    required this.id,
    required this.type,
    required this.foods,
    this.scheduledTime,
  });

  double get totalCalories => foods.fold(0.0, (sum, f) => sum + f.calories);
  double get totalProtein => foods.fold(0.0, (sum, f) => sum + f.protein);
  double get totalCarbs => foods.fold(0.0, (sum, f) => sum + f.carbs);
  double get totalFat => foods.fold(0.0, (sum, f) => sum + f.fat);

  Meal copyWith({
    String? id,
    MealType? type,
    List<FoodItem>? foods,
    DateTime? scheduledTime,
  }) {
    return Meal(
      id: id ?? this.id,
      type: type ?? this.type,
      foods: foods ?? this.foods,
      scheduledTime: scheduledTime ?? this.scheduledTime,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'foods': foods.map((f) => f.toJson()).toList(),
        'scheduledTime': scheduledTime?.toIso8601String(),
      };

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json['id'] as String,
        type: MealType.values.firstWhere((e) => e.name == json['type']),
        foods: (json['foods'] as List<dynamic>)
            .map((f) => FoodItem.fromJson(f as Map<String, dynamic>))
            .toList(),
        scheduledTime: json['scheduledTime'] != null
            ? DateTime.parse(json['scheduledTime'] as String)
            : null,
      );
}
