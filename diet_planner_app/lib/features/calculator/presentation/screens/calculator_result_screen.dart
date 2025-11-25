import 'package:flutter/material.dart';

import '../../models/calculator_result.dart';
import '../widgets/macro_breakdown_row.dart';

class CalculatorResultScreen extends StatelessWidget {
  const CalculatorResultScreen({
    super.key,
    required this.result,
    required this.selectedGoal,
  });

  final CalculatorResult result;
  final CalorieGoal selectedGoal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goalMacros = result.macrosFor(selectedGoal);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Personal Plan'),
        backgroundColor: const Color(0xFF00B4D8),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildPrimaryStatsCard(theme),
          const SizedBox(height: 16),
          _buildGoalCard(theme),
          const SizedBox(height: 16),
          _buildMacroCard(theme, goalMacros),
          const SizedBox(height: 24),
          Text(
            'Tip: Recalculate every time your weight changes by 5 kg or your activity shifts.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryStatsCard(ThemeData theme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Metabolism Snapshot',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'BMR',
                    value: '${result.bmr.toStringAsFixed(0)} kcal',
                    helper: 'Resting burn',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    label: 'TDEE',
                    value: '${result.tdee.toStringAsFixed(0)} kcal',
                    helper: 'Daily energy burn',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(ThemeData theme) {
    final loss = result.calorieTargets[CalorieGoal.weightLoss];
    final gain = result.calorieTargets[CalorieGoal.weightGain];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calorie Targets',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _GoalRow(
              goal: CalorieGoal.weightLoss,
              calories: loss ?? result.tdee,
            ),
            const Divider(height: 24),
            _GoalRow(goal: CalorieGoal.maintain, calories: result.tdee),
            const Divider(height: 24),
            _GoalRow(
              goal: CalorieGoal.weightGain,
              calories: gain ?? result.tdee,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroCard(ThemeData theme, MacroTargets macros) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Macro Blueprint (${selectedGoal.label})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Based on ${macros.calories.toStringAsFixed(0)} kcal/day',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            MacroBreakdownRow(macros: macros),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.helper,
  });

  final String label;
  final String value;
  final String helper;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            helper,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({required this.goal, required this.calories});

  final CalorieGoal goal;
  final double calories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.flag_circle, color: goal.color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goal.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                goal.helper,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${calories.toStringAsFixed(0)} kcal',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
