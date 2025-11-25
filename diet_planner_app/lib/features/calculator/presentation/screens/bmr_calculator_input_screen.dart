import 'package:flutter/material.dart';

import '../../controllers/calculator_controller.dart';
import '../../models/calculator_result.dart';
import 'calculator_result_screen.dart';

class BmrCalculatorInputScreen extends StatefulWidget {
  const BmrCalculatorInputScreen({super.key});

  @override
  State<BmrCalculatorInputScreen> createState() =>
      _BmrCalculatorInputScreenState();
}

class _BmrCalculatorInputScreenState extends State<BmrCalculatorInputScreen> {
  late final CalculatorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalculatorController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMR & TDEE Calculator'),
        backgroundColor: const Color(0xFF00B4D8),
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntroCard(theme),
                  const SizedBox(height: 20),
                  _buildGenderSelector(),
                  const SizedBox(height: 16),
                  _buildNumberFields(),
                  const SizedBox(height: 16),
                  _buildHeightSlider(theme),
                  const SizedBox(height: 16),
                  _buildActivityDropdown(),
                  const SizedBox(height: 16),
                  _buildGoalSelector(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleCalculate,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF00B4D8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Calculate',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIntroCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00B4D8), Color(0xFF90E0EF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Colors.white,
            size: 42,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Discover your energy needs with clinically backed formulas.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Gender'),
        const SizedBox(height: 8),
        Row(
          children: Gender.values
              .map(
                (gender) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(gender == Gender.male ? 'Male' : 'Female'),
                      selected: _controller.gender == gender,
                      onSelected: (_) => _controller.updateGender(gender),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildNumberFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller.weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _inputDecoration('Weight (kg)', 'e.g. 72.5'),
            validator: (value) {
              final parsed = double.tryParse(value ?? '');
              if (parsed == null || parsed <= 0) {
                return 'Enter a valid weight';
              }
              return null;
            },
            onChanged: _controller.syncWeight,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _controller.ageController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration('Age', 'years'),
            validator: (value) {
              final parsed = int.tryParse(value ?? '');
              if (parsed == null || parsed <= 0) {
                return 'Enter a valid age';
              }
              return null;
            },
            onChanged: _controller.syncAge,
          ),
        ),
      ],
    );
  }

  Widget _buildHeightSlider(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionLabel('Height'),
              Text(
                '${_controller.heightCm.toStringAsFixed(0)} cm',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: _controller.heightCm,
            min: 120,
            max: 220,
            divisions: 100,
            onChanged: _controller.updateHeight,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Activity Level'),
        const SizedBox(height: 8),
        DropdownButtonFormField<ActivityLevel>(
          value: _controller.activityLevel,
          decoration: _inputDecoration(null, null),
          items: ActivityLevel.values
              .map(
                (level) =>
                    DropdownMenuItem(value: level, child: Text(level.label)),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) _controller.updateActivityLevel(value);
          },
        ),
      ],
    );
  }

  Widget _buildGoalSelector() {
    final goals = [
      CalorieGoal.weightLoss,
      CalorieGoal.maintain,
      CalorieGoal.weightGain,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Focus'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: goals
              .map(
                (goal) => ChoiceChip(
                  selected: _controller.selectedGoal == goal,
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(goal.label),
                      Text(goal.helper, style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                  onSelected: (_) => _controller.updateGoal(goal),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Future<void> _handleCalculate() async {
    final result = await _controller.calculate();
    if (!mounted || result == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CalculatorResultScreen(
          result: result,
          selectedGoal: _controller.selectedGoal,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String? label, String? hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    );
  }
}
