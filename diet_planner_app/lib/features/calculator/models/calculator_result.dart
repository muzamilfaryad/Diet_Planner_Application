import 'package:flutter/material.dart';

enum Gender { male, female }

enum ActivityLevel { sedentary, light, moderate, veryActive, extremelyActive }

enum CalorieGoal { maintain, weightLoss, weightGain }

extension ActivityLevelX on ActivityLevel {
  String get label {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentary · little or no exercise';
      case ActivityLevel.light:
        return 'Light · 1-2 workouts / week';
      case ActivityLevel.moderate:
        return 'Moderate · 3-4 workouts / week';
      case ActivityLevel.veryActive:
        return 'Very Active · 5-6 workouts';
      case ActivityLevel.extremelyActive:
        return 'Extremely Active · 2x per day';
    }
  }

  double get factor {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.light:
        return 1.375;
      case ActivityLevel.moderate:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extremelyActive:
        return 1.9;
    }
  }
}

extension CalorieGoalX on CalorieGoal {
  String get label {
    switch (this) {
      case CalorieGoal.maintain:
        return 'Maintain';
      case CalorieGoal.weightLoss:
        return 'Weight Loss';
      case CalorieGoal.weightGain:
        return 'Weight Gain';
    }
  }

  String get helper {
    switch (this) {
      case CalorieGoal.maintain:
        return 'Keep your current weight';
      case CalorieGoal.weightLoss:
        return 'Approx. -0.5 kg per week (-500 kcal)';
      case CalorieGoal.weightGain:
        return 'Gradual lean gain (+500 kcal)';
    }
  }

  Color get color {
    switch (this) {
      case CalorieGoal.maintain:
        return Colors.blueGrey;
      case CalorieGoal.weightLoss:
        return const Color(0xFF06D6A0);
      case CalorieGoal.weightGain:
        return const Color(0xFFFFB703);
    }
  }
}

class MacroTargets {
  const MacroTargets({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final double calories;
  final double protein;
  final double carbs;
  final double fat;
}

class CalculatorResult {
  CalculatorResult({
    required this.bmr,
    required this.tdee,
    required this.calorieTargets,
  });

  final double bmr;
  final double tdee;
  final Map<CalorieGoal, double> calorieTargets;

  MacroTargets macrosFor(CalorieGoal goal) {
    final calories = calorieTargets[goal] ?? tdee;
    const proteinRatio = 0.30;
    const carbsRatio = 0.45;
    const fatRatio = 0.25;

    final protein = calories * proteinRatio / 4;
    final carbs = calories * carbsRatio / 4;
    final fat = calories * fatRatio / 9;

    return MacroTargets(
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
    );
  }
}
