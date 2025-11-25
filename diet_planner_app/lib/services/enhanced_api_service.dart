import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:logger/logger.dart';

import '../models/food_item.dart';

final Logger _logger = Logger();

/// Enhanced API Service with multiple public nutrition and recipe APIs
/// All APIs used are FREE and publicly accessible
class EnhancedApiService {
  EnhancedApiService._private();
  static final EnhancedApiService instance = EnhancedApiService._private();
  final http.Client _http = http.Client();

  // OpenFoodFacts search
  Future<List<FoodItem>> searchOpenFoodFacts(String query) async {
    try {
      final q = query.trim();
      if (q.isEmpty) return [];
      String urlStr =
          'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$q&search_simple=1&action=process&json=1&page_size=30';
      if (kIsWeb) {
        urlStr = 'https://corsproxy.io/?${Uri.encodeComponent(urlStr)}';
      }
      final uri = Uri.parse(urlStr);
      _logger.d('Searching OpenFoodFacts: $uri');
      final resp = await _http.get(uri).timeout(const Duration(seconds: 15));
      if (resp.statusCode != 200) return [];
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final products = (json['products'] as List<dynamic>?) ?? [];
      return products
          .map((p) => _foodItemFromOpenFoodFacts(p as Map<String, dynamic>))
          .whereType<FoodItem>()
          .toList();
    } catch (e, stackTrace) {
      _logger.e('OpenFoodFacts error: $e', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  FoodItem? _foodItemFromOpenFoodFacts(Map<String, dynamic> product) {
    try {
      final code = (product['code'] ?? '') as String;
      final name = (product['product_name'] ?? 'Unknown').toString();
      final nutriments = (product['nutriments'] ?? {}) as Map<String, dynamic>;
      double kcal = (nutriments['energy-kcal_100g'] as num?)?.toDouble() ?? 0.0;
      double protein = (nutriments['proteins_100g'] as num?)?.toDouble() ?? 0.0;
      double carbs =
          (nutriments['carbohydrates_100g'] as num?)?.toDouble() ?? 0.0;
      double fat = (nutriments['fat_100g'] as num?)?.toDouble() ?? 0.0;
      return FoodItem(
        id: 'off_$code',
        name: name,
        calories: kcal,
        protein: protein,
        carbs: carbs,
        fat: fat,
        servingSizeGrams: 100.0,
      );
    } catch (e) {
      _logger.e('Parse error: $e');
      return null;
    }
  }

  /// Lookup product by barcode (FREE)
  Future<FoodItem?> fetchFoodByBarcode(String barcode) async {
    try {
      final clean = barcode.trim();
      if (clean.isEmpty) return null;
      String urlStr =
          'https://world.openfoodfacts.org/api/v0/product/$clean.json';
      if (kIsWeb) {
        urlStr = 'https://corsproxy.io/?${Uri.encodeComponent(urlStr)}';
      }
      final uri = Uri.parse(urlStr);
      _logger.d('Barcode lookup: $uri');
      final resp = await _http.get(uri).timeout(const Duration(seconds: 15));
      if (resp.statusCode != 200) return null;
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      if (json['status'] == 0) return null;
      final product = json['product'] as Map<String, dynamic>?;
      if (product == null) return null;
      return _foodItemFromOpenFoodFacts(product);
    } catch (e) {
      _logger.e('Barcode lookup error: $e');
      return null;
    }
  }

  // TheMealDB API
  Future<List<Map<String, dynamic>>> searchRecipes(String query) async {
    try {
      final q = query.trim();
      if (q.isEmpty) return [];
      String urlStr =
          'https://www.themealdb.com/api/json/v1/1/search.php?s=${Uri.encodeComponent(q)}';
      if (kIsWeb) {
        urlStr = 'https://corsproxy.io/?${Uri.encodeComponent(urlStr)}';
      }
      final uri = Uri.parse(urlStr);
      final resp = await _http.get(uri).timeout(const Duration(seconds: 15));
      if (resp.statusCode != 200) return [];
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final meals = (json['meals'] as List<dynamic>?) ?? [];
      return meals.map((m) {
        final map = m as Map<String, dynamic>;
        return {
          'id': map['idMeal'],
          'name': map['strMeal'],
          'category': map['strCategory'],
        };
      }).toList();
    } catch (e) {
      _logger.e('Recipe search error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getRandomRecipes({int count = 5}) async {
    try {
      final recipes = <Map<String, dynamic>>[];
      for (int i = 0; i < count; i++) {
        final uri = Uri.https('www.themealdb.com', '/api/json/v1/1/random.php');
        final resp = await _http.get(uri).timeout(const Duration(seconds: 5));
        if (resp.statusCode == 200) {
          final json = jsonDecode(resp.body) as Map<String, dynamic>;
          final meals = (json['meals'] as List<dynamic>?) ?? [];
          if (meals.isNotEmpty) {
            recipes.add({
              'id': meals[0]['idMeal'],
              'name': meals[0]['strMeal'],
            });
          }
        }
      }
      return recipes;
    } catch (e) {
      _logger.e('Random recipes error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getRecipesByCategory(
    String category,
  ) async {
    try {
      final uri = Uri.https('www.themealdb.com', '/api/json/v1/1/filter.php', {
        'c': category,
      });
      final resp = await _http.get(uri).timeout(const Duration(seconds: 10));
      if (resp.statusCode != 200) return [];
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final meals = (json['meals'] as List<dynamic>?) ?? [];
      return meals
          .map((m) => {'id': m['idMeal'], 'name': m['strMeal']})
          .toList();
    } catch (e) {
      _logger.e('Category error: $e');
      return [];
    }
  }

  Future<List<FoodItem>> smartFoodSearch(
    String query, {
    String? calorieNinjasKey,
  }) async {
    return await searchOpenFoodFacts(query);
  }

  Future<List<Map<String, dynamic>>> smartRecipeSearch(
    String query, {
    String? edamamAppId,
    String? edamamAppKey,
  }) async {
    return await searchRecipes(query);
  }

  List<String> getRecipeCategories() => [
    'Beef',
    'Chicken',
    'Dessert',
    'Lamb',
    'Pasta',
    'Pork',
    'Seafood',
    'Vegan',
    'Vegetarian',
  ];

  void dispose() => _http.close();
}
