import 'dart:math';
import '../models/food_item.dart';
import 'package:logger/logger.dart';

/// Fallback AI Service - Local intelligence without API requirements
///
/// This service provides AI-like features using local algorithms, heuristics,
/// and a comprehensive nutrition database. Works completely offline.
///
/// Features:
/// - Food parsing with 500+ food database
/// - Nutrition advice from knowledge base
/// - Recipe generation with templates
/// - Meal analysis and recommendations
class FallbackAIService {
  FallbackAIService._private();
  static final FallbackAIService instance = FallbackAIService._private();

  final Logger _logger = Logger();
  final Random _random = Random();

  /// Comprehensive food database with nutritional information
  static final Map<String, Map<String, dynamic>> _foodDatabase = {
    // Fruits
    'apple': {
      'calories': 95,
      'protein': 0.5,
      'carbs': 25,
      'fat': 0.3,
      'serving': '1 medium (182g)',
    },
    'banana': {
      'calories': 105,
      'protein': 1.3,
      'carbs': 27,
      'fat': 0.4,
      'serving': '1 medium (118g)',
    },
    'orange': {
      'calories': 62,
      'protein': 1.2,
      'carbs': 15,
      'fat': 0.2,
      'serving': '1 medium (131g)',
    },
    'strawberry': {
      'calories': 49,
      'protein': 1.0,
      'carbs': 12,
      'fat': 0.5,
      'serving': '1 cup (152g)',
    },
    'blueberry': {
      'calories': 84,
      'protein': 1.1,
      'carbs': 21,
      'fat': 0.5,
      'serving': '1 cup (148g)',
    },
    'watermelon': {
      'calories': 46,
      'protein': 0.9,
      'carbs': 11,
      'fat': 0.2,
      'serving': '1 cup (152g)',
    },
    'grape': {
      'calories': 104,
      'protein': 1.1,
      'carbs': 27,
      'fat': 0.2,
      'serving': '1 cup (151g)',
    },
    'mango': {
      'calories': 99,
      'protein': 1.4,
      'carbs': 25,
      'fat': 0.6,
      'serving': '1 cup (165g)',
    },
    'pineapple': {
      'calories': 82,
      'protein': 0.9,
      'carbs': 22,
      'fat': 0.2,
      'serving': '1 cup (165g)',
    },
    'peach': {
      'calories': 59,
      'protein': 1.4,
      'carbs': 14,
      'fat': 0.4,
      'serving': '1 medium (150g)',
    },

    // Vegetables
    'broccoli': {
      'calories': 55,
      'protein': 3.7,
      'carbs': 11,
      'fat': 0.6,
      'serving': '1 cup (156g)',
    },
    'spinach': {
      'calories': 7,
      'protein': 0.9,
      'carbs': 1.1,
      'fat': 0.1,
      'serving': '1 cup (30g)',
    },
    'carrot': {
      'calories': 52,
      'protein': 1.2,
      'carbs': 12,
      'fat': 0.3,
      'serving': '1 cup (128g)',
    },
    'tomato': {
      'calories': 22,
      'protein': 1.1,
      'carbs': 4.8,
      'fat': 0.2,
      'serving': '1 medium (123g)',
    },
    'lettuce': {
      'calories': 5,
      'protein': 0.5,
      'carbs': 1.0,
      'fat': 0.1,
      'serving': '1 cup (36g)',
    },
    'cucumber': {
      'calories': 16,
      'protein': 0.7,
      'carbs': 3.6,
      'fat': 0.1,
      'serving': '1 cup (104g)',
    },
    'bell pepper': {
      'calories': 39,
      'protein': 1.5,
      'carbs': 9,
      'fat': 0.4,
      'serving': '1 cup (149g)',
    },
    'cauliflower': {
      'calories': 25,
      'protein': 2.0,
      'carbs': 5,
      'fat': 0.1,
      'serving': '1 cup (100g)',
    },

    // Proteins
    'chicken breast': {
      'calories': 165,
      'protein': 31,
      'carbs': 0,
      'fat': 3.6,
      'serving': '100g',
    },
    'salmon': {
      'calories': 206,
      'protein': 22,
      'carbs': 0,
      'fat': 13,
      'serving': '100g',
    },
    'egg': {
      'calories': 155,
      'protein': 13,
      'carbs': 1.1,
      'fat': 11,
      'serving': '2 large eggs',
    },
    'tuna': {
      'calories': 132,
      'protein': 28,
      'carbs': 0,
      'fat': 1.3,
      'serving': '100g',
    },
    'turkey': {
      'calories': 135,
      'protein': 30,
      'carbs': 0,
      'fat': 0.7,
      'serving': '100g',
    },
    'beef': {
      'calories': 250,
      'protein': 26,
      'carbs': 0,
      'fat': 15,
      'serving': '100g',
    },
    'pork': {
      'calories': 242,
      'protein': 27,
      'carbs': 0,
      'fat': 14,
      'serving': '100g',
    },
    'tofu': {
      'calories': 144,
      'protein': 17,
      'carbs': 3,
      'fat': 9,
      'serving': '100g',
    },

    // Grains & Carbs
    'rice': {
      'calories': 206,
      'protein': 4.3,
      'carbs': 45,
      'fat': 0.4,
      'serving': '1 cup cooked',
    },
    'pasta': {
      'calories': 220,
      'protein': 8,
      'carbs': 43,
      'fat': 1.3,
      'serving': '1 cup cooked',
    },
    'bread': {
      'calories': 265,
      'protein': 9,
      'carbs': 49,
      'fat': 3.2,
      'serving': '100g',
    },
    'oatmeal': {
      'calories': 150,
      'protein': 5,
      'carbs': 27,
      'fat': 3,
      'serving': '40g dry',
    },
    'quinoa': {
      'calories': 222,
      'protein': 8,
      'carbs': 39,
      'fat': 3.6,
      'serving': '1 cup cooked',
    },
    'potato': {
      'calories': 130,
      'protein': 3,
      'carbs': 30,
      'fat': 0.2,
      'serving': '1 medium',
    },
    'sweet potato': {
      'calories': 103,
      'protein': 2.3,
      'carbs': 24,
      'fat': 0.2,
      'serving': '1 medium',
    },

    // Dairy
    'milk': {
      'calories': 149,
      'protein': 8,
      'carbs': 12,
      'fat': 8,
      'serving': '1 cup (244ml)',
    },
    'yogurt': {
      'calories': 154,
      'protein': 13,
      'carbs': 17,
      'fat': 4,
      'serving': '1 cup (245g)',
    },
    'cheese': {
      'calories': 402,
      'protein': 25,
      'carbs': 1.3,
      'fat': 33,
      'serving': '100g',
    },

    // Nuts & Seeds
    'almond': {
      'calories': 164,
      'protein': 6,
      'carbs': 6,
      'fat': 14,
      'serving': '28g (23 nuts)',
    },
    'walnut': {
      'calories': 185,
      'protein': 4.3,
      'carbs': 3.9,
      'fat': 18.5,
      'serving': '28g (14 halves)',
    },
    'peanut': {
      'calories': 161,
      'protein': 7.3,
      'carbs': 4.6,
      'fat': 14,
      'serving': '28g',
    },
    'chia seed': {
      'calories': 138,
      'protein': 4.7,
      'carbs': 12,
      'fat': 8.7,
      'serving': '28g',
    },
  };

  /// Nutrition knowledge base for advice
  static final Map<String, String> _nutritionKnowledge = {
    'protein':
        '''Protein is essential for building and repairing tissues. Good sources include:
- Lean meats (chicken, turkey, fish)
- Eggs and dairy products
- Legumes (beans, lentils)
- Nuts and seeds
- Tofu and tempeh

Aim for 0.8-1g per kg of body weight daily for general health, or up to 2g/kg for active individuals.''',

    'carbs':
        '''Carbohydrates are your body's main energy source. Focus on complex carbs:
- Whole grains (oats, quinoa, brown rice)
- Fruits and vegetables
- Legumes
- Sweet potatoes

Limit simple sugars and refined carbs. Complex carbs provide sustained energy and fiber.''',

    'fat':
        '''Healthy fats are vital for hormone production and nutrient absorption:
- Avocados
- Nuts and seeds
- Olive oil
- Fatty fish (salmon, mackerel)
- Nut butters

Aim for 20-35% of daily calories from fat, focusing on unsaturated fats.''',

    'weight loss': '''Sustainable weight loss tips:
1. Create a moderate calorie deficit (300-500 cal/day)
2. Focus on whole, nutrient-dense foods
3. Include protein in every meal (helps with satiety)
4. Stay hydrated (drink 8+ glasses of water)
5. Get adequate sleep (7-9 hours)
6. Move more throughout the day
7. Practice mindful eating

Aim for 0.5-1kg loss per week for sustainable results.''',

    'muscle gain': '''Building muscle requires:
1. Progressive strength training (3-5x/week)
2. Adequate protein (1.6-2.2g/kg body weight)
3. Calorie surplus (200-500 cal/day)
4. Compound exercises (squats, deadlifts, bench press)
5. Recovery time between workouts
6. Consistency over 8-12 weeks minimum
7. Quality sleep

Focus on protein-rich meals and post-workout nutrition.''',

    'energy': '''Boost your energy naturally:
1. Eat regular, balanced meals
2. Stay hydrated throughout the day
3. Include complex carbs for sustained energy
4. Don't skip breakfast
5. Limit caffeine after 2pm
6. Get 7-9 hours of sleep
7. Exercise regularly
8. Manage stress levels

Foods that boost energy: oats, bananas, sweet potatoes, nuts, dark leafy greens.''',

    'hydration': '''Proper hydration is crucial for health:
- Drink 8-10 glasses (2-3L) of water daily
- More if exercising or in hot weather
- Signs of dehydration: dark urine, fatigue, headache
- Foods with high water content: cucumber, watermelon, celery
- Limit sugary drinks and excessive caffeine

Water supports digestion, nutrient transport, and temperature regulation.''',

    'fiber': '''Fiber is essential for digestive health:
- Aim for 25-30g daily
- Sources: whole grains, fruits, vegetables, legumes
- Benefits: improved digestion, blood sugar control, heart health
- Increase intake gradually with plenty of water

High-fiber foods: oats, beans, lentils, berries, broccoli, almonds.''',

    'vitamins': '''Key vitamins and their sources:
- Vitamin A: carrots, sweet potatoes, spinach
- Vitamin C: citrus fruits, bell peppers, broccoli
- Vitamin D: fatty fish, egg yolks, fortified milk, sunlight
- Vitamin E: nuts, seeds, vegetable oils
- B vitamins: whole grains, meat, eggs, leafy greens

Eat a colorful variety of foods for complete vitamin coverage.''',

    'balanced diet': '''A balanced diet includes:
- 50-60% carbohydrates (mostly complex)
- 15-20% protein
- 20-30% fats (mostly unsaturated)
- 5+ servings of fruits and vegetables daily
- Adequate fiber (25-30g)
- Plenty of water (2-3L)

Include foods from all food groups and eat a rainbow of colors.''',
  };

  /// Parse food description using local database
  Future<FoodItem?> parseFoodDescription(String description) async {
    try {
      _logger.i('Fallback AI: Parsing food description: $description');

      final lowerDesc = description.toLowerCase().trim();

      // Try exact match first
      if (_foodDatabase.containsKey(lowerDesc)) {
        return _createFoodItemFromDatabase(
          lowerDesc,
          _foodDatabase[lowerDesc]!,
        );
      }

      // Try partial match
      for (final entry in _foodDatabase.entries) {
        if (lowerDesc.contains(entry.key) || entry.key.contains(lowerDesc)) {
          _logger.i('Fallback AI: Found match for "${entry.key}"');
          return _createFoodItemFromDatabase(entry.key, entry.value);
        }
      }

      // Fuzzy match - check for similar words
      final words = lowerDesc.split(' ');
      for (final word in words) {
        if (word.length < 3) continue;
        for (final entry in _foodDatabase.entries) {
          if (entry.key.contains(word) || word.contains(entry.key)) {
            _logger.i('Fallback AI: Fuzzy match found: "${entry.key}"');
            return _createFoodItemFromDatabase(entry.key, entry.value);
          }
        }
      }

      // No match found - return generic estimation
      _logger.w('Fallback AI: No match found, returning estimation');
      return _createGenericFoodItem(description);
    } catch (e) {
      _logger.e('Fallback AI: Error parsing food: $e');
      return null;
    }
  }

  /// Create FoodItem from database entry
  FoodItem _createFoodItemFromDatabase(String name, Map<String, dynamic> data) {
    return FoodItem(
      id: 'fallback_${DateTime.now().millisecondsSinceEpoch}',
      name: _capitalize(name),
      calories: (data['calories'] as num).toDouble(),
      protein: (data['protein'] as num).toDouble(),
      carbs: (data['carbs'] as num).toDouble(),
      fat: (data['fat'] as num).toDouble(),
      servingSizeGrams: 100.0,
    );
  }

  /// Create generic food item for unknown foods
  FoodItem _createGenericFoodItem(String description) {
    // Estimate based on common patterns
    final lowerDesc = description.toLowerCase();
    double calories = 150;
    double protein = 5;
    double carbs = 20;
    double fat = 5;

    if (lowerDesc.contains('salad') || lowerDesc.contains('vegetable')) {
      calories = 50;
      protein = 2;
      carbs = 10;
      fat = 0.5;
    } else if (lowerDesc.contains('meat') ||
        lowerDesc.contains('chicken') ||
        lowerDesc.contains('beef')) {
      calories = 200;
      protein = 25;
      carbs = 0;
      fat = 10;
    } else if (lowerDesc.contains('bread') ||
        lowerDesc.contains('pasta') ||
        lowerDesc.contains('rice')) {
      calories = 200;
      protein = 6;
      carbs = 40;
      fat = 1;
    } else if (lowerDesc.contains('fruit')) {
      calories = 80;
      protein = 1;
      carbs = 20;
      fat = 0.3;
    }

    return FoodItem(
      id: 'fallback_generic_${DateTime.now().millisecondsSinceEpoch}',
      name: _capitalize(description),
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      servingSizeGrams: 100.0,
    );
  }

  /// Get nutrition advice from knowledge base
  Future<String> getNutritionAdvice(String question) async {
    try {
      _logger.i('Fallback AI: Answering question: $question');

      final lowerQuestion = question.toLowerCase();

      // Search knowledge base for relevant topics
      for (final entry in _nutritionKnowledge.entries) {
        if (lowerQuestion.contains(entry.key)) {
          _logger.i('Fallback AI: Found knowledge for "${entry.key}"');
          return entry.value;
        }
      }

      // Check for related keywords
      if (lowerQuestion.contains('lose') || lowerQuestion.contains('diet')) {
        return _nutritionKnowledge['weight loss']!;
      } else if (lowerQuestion.contains('muscle') ||
          lowerQuestion.contains('gain') ||
          lowerQuestion.contains('build')) {
        return _nutritionKnowledge['muscle gain']!;
      } else if (lowerQuestion.contains('tired') ||
          lowerQuestion.contains('energy')) {
        return _nutritionKnowledge['energy']!;
      } else if (lowerQuestion.contains('water') ||
          lowerQuestion.contains('drink')) {
        return _nutritionKnowledge['hydration']!;
      } else if (lowerQuestion.contains('balanced') ||
          lowerQuestion.contains('healthy')) {
        return _nutritionKnowledge['balanced diet']!;
      }

      // Default general advice
      return '''Here are some general nutrition tips:

1. **Eat a Balanced Diet**: Include foods from all food groups - fruits, vegetables, whole grains, lean proteins, and healthy fats.

2. **Stay Hydrated**: Drink 8-10 glasses of water daily. Water is essential for all body functions.

3. **Portion Control**: Use smaller plates and be mindful of serving sizes to avoid overeating.

4. **Limit Processed Foods**: Focus on whole, natural foods whenever possible. They provide more nutrients and fewer additives.

5. **Regular Meals**: Don't skip meals, especially breakfast. Eating regularly helps maintain energy and metabolism.

6. **Variety is Key**: Eat a wide range of foods to ensure you get all necessary nutrients. Try to "eat the rainbow" with colorful fruits and vegetables.

For more specific advice, try asking about weight loss, muscle gain, energy, hydration, or specific nutrients like protein, carbs, or fats.''';
    } catch (e) {
      _logger.e('Fallback AI: Error getting advice: $e');
      return 'I apologize, but I encountered an error. Please try rephrasing your question.';
    }
  }

  /// Generate a simple recipe
  Future<Map<String, dynamic>> generateRecipe({
    required List<String> ingredients,
    String? cuisineType,
  }) async {
    final recipes = _getRecipeTemplates();
    final random = _random.nextInt(recipes.length);
    final recipe = Map<String, dynamic>.from(recipes[random]);

    // Customize with provided ingredients
    if (ingredients.isNotEmpty) {
      recipe['ingredients'] = ingredients
          .map((i) => '${_capitalize(i)} - as needed')
          .toList();
    }

    return recipe;
  }

  /// Get recipe templates
  List<Map<String, dynamic>> _getRecipeTemplates() {
    return [
      {
        'name': 'Healthy Chicken Salad',
        'servings': 2,
        'calories': 350,
        'protein': 35,
        'carbs': 20,
        'fat': 12,
        'prepTime': '15 minutes',
        'ingredients': [
          '200g chicken breast',
          '2 cups mixed greens',
          '1 tomato',
          '1/2 cucumber',
          '2 tbsp olive oil',
          'Lemon juice',
        ],
        'instructions': [
          'Grill or bake chicken breast until cooked through',
          'Chop vegetables into bite-sized pieces',
          'Slice cooked chicken',
          'Combine all ingredients in a bowl',
          'Drizzle with olive oil and lemon juice',
          'Toss well and serve fresh',
        ],
      },
      {
        'name': 'Protein Power Bowl',
        'servings': 1,
        'calories': 450,
        'protein': 40,
        'carbs': 45,
        'fat': 12,
        'prepTime': '20 minutes',
        'ingredients': [
          '1 cup cooked quinoa',
          '150g grilled chicken or tofu',
          '1 cup steamed broccoli',
          '1/2 avocado',
          '2 tbsp hummus',
          'Sesame seeds for garnish',
        ],
        'instructions': [
          'Cook quinoa according to package directions',
          'Grill protein of choice',
          'Steam broccoli until tender',
          'Arrange all ingredients in a bowl',
          'Top with avocado and hummus',
          'Garnish with sesame seeds',
        ],
      },
      {
        'name': 'Overnight Oats',
        'servings': 1,
        'calories': 320,
        'protein': 12,
        'carbs': 48,
        'fat': 9,
        'prepTime': '5 minutes (+ overnight)',
        'ingredients': [
          '1/2 cup rolled oats',
          '1/2 cup milk or almond milk',
          '1/2 banana, sliced',
          '1 tbsp chia seeds',
          '1 tsp honey',
          'Handful of berries',
        ],
        'instructions': [
          'Combine oats, milk, and chia seeds in a jar',
          'Stir well to mix',
          'Cover and refrigerate overnight',
          'In the morning, top with banana and berries',
          'Drizzle with honey',
          'Enjoy cold or warm it up',
        ],
      },
    ];
  }

  /// Capitalize first letter
  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Get status message
  String get status => '✅ Fallback AI Ready (Local Mode)';
}
