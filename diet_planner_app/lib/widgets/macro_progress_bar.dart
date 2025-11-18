import 'package:flutter/material.dart';

class MacroProgressBar extends StatelessWidget {
  final double proteinPct;
  final double carbsPct;
  final double fatPct;

  const MacroProgressBar({
    super.key,
    required this.proteinPct,
    required this.carbsPct,
    required this.fatPct,
  });

  Widget _buildBar(
    BuildContext context,
    Color color,
    double pct,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            Text(
              '${(pct * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct.clamp(0.0, 1.0),
            backgroundColor: color.withValues(alpha: 40),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        _buildBar(context, theme.colorScheme.primary, proteinPct, 'Protein'),
        const SizedBox(height: 8),
        _buildBar(context, theme.colorScheme.secondary, carbsPct, 'Carbs'),
        const SizedBox(height: 8),
        _buildBar(context, theme.colorScheme.tertiary, fatPct, 'Fat'),
      ],
    );
  }
}
