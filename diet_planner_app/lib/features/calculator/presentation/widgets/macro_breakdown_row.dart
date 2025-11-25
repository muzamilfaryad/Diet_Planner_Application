import 'package:flutter/material.dart';

import '../../models/calculator_result.dart';

class MacroBreakdownRow extends StatelessWidget {
  const MacroBreakdownRow({super.key, required this.macros});

  final MacroTargets macros;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      _MacroTile(
        label: 'Protein',
        grams: macros.protein,
        color: const Color(0xFF00B4D8),
      ),
      _MacroTile(
        label: 'Carbs',
        grams: macros.carbs,
        color: const Color(0xFFFFB703),
      ),
      _MacroTile(
        label: 'Fat',
        grams: macros.fat,
        color: const Color(0xFF06D6A0),
      ),
    ];

    return Row(
      children: items
          .map(
            (tile) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tile.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: tile.color.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tile.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: tile.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${tile.grams.toStringAsFixed(0)} g',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MacroTile {
  _MacroTile({required this.label, required this.grams, required this.color});

  final String label;
  final double grams;
  final Color color;
}
