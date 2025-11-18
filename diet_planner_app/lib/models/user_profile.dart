import 'goal.dart';

class UserProfile {
  final String name;
  final int age;
  final double heightCm;
  final double weightKg;
  final Goal goal;

  UserProfile({
    required this.name,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.goal,
  });

  factory UserProfile.sample() => UserProfile(
    name: 'Alex',
    age: 30,
    heightCm: 175,
    weightKg: 75,
    goal: Goal.defaultGoal(),
  );
}
