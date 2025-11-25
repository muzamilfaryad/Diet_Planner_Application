import 'package:flutter/material.dart';

import '../models/food_item.dart';
import 'macro_progress_bar2.dart';

class CalorieSummary extends StatelessWidget {
  final double caloriesConsumed;
  final double goalCalories;
  final List<FoodItem> recentFoods;

  const CalorieSummary({
    super.key,
    required this.caloriesConsumed,
    required this.goalCalories,
    required this.recentFoods,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (caloriesConsumed / goalCalories).clamp(0.0, 1.0);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calories',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${caloriesConsumed.toStringAsFixed(0)} / ${goalCalories.toStringAsFixed(0)} kcal',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                SizedBox(
                  width: 80,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MacroProgressBar2(proteinPct: 0.25, carbsPct: 0.5, fatPct: 0.25),
            const SizedBox(height: 12),
            if (recentFoods.isNotEmpty) ...[
              Text('Recent', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 6),
              SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentFoods.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final f = recentFoods[i];
                    return Chip(
                      label: Text(
                        '${f.name} · ${f.calories.toStringAsFixed(0)}',
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
