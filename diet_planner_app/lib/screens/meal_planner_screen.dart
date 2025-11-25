import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../models/meal_plan.dart';
import '../models/food_item.dart';
import '../models/user_profile.dart';
import '../services/meal_plan_service.dart';
import '../widgets/food_search.dart';

class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  final _planService = MealPlanService.instance;
  final _profile = UserProfile.sample();

  DateTime _selectedDate = DateTime.now();
  MealPlan? _currentPlan;

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  void _loadPlan() {
    setState(() {
      _currentPlan = _planService.getPlanForDate(_selectedDate);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _loadPlan();
      });
    }
  }

  void _addFoodToMeal(MealType mealType) async {
    final result = await showModalBottomSheet<FoodItem>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Food to ${mealType.displayName}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: FoodSearch(
                    onAdd: (food) {
                      Navigator.pop(context, food);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null) {
      _planService.addFoodToMeal(_selectedDate, mealType, result);
      _loadPlan();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${result.name} to ${mealType.displayName}'),
          ),
        );
      }
    }
  }

  void _removeFoodFromMeal(MealType mealType, FoodItem food) {
    final removed = _planService.removeFoodFromMeal(
      _selectedDate,
      mealType,
      food,
    );
    if (removed) {
      _loadPlan();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed ${food.name}'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              _planService.addFoodToMeal(_selectedDate, mealType, food);
              _loadPlan();
            },
          ),
        ),
      );
    }
  }

  void _showPlanOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Plan to Another Day'),
              onTap: () async {
                if (!mounted) return;
                Navigator.pop(context);
                final targetDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate.add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (targetDate == null) return;
                if (!mounted) return;

                _planService.copyPlanToDate(_selectedDate, targetDate);

                if (!mounted) return;
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Plan copied to ${targetDate.month}/${targetDate.day}/${targetDate.year}',
                      ),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text('Add Notes'),
              onTap: () async {
                if (!mounted) return;
                Navigator.pop(context);
                final controller = TextEditingController(
                  text: _currentPlan?.notes ?? '',
                );
                final notes = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Meal Plan Notes'),
                    content: TextField(
                      controller: controller,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Add notes about this meal plan...',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, controller.text),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                );
                if (!mounted) return;
                if (notes != null) {
                  _planService.updateNotes(_selectedDate, notes);
                  _loadPlan();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Clear Plan'),
              onTap: () {
                Navigator.pop(context);
                final deleted = _planService.deletePlan(_selectedDate);
                if (deleted) {
                  _loadPlan();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Meal plan cleared')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPlan == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final goalCalories = _profile.goal.dailyCalories;
    final planCalories = _currentPlan!.totalCalories;
    final calorieProgress = goalCalories > 0
        ? (planCalories / goalCalories).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Meal Planner'),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: _showPlanOptions,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Selector
                  Card(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selected Date',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nutrition Summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Daily Totals',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${planCalories.toStringAsFixed(0)} / ${goalCalories.toStringAsFixed(0)} kcal',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: calorieProgress,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildMacroChip(
                                'Protein',
                                _currentPlan!.totalProtein,
                                'g',
                                Colors.red,
                              ),
                              _buildMacroChip(
                                'Carbs',
                                _currentPlan!.totalCarbs,
                                'g',
                                Colors.blue,
                              ),
                              _buildMacroChip(
                                'Fat',
                                _currentPlan!.totalFat,
                                'g',
                                Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Notes section
                  if (_currentPlan!.notes != null &&
                      _currentPlan!.notes!.isNotEmpty)
                    Card(
                      color: Colors.amber.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.note, color: Colors.amber),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _currentPlan!.notes!,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Meals List
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final meal = _currentPlan!.meals[index];
              return _buildMealCard(meal);
            }, childCount: _currentPlan!.meals.length),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Quick add to next meal
          final now = TimeOfDay.now();
          final hour = now.hour;
          MealType nextMeal;
          if (hour < 10) {
            nextMeal = MealType.breakfast;
          } else if (hour < 14) {
            nextMeal = MealType.lunch;
          } else if (hour < 19) {
            nextMeal = MealType.dinner;
          } else {
            nextMeal = MealType.snack;
          }
          _addFoodToMeal(nextMeal);
        },
        icon: const Icon(Icons.add),
        label: const Text('Quick Add'),
      ),
    );
  }

  Widget _buildMacroChip(String label, double value, String unit, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${value.toStringAsFixed(1)}$unit',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(Meal meal) {
    final theme = Theme.of(context);
    final isEmpty = meal.foods.isEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getMealIcon(meal.type),
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.type.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (meal.scheduledTime != null)
                        Text(
                          '${meal.scheduledTime!.hour.toString().padLeft(2, '0')}:${meal.scheduledTime!.minute.toString().padLeft(2, '0')}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                if (!isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(
                        (0.1 * 255).round(),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${meal.totalCalories.toStringAsFixed(0)} kcal',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _addFoodToMeal(meal.type),
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
          if (isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: InkWell(
                onTap: () => _addFoodToMeal(meal.type),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Add foods to ${meal.type.displayName.toLowerCase()}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Column(
              children: meal.foods.map((food) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  title: Text(food.name),
                  subtitle: Text(
                    'P: ${food.protein}g · C: ${food.carbs}g · F: ${food.fat}g',
                    style: theme.textTheme.bodySmall,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${food.calories.toStringAsFixed(0)} kcal',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => _removeFoodFromMeal(meal.type, food),
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  IconData _getMealIcon(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return Icons.free_breakfast;
      case MealType.lunch:
        return Icons.lunch_dining;
      case MealType.dinner:
        return Icons.dinner_dining;
      case MealType.snack:
        return Icons.cookie;
    }
  }
}
