class Goal {
  final double dailyCalories;
  final double proteinRatio; // fraction of calories
  final double carbsRatio;
  final double fatRatio;

  Goal({
    required this.dailyCalories,
    required this.proteinRatio,
    required this.carbsRatio,
    required this.fatRatio,
  }) : assert(
         (proteinRatio + carbsRatio + fatRatio) > 0 &&
             (proteinRatio + carbsRatio + fatRatio) <= 1.5,
       );

  factory Goal.defaultGoal() => Goal(
    dailyCalories: 2000,
    proteinRatio: 0.25,
    carbsRatio: 0.5,
    fatRatio: 0.25,
  );
}
