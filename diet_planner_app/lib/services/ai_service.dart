import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:logger/logger.dart';

class AIService {
  AIService._();

  static final AIService instance = AIService._();

  static const String _defaultModel = 'gemini-2.5-flash';
  final Logger _logger = Logger();
  GenerativeModel? _model;

  bool get isConfigured =>
      (dotenv.env['GEMINI_API_KEY'] ?? '').trim().isNotEmpty;

  GenerativeModel get _client {
    if (_model != null) return _model!;
    final key = dotenv.env['GEMINI_API_KEY'];
    if (key == null || key.isEmpty) {
      throw StateError(
        'GEMINI_API_KEY not found. Ensure dotenv is loaded before using AIService.',
      );
    }
    _model = GenerativeModel(
      model: _defaultModel,
      apiKey: key,
      systemInstruction: Content.text(
        'You are a friendly, professional, and knowledgeable diet planner and nutritionist for a mobile app. Provide clear, encouraging, and easy-to-understand advice.',
      ),
    );
    return _model!;
  }

  Future<String?> getDietAdvice(String userQuery) async {
    if (!isConfigured) return null;
    try {
      final response = await _client.generateContent(
        [Content.text(userQuery)],
      );
      final text = response.text?.trim();
      return text?.isNotEmpty == true ? text : null;
    } catch (e, st) {
      _logger.e('Gemini diet advice error: $e', error: e, stackTrace: st);
      return null;
    }
  }

  Future<Map<String, dynamic>?> generateRecipe({
    required List<String> ingredients,
    String? dietaryRestrictions,
    String? cuisineType,
    int? targetCalories,
  }) async {
    if (!isConfigured) return null;
    try {
      final prompt =
          '''
Create a healthy, easy-to-follow recipe using these ingredients: ${ingredients.join(', ')}.
${dietaryRestrictions != null ? 'Dietary restrictions: $dietaryRestrictions.' : ''}
${cuisineType != null ? 'Cuisine preference: $cuisineType.' : ''}
${targetCalories != null ? 'Target calories per serving: ~$targetCalories.' : ''}

Return ONLY valid JSON in this format (no markdown):
{
  "name": "Recipe title",
  "description": "1-2 sentence overview",
  "ingredients": ["ingredient 1", "ingredient 2"],
  "instructions": ["Step 1", "Step 2"],
  "nutrition": {
    "calories": number,
    "protein": number,
    "carbs": number,
    "fat": number
  },
  "tips": ["tip 1", "tip 2"]
}
''';

      final response = await _client.generateContent([Content.text(prompt)]);
      final text = response.text?.trim();
      if (text == null || text.isEmpty) return null;

      final jsonString = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e, st) {
      _logger.e('Gemini recipe error: $e', error: e, stackTrace: st);
      if (kDebugMode) {
        debugPrint('AI recipe generation failed: $e');
      }
      return null;
    }
  }
}
