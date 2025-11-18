import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/food_database_service.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FoodDatabaseService.instance;
    final now = DateTime.now();
    final days = List.generate(7, (i) => now.subtract(Duration(days: i)));
    final profile = UserProfile.sample();
    final goal = profile.goal.dailyCalories;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF00B4D8),
            const Color(0xFF90E0EF).withValues(alpha: 0.3),
            const Color(0xFFF8F9FA),
          ],
          stops: const [0.0, 0.3, 0.6],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress 📈',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track your journey',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: days.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, i) {
                  final d = days[i];
                  final cals = db.caloriesFor(d);
                  final pct = (goal <= 0) ? 0.0 : (cals / goal).clamp(0.0, 1.0);
                  final isToday = i == 0;

                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 400 + (i * 50)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(opacity: value, child: child),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: isToday
                            ? const LinearGradient(
                                colors: [Color(0xFF00B4D8), Color(0xFF90E0EF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isToday ? null : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isToday
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : const Color(
                                      0xFF00B4D8,
                                    ).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: CircularProgressIndicator(
                                    value: pct,
                                    strokeWidth: 6,
                                    color: isToday
                                        ? Colors.white
                                        : const Color(0xFF00B4D8),
                                    backgroundColor: isToday
                                        ? Colors.white.withValues(alpha: 0.3)
                                        : const Color(
                                            0xFF00B4D8,
                                          ).withValues(alpha: 0.2),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${(pct * 100).toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isToday
                                            ? Colors.white
                                            : const Color(0xFF00B4D8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      isToday
                                          ? 'Today'
                                          : '${d.month}/${d.day}/${d.year}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: isToday
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    if (isToday) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Text(
                                          'Current',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.local_fire_department_rounded,
                                      size: 16,
                                      color: isToday
                                          ? Colors.white.withValues(alpha: 0.8)
                                          : Colors.orange,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${cals.toStringAsFixed(0)} kcal',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isToday
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      ' / ${goal.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isToday
                                            ? Colors.white.withValues(
                                                alpha: 0.7,
                                              )
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            pct >= 0.9
                                ? Icons.check_circle_rounded
                                : pct >= 0.5
                                ? Icons.trending_up_rounded
                                : Icons.circle_outlined,
                            color: isToday
                                ? Colors.white
                                : pct >= 0.9
                                ? const Color(0xFF06D6A0)
                                : const Color(
                                    0xFF00B4D8,
                                  ).withValues(alpha: 0.5),
                            size: 32,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
