import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  Widget _buildRecipeCard(
    BuildContext context, {
    required String title,
    required int calories,
    required int protein,
    required String imageUrl,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 6,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title details coming soon!')),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.restaurant, size: 32),
                      );
                    },
                  ),
                  // gradient overlay for legibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black26],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            size: 14,
                            color: Colors.deepOrange,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$calories kcal',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(
                        label: Text('${protein}g protein'),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha((0.08 * 255).round()),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(calories / 100).toStringAsFixed(0)} kcal / 100g',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: const Text('Recipes'),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Recipe filtering coming soon!'),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildListDelegate([
                _buildRecipeCard(
                  context,
                  title: 'Grilled Chicken Bowl',
                  calories: 450,
                  protein: 35,
                  imageUrl:
                      'https://images.unsplash.com/photo-1546793665-c74683f339c1',
                ),
                _buildRecipeCard(
                  context,
                  title: 'Quinoa Salad',
                  calories: 380,
                  protein: 12,
                  imageUrl:
                      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
                ),
                _buildRecipeCard(
                  context,
                  title: 'Salmon & Veggies',
                  calories: 520,
                  protein: 42,
                  imageUrl:
                      'https://images.unsplash.com/photo-1467003909585-2f8a72700288',
                ),
                _buildRecipeCard(
                  context,
                  title: 'Green Smoothie',
                  calories: 220,
                  protein: 15,
                  imageUrl:
                      'https://images.unsplash.com/photo-1556881286-fc6915169721',
                ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe creation coming soon!')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Recipe'),
      ),
    );
  }
}
