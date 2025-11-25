import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import '../models/food_item.dart';

/// Network-backed API service. Contains integrations for OpenFoodFacts and TheMealDB.
class ApiService {
  ApiService._private();
  static final ApiService instance = ApiService._private();

  /// Public default constructor kept for compatibility with existing code
  /// that instantiates `ApiService()`; returns the singleton instance.
  factory ApiService() => instance;

  final http.Client _http = http.Client();

  // -------------------- OpenFoodFacts --------------------
  /// Search OpenFoodFacts for foods matching [query]. Returns zero or more
  /// normalized [FoodItem]s. Uses the world.openfoodfacts.org search endpoint.
  Future<List<FoodItem>> searchFoods(String query) async {
    final q = query.trim();
    if (q.isEmpty) return [];
    final uri = Uri.https('world.openfoodfacts.org', '/cgi/search.pl', {
      'search_terms': q,
      'search_simple': '1',
      'action': 'process',
      'json': '1',
      'page_size': '20',
    });

    final resp = await _http.get(uri).timeout(const Duration(seconds: 10));
    if (resp.statusCode != 200) return [];
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    final products = (json['products'] as List<dynamic>?) ?? [];
    return products
        .map((p) => _foodItemFromOpenFoodFacts(p as Map<String, dynamic>))
        .whereType<FoodItem>()
        .toList();
  }

  /// Lookup a single product by barcode using OpenFoodFacts. Returns null when
  /// not found or on error.
  Future<FoodItem?> fetchFoodByBarcode(String barcode) async {
    final clean = barcode.trim();
    if (clean.isEmpty) return null;
    final uri = Uri.https(
      'world.openfoodfacts.org',
      '/api/v0/product/$clean.json',
    );
    final resp = await _http.get(uri).timeout(const Duration(seconds: 10));
    if (resp.statusCode != 200) return null;
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (json['status'] == 0) return null;
    final product = json['product'] as Map<String, dynamic>?;
    if (product == null) return null;
    return _foodItemFromOpenFoodFacts(product);
  }

  FoodItem? _foodItemFromOpenFoodFacts(Map<String, dynamic> product) {
    try {
      final code = (product['code'] ?? '') as String;
      final name = (product['product_name'] ?? product['generic_name'] ?? '')
          .toString();
      final nutriments = (product['nutriments'] ?? {}) as Map<String, dynamic>;

      double kcalPer100g = 0.0;
      if (nutriments.containsKey('energy-kcal_100g')) {
        kcalPer100g = (nutriments['energy-kcal_100g'] as num).toDouble();
      } else if (nutriments.containsKey('energy_100g')) {
        // energy_100g may be in kJ — convert to kcal (1 kcal = 4.184 kJ)
        final energy = (nutriments['energy_100g'] as num).toDouble();
        kcalPer100g = energy / 4.184;
      }

      double protein100 =
          (nutriments['proteins_100g'] as num?)?.toDouble() ??
          (nutriments['protein_100g'] as num?)?.toDouble() ??
          0.0;
      double carbs100 =
          (nutriments['carbohydrates_100g'] as num?)?.toDouble() ??
          (nutriments['carbohydrates_value'] as num?)?.toDouble() ??
          0.0;
      double fat100 = (nutriments['fat_100g'] as num?)?.toDouble() ?? 0.0;

      // Determine serving size (try nutriments serving or product['serving_size'])
      double servingGrams = 100.0;
      final servingStr = product['serving_size'] as String?;
      if (servingStr != null && servingStr.isNotEmpty) {
        // Try to parse a number (e.g. "100g" or "250 ml")
        final numMatch = RegExp(r"([0-9]+\.?[0-9]*)").firstMatch(servingStr);
        if (numMatch != null) {
          servingGrams =
              double.tryParse(numMatch.group(1) ?? '') ?? servingGrams;
          if (servingStr.toLowerCase().contains('ml')) {
            // assume density ~ water for ml -> g when unknown
            // keep value as-is (100 ml -> 100 g approx)
          }
        }
      } else if (nutriments.containsKey('serving_size')) {
        final s = nutriments['serving_size'];
        if (s is num) servingGrams = s.toDouble();
      }

      final calories = kcalPer100g * (servingGrams / 100.0);

      return FoodItem(
        id: code.isNotEmpty ? code : name,
        name: name.isNotEmpty ? name : 'Unknown product',
        calories: calories,
        protein: protein100 * (servingGrams / 100.0),
        carbs: carbs100 * (servingGrams / 100.0),
        fat: fat100 * (servingGrams / 100.0),
        servingSizeGrams: servingGrams,
      );
    } catch (_) {
      return null;
    }
  }

  // -------------------- TheMealDB (recipes) --------------------
  /// Search recipes by name using TheMealDB. Returns a list of maps with
  /// raw recipe JSON; UI can render details. For convenience this returns a
  /// simplified map with id, name and thumbnail.
  Future<List<Map<String, dynamic>>> searchRecipes(String query) async {
    final q = query.trim();
    if (q.isEmpty) return [];
    final uri = Uri.https('www.themealdb.com', '/api/json/v1/1/search.php', {
      's': q,
    });
    final resp = await _http.get(uri).timeout(const Duration(seconds: 10));
    if (resp.statusCode != 200) return [];
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    final meals = (json['meals'] as List<dynamic>?) ?? [];
    return meals.map((m) {
      final map = m as Map<String, dynamic>;
      return {
        'id': map['idMeal'],
        'name': map['strMeal'],
        'thumbnail': map['strMealThumb'],
        'raw': map,
      };
    }).toList();
  }

  // -------------------- Scaffolds for paid/freemium APIs --------------------
  // The following methods are placeholders for USDA, Nutritionix and Edamam.
  // They expect API keys to be provided through your app configuration.

  /// Example placeholder for USDA FoodData Central search. Requires API key.
  Future<List<Map<String, dynamic>>> usdaSearch(
    String query, {
    required String apiKey,
  }) async {
    final q = query.trim();
    if (q.isEmpty) return [];
    final uri = Uri.https('api.nal.usda.gov', '/fdc/v1/foods/search', {
      'api_key': apiKey,
      'query': q,
      'pageSize': '20',
    });
    try {
      final resp = await _http.get(uri).timeout(const Duration(seconds: 10));
      if (resp.statusCode != 200) return [];
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final foods = (json['foods'] as List<dynamic>?) ?? [];
      return foods.map((f) {
        final m = f as Map<String, dynamic>;
        // collect some nutrients
        final nutrients = <String, double>{};
        for (final n in (m['foodNutrients'] as List<dynamic>?) ?? []) {
          final nut = n as Map<String, dynamic>;
          final name = (nut['nutrientName'] ?? '').toString().toLowerCase();
          final value = (nut['value'] as num?)?.toDouble() ?? 0.0;
          if (name.contains('energy') || name.contains('kcal')) {
            nutrients['calories'] = value;
          }
          if (name.contains('protein')) {
            nutrients['protein'] = value;
          }
          if (name.contains('carbohydrate')) {
            nutrients['carbs'] = value;
          }
          if (name.contains('lipid') || name.contains('fat')) {
            nutrients['fat'] = value;
          }
        }
        return {
          'fdcId': m['fdcId'],
          'description': m['description'] ?? m['description'] ?? '',
          'brandOwner': m['brandOwner'],
          'nutrients': nutrients,
          'raw': m,
        };
      }).toList();
    } catch (_) {
      return [];
    }
  }

  /// Placeholder for Nutritionix natural language nutrition lookup.
  Future<Map<String, dynamic>?> nutritionixNatural(
    String text, {
    required String appId,
    required String appKey,
  }) async {
    final uri = Uri.https('trackapi.nutritionix.com', '/v2/natural/nutrients');
    try {
      final resp = await _http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'x-app-id': appId,
              'x-app-key': appKey,
            },
            body: jsonEncode({'query': text}),
          )
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode != 200) return null;
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      return json;
    } catch (_) {
      return null;
    }
  }

  /// Placeholder for Edamam recipe / nutrition analysis.
  Future<Map<String, dynamic>?> edamamAnalyze(
    String ingredientsCsv, {
    required String appId,
    required String appKey,
  }) async {
    // ingredientsCsv is a comma-separated list of ingredient lines.
    final uri = Uri.https('api.edamam.com', '/api/nutrition-details', {
      'app_id': appId,
      'app_key': appKey,
    });
    try {
      final ingredients = ingredientsCsv
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      final resp = await _http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'title': 'Recipe', 'ingr': ingredients}),
          )
          .timeout(const Duration(seconds: 15));
      if (resp.statusCode != 200) return null;
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      return json;
    } catch (_) {
      return null;
    }
  }
}
