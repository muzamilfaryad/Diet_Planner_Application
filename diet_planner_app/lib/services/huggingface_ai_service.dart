import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import '../models/food_item.dart';
import 'package:logger/logger.dart';
import 'fallback_ai_service.dart';

/// AI Service for intelligent diet planning features
///
/// AUTO-FALLBACK MODE: Works with or without API key!
/// - With API key: Uses Hugging Face Inference API (100% Free!)
/// - Without API key: Uses local fallback AI (also works great!)
///
/// Features (available in both modes):
/// - Natural language food parsing
/// - Recipe generation
/// - Meal planning
/// - Nutrition advice chatbot
/// - Meal analysis
///
/// Setup: See docs/features/AI_QUICK_START.md (optional - app works without it!)
class HuggingFaceAIService {
  HuggingFaceAIService._private();
  static final HuggingFaceAIService instance = HuggingFaceAIService._private();

  final Logger _logger = Logger();

  String? _apiKey;
  String? _apiUrl;
  String? _model;
  DateTime? _lastRequestTime;
  int _requestCount = 0;
  static const int _maxRequestsPerMinute = 60;

  /// Initialize the service with Hugging Face API key
  ///
  /// [apiKey] - Your Hugging Face API token (get from https://huggingface.co/settings/tokens)
  /// [apiUrl] - Optional custom API URL
  /// [model] - Optional model selection (default: mistralai/Mistral-7B-Instruct-v0.2)
  void initialize(String apiKey, {String? apiUrl, String? model}) {
    try {
      if (apiKey.isEmpty) {
        throw ArgumentError('API key cannot be empty');
      }
      if (!apiKey.startsWith('hf_')) {
        throw ArgumentError(
          'Invalid Hugging Face API key format. Key must start with "hf_"',
        );
      }

      _apiKey = apiKey;
      _apiUrl = apiUrl ?? 'https://api-inference.huggingface.co/models';
      _model = model ?? 'mistralai/Mistral-7B-Instruct-v0.2';
      _lastRequestTime = null;
      _requestCount = 0;

      _logger.i(
        'Hugging Face AI Service initialized - Model: $_model, API URL: $_apiUrl',
      );
    } catch (e) {
      _logger.e('Error initializing Hugging Face AI: $e');
      rethrow;
    }
  }

  /// Check if service is properly initialized
  bool get isInitialized => _apiKey != null && _apiKey!.isNotEmpty;

  /// Get current model name
  String? get currentModel => _model;

  /// Get configuration status
  String get status {
    if (!isInitialized) {
      return '✅ Ready (Fallback Mode - Local AI)';
    }
    return '✅ Ready (Cloud Mode - $_model)';
  }

  /// Rate limiting check
  bool _checkRateLimit() {
    final now = DateTime.now();
    if (_lastRequestTime == null) {
      _lastRequestTime = now;
      _requestCount = 1;
      return true;
    }

    final timeDiff = now.difference(_lastRequestTime!);
    if (timeDiff.inMinutes >= 1) {
      _requestCount = 1;
      _lastRequestTime = now;
      return true;
    }

    if (_requestCount >= _maxRequestsPerMinute) {
      if (kDebugMode) print('⚠️ Rate limit reached. Please wait.');
      return false;
    }

    _requestCount++;
    return true;
  }

  /// Make API request to Hugging Face Inference API
  ///
  /// Returns the generated text or null if request fails
  /// Handles model loading and rate limiting automatically
  Future<String?> _makeRequest(
    String prompt, {
    int maxTokens = 2048,
    int retryCount = 0,
  }) async {
    if (!isInitialized) {
      _logger.w('Hugging Face AI not initialized');
      throw StateError('AI Service not initialized. Call initialize() first.');
    }

    if (!_checkRateLimit()) {
      throw Exception(
        'Rate limit exceeded. Please wait a minute before trying again.',
      );
    }

    try {
      _logger.d('Sending request to AI model: $_model');

      // Use CORS proxy for web platform
      String apiUrl;
      Map<String, String> headers;

      if (kIsWeb) {
        // Use AllOrigins proxy for web (more reliable)
        apiUrl =
            'https://api.allorigins.win/raw?url=${Uri.encodeComponent('$_apiUrl/$_model')}';
        headers = {
          'Content-Type': 'application/json',
          'x-authorization': 'Bearer $_apiKey', // Proxy-friendly header
        };
      } else {
        // Direct API call for mobile/desktop
        apiUrl = '$_apiUrl/$_model';
        headers = {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        };
      }

      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: headers,
            body: jsonEncode({
              'inputs': prompt,
              'parameters': {
                'max_new_tokens': maxTokens,
                'temperature': 0.7,
                'top_p': 0.95,
                'return_full_text': false,
              },
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException('Request timed out after 30 seconds');
            },
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle different response formats from Hugging Face API
        String? result;
        if (data is List && data.isNotEmpty) {
          result = data[0]['generated_text'];
        } else if (data is Map && data.containsKey('generated_text')) {
          result = data['generated_text'];
        }

        if (result != null) {
          _logger.d('AI response received (${result.length} chars)');
          return result;
        }

        _logger.w('Unexpected response format: $data');
        return null;
      } else if (response.statusCode == 503) {
        // Model is loading, retry with exponential backoff
        if (retryCount < 3) {
          final waitTime = 5 * (retryCount + 1);
          _logger.i(
            'Model is loading, retrying in $waitTime seconds... (attempt ${retryCount + 1}/3)',
          );
          await Future.delayed(Duration(seconds: waitTime));
          return _makeRequest(
            prompt,
            maxTokens: maxTokens,
            retryCount: retryCount + 1,
          );
        } else {
          throw Exception(
            'Model failed to load after 3 attempts. Please try again later.',
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API key. Please check your Hugging Face token.',
        );
      } else if (response.statusCode == 429) {
        throw Exception(
          'Rate limit exceeded. Free tier allows 1,000 requests per hour.',
        );
      } else if (response.statusCode == 410) {
        // Model endpoint changed or deprecated
        _logger.e('Model endpoint error (410): ${response.body}');
        throw Exception(
          'Model no longer available. The Hugging Face model endpoint may have changed. Try using a different model.',
        );
      } else {
        final errorMsg = 'API Error: ${response.statusCode}';
        _logger.e('$errorMsg - ${response.body}');
        throw Exception(errorMsg);
      }
    } on TimeoutException catch (e) {
      _logger.w('Request timeout: $e');
      throw Exception(
        'Request timed out. Please check your internet connection and try again.',
      );
    } catch (e) {
      _logger.e('Request error: $e');
      rethrow;
    }
  }

  /// Parse natural language food description into structured nutritional data
  /// Example: "a large apple" -> FoodItem with calories, protein, etc.
  /// AUTO-FALLBACK: Uses local AI if API not configured
  Future<FoodItem?> parseFoodDescription(String description) async {
    // Use fallback AI if not initialized with API key
    if (!isInitialized) {
      _logger.i('Using fallback AI for food parsing');
      return FallbackAIService.instance.parseFoodDescription(description);
    }

    try {
      final prompt =
          '''
You are a nutrition expert. Parse this food description and return ONLY a JSON object with nutritional information.
Do not include any additional text, explanations, or markdown formatting.

Food: "$description"

Return EXACTLY this JSON format (numbers only, no units):
{
  "name": "food name",
  "calories": number,
  "protein": number (in grams),
  "carbs": number (in grams),
  "fat": number (in grams),
  "serving": "serving size description",
  "confidence": number (0-100, how confident you are in these values)
}

Example for "a large apple":
{"name":"Large Apple","calories":116,"protein":0.6,"carbs":30.8,"fat":0.4,"serving":"1 large apple (223g)","confidence":95}

JSON only:''';

      final text = await _makeRequest(prompt);
      if (text == null) return null;

      _logger.d('AI Response: $text');

      // Clean up response (remove markdown if present)
      String cleanJson = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final data = jsonDecode(cleanJson);

      return FoodItem(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        name: data['name'] ?? description,
        calories: (data['calories'] ?? 0).toDouble(),
        protein: (data['protein'] ?? 0).toDouble(),
        carbs: (data['carbs'] ?? 0).toDouble(),
        fat: (data['fat'] ?? 0).toDouble(),
        servingSizeGrams: 100.0, // Default serving size
      );
    } catch (e) {
      _logger.w('Cloud AI error for food parsing, using fallback: $e');
      // Auto-fallback to local AI on any error
      return FallbackAIService.instance.parseFoodDescription(description);
    }
  }

  /// Generate a recipe based on ingredients and preferences
  /// AUTO-FALLBACK: Uses recipe templates if API not configured
  Future<Map<String, dynamic>?> generateRecipe({
    required List<String> ingredients,
    String? dietaryRestrictions,
    String? cuisineType,
    int? targetCalories,
  }) async {
    // Use fallback AI if not initialized with API key
    if (!isInitialized) {
      _logger.i('Using fallback AI for recipe generation');
      return FallbackAIService.instance.generateRecipe(
        ingredients: ingredients,
        cuisineType: cuisineType,
      );
    }

    try {
      final prompt =
          '''
Create a healthy recipe using these ingredients: ${ingredients.join(', ')}
${dietaryRestrictions != null ? 'Dietary restrictions: $dietaryRestrictions' : ''}
${cuisineType != null ? 'Cuisine type: $cuisineType' : ''}
${targetCalories != null ? 'Target calories: around $targetCalories per serving' : ''}

Return ONLY a JSON object (no markdown, no extra text) with this structure:
    try {
      final text = await _makeRequest(prompt);
      if (text == null) return null;

      String cleanJson = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(cleanJson);
    } catch (e) {
      _logger.w('Cloud AI error for recipe, using fallback: $e');
      // Auto-fallback to local AI on any error
      return FallbackAIService.instance.generateRecipe(
        ingredients: ingredients,
        cuisineType: cuisineType,
      );
    }
  "tips": "Optional cooking tips"
}''';

      final text = await _makeRequest(prompt);
      if (text == null) return null;

      String cleanJson = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(cleanJson);
    } catch (e) {
      if (kDebugMode) print('Error generating recipe: $e');
      return null;
    }
  }

  /// Generate a personalized meal plan
  Future<Map<String, dynamic>?> generateMealPlan({
    required int dailyCalories,
    required double proteinRatio,
    required double carbsRatio,
    required double fatRatio,
    String? dietaryRestrictions,
    int days = 1,
  }) async {
    if (!isInitialized) return null;

    try {
      final proteinCals = (dailyCalories * proteinRatio).toInt();
      final carbsCals = (dailyCalories * carbsRatio).toInt();
      final fatCals = (dailyCalories * fatRatio).toInt();

      final prompt =
          '''
Create a $days-day meal plan with these requirements:
- Daily calories: $dailyCalories
- Protein: ${proteinCals}cal (${(proteinCals / 4).toInt()}g)
- Carbs: ${carbsCals}cal (${(carbsCals / 4).toInt()}g)
- Fat: ${fatCals}cal (${(fatCals / 9).toInt()}g)
${dietaryRestrictions != null ? '- Dietary restrictions: $dietaryRestrictions' : ''}

Return ONLY a JSON object (no markdown) with this structure:
    try {
      final text = await _makeRequest(prompt);
      if (text == null) return null;

      String cleanJson = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(cleanJson);
    } catch (e) {
      _logger.e('Error generating meal plan: $e');
      return null;
    }
        "lunch": { /* same structure */ },
        "dinner": { /* same structure */ },
        "snacks": [
          {
            "name": "Snack name",
            "calories": number
          }
        ]
      }
    }
  ],
  "tips": ["tip1", "tip2", "tip3"]
}''';

      final text = await _makeRequest(prompt);
      if (text == null) return null;

      String cleanJson = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(cleanJson);
    } catch (e) {
      if (kDebugMode) print('Error generating meal plan: $e');
      return null;
    }
  }

  /// Get nutrition advice from AI
  /// AUTO-FALLBACK: Uses local knowledge base if API not configured or network fails
  Future<String?> getNutritionAdvice(String question) async {
    // Use fallback AI if not initialized with API key
    if (!isInitialized) {
      _logger.i('Using fallback AI for nutrition advice');
      return FallbackAIService.instance.getNutritionAdvice(question);
    }

    try {
      _logger.d('Sending question to AI: $question');

      final prompt =
          '''
You are a professional nutrition and diet expert. Answer this question with accurate, helpful, and evidence-based advice.
Keep your response concise, friendly, and actionable (2-4 paragraphs maximum).

Question: $question

Answer:''';

      final text = await _makeRequest(prompt);

      if (text != null) {
        final preview = text.substring(0, min(100, text.length));
        _logger.d('AI Response received: $preview...');
        return text;
      }

      // If cloud AI returns null, use fallback
      _logger.i('Cloud AI returned null, using fallback AI');
      return FallbackAIService.instance.getNutritionAdvice(question);
    } catch (e) {
      _logger.w('Cloud AI error, automatically using fallback AI: $e');
      // Auto-fallback to local AI on any error (network, CORS, etc.)
      return FallbackAIService.instance.getNutritionAdvice(question);
    }
  }

  /// Analyze a meal and provide suggestions
  Future<Map<String, dynamic>?> analyzeMeal(
    List<Map<String, dynamic>> foods,
  ) async {
    if (!isInitialized) return null;

    try {
      final foodList = foods
          .map(
            (f) =>
                '${f['name']}: ${f['calories']}cal, P:${f['protein']}g, C:${f['carbs']}g, F:${f['fat']}g',
          )
          .join('\n');

      final prompt =
          '''
Analyze this meal and provide nutritional insights and suggestions.

Foods in this meal:
$foodList

Return ONLY a JSON object (no markdown) with:
{
  "totalCalories": number,
  "totalProtein": number,
  "totalCarbs": number,
  "totalFat": number,
  "analysis": "Brief analysis of the nutritional balance",
  "suggestions": ["suggestion 1", "suggestion 2"],
  "rating": number (1-10, overall nutrition rating),
  "strengths": ["strength 1", "strength 2"],
  "improvements": ["improvement 1", "improvement 2"]
}''';

      final text = await _makeRequest(prompt);
      if (text == null) return null;

      String cleanJson = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(cleanJson);
    } catch (e) {
      _logger.e('Error analyzing meal: $e');
      return null;
    }
  }

  /// Get personalized food recommendations
  Future<List<String>?> getFoodRecommendations({
    required int targetCalories,
    required String mealType,
    String? dietaryPreferences,
  }) async {
    if (!isInitialized) return null;

    try {
      final prompt =
          '''
Recommend 5 healthy food items for $mealType that fit these criteria:
- Target calories: around ${(targetCalories * 0.3).toInt()} for this meal
${dietaryPreferences != null ? '- Dietary preferences: $dietaryPreferences' : ''}

Return ONLY a JSON array (no markdown) with food names:
["Food 1", "Food 2", "Food 3", "Food 4", "Food 5"]''';

      final text = await _makeRequest(prompt);
      if (text == null) return null;

      String cleanJson = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final List<dynamic> foods = jsonDecode(cleanJson);
      return foods.map((f) => f.toString()).toList();
    } catch (e) {
      _logger.e('Error getting food recommendations: $e');
      return null;
    }
  }
}

// ============================================================================
// HUGGING FACE AI SERVICE ONLY
// ============================================================================
// This service uses ONLY Hugging Face Inference API
// No Google Gemini, no OpenAI, no other AI providers
// 100% free, no payment required
// Get your key: https://huggingface.co/settings/tokens
// ============================================================================
