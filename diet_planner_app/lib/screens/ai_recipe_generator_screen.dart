import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../services/huggingface_ai_service.dart';

class AIRecipeGeneratorScreen extends StatefulWidget {
  const AIRecipeGeneratorScreen({super.key});

  @override
  State<AIRecipeGeneratorScreen> createState() =>
      _AIRecipeGeneratorScreenState();
}

class _AIRecipeGeneratorScreenState extends State<AIRecipeGeneratorScreen> {
  final _hfService = HuggingFaceAIService.instance;
  final _geminiService = AIService.instance;
  final _ingredientsController = TextEditingController();
  final List<String> _ingredients = [];

  String? _dietaryRestrictions;
  String? _cuisineType;
  int? _targetCalories;

  Map<String, dynamic>? _generatedRecipe;
  bool _isLoading = false;

  @override
  void dispose() {
    _ingredientsController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    if (_ingredientsController.text.trim().isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientsController.text.trim());
        _ingredientsController.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  Future<void> _generateRecipe() async {
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one ingredient')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic>? recipe;
      if (_geminiService.isConfigured) {
        recipe = await _geminiService.generateRecipe(
          ingredients: _ingredients,
          dietaryRestrictions: _dietaryRestrictions,
          cuisineType: _cuisineType,
          targetCalories: _targetCalories,
        );
      }

      recipe ??= await _hfService.generateRecipe(
        ingredients: _ingredients,
        dietaryRestrictions: _dietaryRestrictions,
        cuisineType: _cuisineType,
        targetCalories: _targetCalories,
      );

      if (recipe == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Unable to generate a recipe right now. Please try again.',
              ),
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      setState(() {
        _generatedRecipe = recipe;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error generating recipe: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('AI Recipe Generator'),
          ],
        ),
        backgroundColor: const Color(0xFF00B4D8),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _generatedRecipe != null ? _buildRecipeView() : _buildInputView(),
    );
  }

  Widget _buildInputView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00B4D8), Color(0xFF90E0EF)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.restaurant_menu_rounded,
                  color: Colors.white,
                  size: 48,
                ),
                SizedBox(height: 12),
                Text(
                  'Create Custom Recipes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'AI will create a unique recipe based on your ingredients and preferences',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Ingredients input
          Text(
            'Your Ingredients',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ingredientsController,
                  decoration: InputDecoration(
                    hintText: 'Enter an ingredient',
                    prefixIcon: const Icon(Icons.add_shopping_cart_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (_) => _addIngredient(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addIngredient,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Ingredients list
          if (_ingredients.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _ingredients.asMap().entries.map((entry) {
                return Chip(
                  label: Text(entry.value),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => _removeIngredient(entry.key),
                  backgroundColor: const Color(
                    0xFF90E0EF,
                  ).withValues(alpha: 0.2),
                );
              }).toList(),
            ),

          const SizedBox(height: 24),

          // Preferences
          Text(
            'Preferences (Optional)',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Dietary restrictions
          DropdownButtonFormField<String>(
            initialValue: _dietaryRestrictions,
            decoration: InputDecoration(
              labelText: 'Dietary Restrictions',
              prefixIcon: const Icon(Icons.no_food_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              DropdownMenuItem(value: null, child: Text('None')),
              DropdownMenuItem(value: 'Vegetarian', child: Text('Vegetarian')),
              DropdownMenuItem(value: 'Vegan', child: Text('Vegan')),
              DropdownMenuItem(
                value: 'Gluten-Free',
                child: Text('Gluten-Free'),
              ),
              DropdownMenuItem(value: 'Dairy-Free', child: Text('Dairy-Free')),
              DropdownMenuItem(value: 'Keto', child: Text('Keto')),
              DropdownMenuItem(value: 'Paleo', child: Text('Paleo')),
            ],
            onChanged: (value) => setState(() => _dietaryRestrictions = value),
          ),

          const SizedBox(height: 16),

          // Cuisine type
          DropdownButtonFormField<String>(
            initialValue: _cuisineType,
            decoration: InputDecoration(
              labelText: 'Cuisine Type',
              prefixIcon: const Icon(Icons.public_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              DropdownMenuItem(value: null, child: Text('Any')),
              DropdownMenuItem(value: 'Italian', child: Text('Italian')),
              DropdownMenuItem(value: 'Mexican', child: Text('Mexican')),
              DropdownMenuItem(value: 'Asian', child: Text('Asian')),
              DropdownMenuItem(value: 'Indian', child: Text('Indian')),
              DropdownMenuItem(
                value: 'Mediterranean',
                child: Text('Mediterranean'),
              ),
              DropdownMenuItem(value: 'American', child: Text('American')),
            ],
            onChanged: (value) => setState(() => _cuisineType = value),
          ),

          const SizedBox(height: 16),

          // Target calories
          TextField(
            decoration: InputDecoration(
              labelText: 'Target Calories (per serving)',
              prefixIcon: const Icon(Icons.local_fire_department_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'e.g., 500',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _targetCalories = int.tryParse(value);
              });
            },
          ),

          const SizedBox(height: 32),

          // Generate button
          ElevatedButton(
            onPressed: _isLoading ? null : _generateRecipe,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome_rounded),
                      SizedBox(width: 8),
                      Text(
                        'Generate Recipe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeView() {
    final recipe = _generatedRecipe!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header image placeholder with gradient
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00B4D8), Color(0xFF90E0EF)],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.restaurant_rounded,
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          recipe['name'] ?? 'Generated Recipe',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: SafeArea(
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => setState(() => _generatedRecipe = null),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                if (recipe['description'] != null)
                  Text(
                    recipe['description'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),

                const SizedBox(height: 20),

                // Stats
                Row(
                  children: [
                    _buildStatChip(
                      Icons.people_rounded,
                      '${recipe['servings'] ?? 1} servings',
                    ),
                    const SizedBox(width: 8),
                    _buildStatChip(
                      Icons.timer_rounded,
                      recipe['prepTime'] ?? 'N/A',
                    ),
                    const SizedBox(width: 8),
                    _buildStatChip(
                      Icons.local_fire_department_rounded,
                      '${recipe['calories'] ?? 0} cal',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Nutrition
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF90E0EF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNutritionItem(
                        'Protein',
                        '${recipe['protein'] ?? 0}g',
                        Colors.red,
                      ),
                      _buildNutritionItem(
                        'Carbs',
                        '${recipe['carbs'] ?? 0}g',
                        Colors.orange,
                      ),
                      _buildNutritionItem(
                        'Fat',
                        '${recipe['fat'] ?? 0}g',
                        Colors.green,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Ingredients
                const Text(
                  'Ingredients',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...((recipe['ingredients'] as List?) ?? []).map((ingredient) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 20,
                          color: Color(0xFF00B4D8),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ingredient.toString(),
                            style: const TextStyle(fontSize: 15, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Instructions
                const Text(
                  'Instructions',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...((recipe['instructions'] as List?) ?? [])
                    .asMap()
                    .entries
                    .map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFF00B4D8),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${entry.key + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.value.toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                // Tips
                if (recipe['tips'] != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_rounded,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Chef\'s Tip',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                recipe['tips'].toString(),
                                style: const TextStyle(height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            setState(() => _generatedRecipe = null),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Generate New'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Recipe saved!')),
                          );
                        },
                        icon: const Icon(Icons.bookmark_rounded),
                        label: const Text('Save Recipe'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF00B4D8)),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
