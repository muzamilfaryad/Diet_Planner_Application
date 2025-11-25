import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/food_database_service.dart';
import 'log_food_screen.dart';
import 'meal_planner_screen.dart';
import 'progress_screen.dart';
import 'recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Small data holder for stat cards
class _StatItem {
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  _StatItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });
}

// Widget for stat card
class _StatCard extends StatelessWidget {
  final _StatItem item;
  const _StatCard(this.item);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 220,
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.06 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: item.color.withAlpha((0.06 * 255).round())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              item.title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Optional progress indicator for protein target (parses numbers from value and subtitle)
          if (item.title.toLowerCase().contains('protein')) ...[
            Builder(
              builder: (context) {
                try {
                  final valMatch = RegExp(
                    r"([0-9]+\.?[0-9]*)",
                  ).firstMatch(item.value);
                  final targetMatch = RegExp(
                    r"([0-9]+\.?[0-9]*)",
                  ).firstMatch(item.subtitle);
                  final val = valMatch != null
                      ? double.tryParse(valMatch.group(1) ?? '0') ?? 0
                      : 0;
                  final targ = targetMatch != null
                      ? double.tryParse(targetMatch.group(1) ?? '0') ?? 0
                      : 0;
                  final pct = targ > 0 ? (val / targ).clamp(0.0, 1.0) : 0.0;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: pct,
                        color: item.color,
                        backgroundColor: item.color.withAlpha(
                          (0.12 * 255).round(),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  );
                } catch (_) {
                  return Text(
                    item.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  );
                }
              },
            ),
          ] else ...[
            Expanded(
              child: Text(
                item.subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final _db = FoodDatabaseService.instance;
  final _profile = UserProfile.sample();

  void _onAddFood(_) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildOverview(context),
      LogFoodScreen(onAdd: _onAddFood),
      const MealPlannerScreen(),
      const ProgressScreen(),
      const RecipeScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOutCubic,
        child: screens[_index],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _index = 1),
        label: const Text('Log Food'),
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_outlined),
            selectedIcon: Icon(Icons.add),
            label: 'Log',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Recipes',
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(BuildContext context) {
    final today = DateTime.now();
    final calories = _db.caloriesFor(today);
    final theme = Theme.of(context);
    // New modern overview layout: gradient header, stat cards and meal list
    // compute protein consumed today from logged foods
    final loggedAll = _db.getLoggedFoods(today).toList();
    final proteinConsumed = loggedAll.fold<double>(
      0.0,
      (sum, f) => sum + (f.protein),
    );
    final targetProteinGrams =
        (_profile.goal.dailyCalories * _profile.goal.proteinRatio) / 4.0;

    final statItems = [
      _StatItem(
        title: 'Calories',
        value: '${calories.toStringAsFixed(0)} kcal',
        subtitle: '${_profile.goal.dailyCalories.toStringAsFixed(0)} goal',
        color: theme.colorScheme.primary,
      ),
      _StatItem(
        title: 'Protein',
        value: '${proteinConsumed.toStringAsFixed(0)} g',
        subtitle: 'Target ${targetProteinGrams.toStringAsFixed(0)} g',
        color: Colors.deepOrange,
      ),
      _StatItem(
        title: 'Water',
        value: '— ml',
        subtitle: 'Track water in diary',
        color: Colors.blueAccent,
      ),
    ];

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withAlpha((0.95 * 255).round()),
                    theme.colorScheme.primaryContainer.withAlpha(
                      (0.9 * 255).round(),
                    ),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'greeting',
                          child: Text(
                            'Good day, ${_profile.name}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${DateTime.now().toLocal().toString().split(' ')[0]} · ${_profile.goal.dailyCalories.toStringAsFixed(0)} kcal goal',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 36,
                          child: TextField(
                            onTap: () => setState(() => _index = 4),
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'Search recipes, foods...'
                                  .toUpperCase(),
                              filled: true,
                              fillColor: Colors.white.withAlpha(
                                (0.12 * 255).round(),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white70,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Hero(
                    tag: 'avatar',
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Text(
                        _profile.name.isNotEmpty ? _profile.name[0] : '?',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) => _StatCard(statItems[i]),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: statItems.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Meals',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _index = 1),
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: _buildRecentList(),
          ),
        ],
      ),
    );
  }

  // (moved stat helper classes to file bottom)

  Widget _buildRecentList() {
    final today = DateTime.now();
    final logged = _db.getLoggedFoods(today).reversed.toList();

    if (logged.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No foods logged today',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => setState(() => _index = 1),
                icon: const Icon(Icons.add),
                label: const Text('Add Food'),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, i) {
        if (i >= logged.length) return null;
        final f = logged[i];
        return AnimatedContainer(
          duration: Duration(milliseconds: 200 + (i * 50)),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(
              f.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              '${f.calories.toStringAsFixed(0)} kcal · P: ${f.protein}g · C: ${f.carbs}g · F: ${f.fat}g',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () async {
                final today = DateTime.now();
                // Show bottom sheet with options
                showModalBottomSheet<void>(
                  context: context,
                  builder: (context) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit'),
                          onTap: () async {
                            Navigator.pop(context);
                            final nameController = TextEditingController(
                              text: f.name,
                            );
                            final caloriesController = TextEditingController(
                              text: f.calories.toStringAsFixed(0),
                            );
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Edit Food'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Name',
                                      ),
                                    ),
                                    TextField(
                                      controller: caloriesController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      decoration: const InputDecoration(
                                        labelText: 'Calories',
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            );

                            // Guard against using the State's BuildContext after an async gap
                            if (!mounted) return;

                            if (result == true) {
                              final newName = nameController.text.trim();
                              final newCalories =
                                  double.tryParse(caloriesController.text) ??
                                  f.calories;
                              // Remove the old instance and log the updated one
                              final removed = _db.removeLoggedFood(today, f);
                              final updated = f.copyWith(
                                name: newName.isEmpty ? f.name : newName,
                                calories: newCalories,
                              );
                              _db.logFood(today, updated);
                              if (removed) {
                                setState(() {});
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(
                                    content: Text('Updated ${updated.name}'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Delete'),
                          onTap: () {
                            Navigator.pop(context);
                            final removed = _db.removeLoggedFood(today, f);
                            if (removed) {
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Deleted ${f.name}'),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () {
                                      _db.logFood(today, f);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
