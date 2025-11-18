import 'package:flutter/material.dart';

class MacroProgressBar2 extends StatelessWidget {
  final double proteinPct;
  final double carbsPct;
  final double fatPct;

  const MacroProgressBar2({
    super.key,
    required this.proteinPct,
    required this.carbsPct,
    required this.fatPct,
  });

  Widget _bar(BuildContext context, Color color, double pct) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: pct.clamp(0.0, 1.0),
            color: color,
            backgroundColor: Colors.grey.shade200,
            minHeight: 8,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 48,
          child: Text(
            '${(pct * 100).toStringAsFixed(0)}%',
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _bar(context, Colors.green.shade400, proteinPct),
        const SizedBox(height: 6),
        _bar(context, Colors.blue.shade400, carbsPct),
        const SizedBox(height: 6),
        _bar(context, Colors.orange.shade400, fatPct),
      ],
    );
  }
}
