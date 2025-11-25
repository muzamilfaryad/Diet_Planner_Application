import '../models/calculator_result.dart';

class CalculatorService {
  CalculatorService._();

  static final CalculatorService instance = CalculatorService._();

  CalculatorResult calculate({
    required Gender gender,
    required double weightKg,
    required double heightCm,
    required int age,
    required ActivityLevel activityLevel,
  }) {
    final bmr = _calculateBmr(
      gender: gender,
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
    );

    final tdee = bmr * activityLevel.factor;

    final targets = <CalorieGoal, double>{
      CalorieGoal.maintain: tdee,
      CalorieGoal.weightLoss: (tdee - 500).clamp(1200, double.infinity),
      CalorieGoal.weightGain: tdee + 500,
    };

    return CalculatorResult(bmr: bmr, tdee: tdee, calorieTargets: targets);
  }

  double _calculateBmr({
    required Gender gender,
    required double weightKg,
    required double heightCm,
    required int age,
  }) {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    return gender == Gender.male ? base + 5 : base - 161;
  }
}
