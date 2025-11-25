import 'package:flutter/material.dart';

import '../data/calculator_service.dart';
import '../models/calculator_result.dart';

class CalculatorController extends ChangeNotifier {
  CalculatorController() {
    weightController.text = _weightKg.toStringAsFixed(1);
    ageController.text = '28';
  }

  final formKey = GlobalKey<FormState>();
  final weightController = TextEditingController();
  final ageController = TextEditingController();

  Gender _gender = Gender.male;
  double _heightCm = 170;
  double _weightKg = 70;
  ActivityLevel _activityLevel = ActivityLevel.moderate;
  CalorieGoal _selectedGoal = CalorieGoal.weightLoss;
  CalculatorResult? _result;

  Gender get gender => _gender;
  double get heightCm => _heightCm;
  double get weightKg => _weightKg;
  ActivityLevel get activityLevel => _activityLevel;
  CalorieGoal get selectedGoal => _selectedGoal;
  CalculatorResult? get result => _result;

  void updateGender(Gender value) {
    _gender = value;
    notifyListeners();
  }

  void updateHeight(double value) {
    _heightCm = value;
    notifyListeners();
  }

  void updateActivityLevel(ActivityLevel value) {
    _activityLevel = value;
    notifyListeners();
  }

  void updateGoal(CalorieGoal value) {
    _selectedGoal = value;
    notifyListeners();
  }

  void syncWeight(String value) {
    final parsed = double.tryParse(value);
    if (parsed != null && parsed > 0) {
      _weightKg = parsed;
    }
  }

  void syncAge(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null && parsed > 0) {
      _age = parsed;
    }
  }

  int _age = 28;

  Future<CalculatorResult?> calculate() async {
    if (!(formKey.currentState?.validate() ?? false)) return null;

    _result = CalculatorService.instance.calculate(
      gender: _gender,
      weightKg: _weightKg,
      heightCm: _heightCm,
      age: _age,
      activityLevel: _activityLevel,
    );
    notifyListeners();
    return _result;
  }

  @override
  void dispose() {
    weightController.dispose();
    ageController.dispose();
    super.dispose();
  }
}
