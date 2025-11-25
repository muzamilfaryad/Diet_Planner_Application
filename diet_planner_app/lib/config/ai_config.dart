// AI Configuration
//
// ⚠️ SECURITY NOTICE: Never commit real API keys to version control!
//
// RECOMMENDED SETUP:
// 1. Use environment variables (--dart-define)
// 2. Use flutter_dotenv package
// 3. Use secure storage for production
//
// HUGGING FACE API (100% FREE):
// - Sign up: https://huggingface.co (no payment required)
// - Get token: https://huggingface.co/settings/tokens
// - Free tier: 1,000 requests/hour
// - No credit card needed
//
// QUICK START:
// 1. Get your free token from link above
// 2. Create .env file in project root (already in .gitignore)
// 3. Add: HF_API_KEY=your_token_here
// 4. Or use --dart-define=HF_API_KEY=your_token_here
//
// For detailed setup, see: docs/features/AI_QUICK_START.md

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIConfig {
  // ==================== API Configuration ====================

  /// Hugging Face API Key
  /// NEVER commit real keys! Use environment variables instead.
  ///
  /// Setup options:
  /// 1. Environment variable: --dart-define=HF_API_KEY=your_key
  /// 2. .env file with flutter_dotenv
  /// 3. Secure storage for production
  static String get hfApiKey {
    try {
      return dotenv.env['HF_API_KEY'] ?? '';
    } catch (e) {
      return '';
    }
  }

  /// Hugging Face API Base URL
  static const String hfApiUrl = 'https://api-inference.huggingface.co/models';

  /// AI Model to use
  /// Using GPT-2: Most stable, always available, battle-tested
  static String get hfModel {
    try {
      return dotenv.env['HF_MODEL'] ?? 'gpt2';
    } catch (e) {
      return 'gpt2';
    }
  }

  // ==================== Alternative Models ====================

  /// Alternative free models available:
  static const List<Map<String, String>> availableModels = [
    {
      'id': 'mistralai/Mistral-7B-Instruct-v0.2',
      'name': 'Mistral 7B Instruct',
      'description': 'Fast and accurate (Recommended)',
      'speed': 'Fast',
    },
    {
      'id': 'meta-llama/Llama-2-7b-chat-hf',
      'name': 'Llama 2 7B Chat',
      'description': 'Facebook\'s conversational AI',
      'speed': 'Medium',
    },
    {
      'id': 'google/flan-t5-xxl',
      'name': 'Flan-T5 XXL',
      'description': 'Google\'s T5, great for Q&A',
      'speed': 'Fast',
    },
    {
      'id': 'mistralai/Mixtral-8x7B-Instruct-v0.1',
      'name': 'Mixtral 8x7B',
      'description': 'More powerful, slower',
      'speed': 'Slow',
    },
  ];

  // ==================== Configuration Validation ====================

  /// Check if API key is properly configured
  /// Note: App now works with fallback AI even without API key
  static bool get isConfigured {
    final key = hfApiKey;
    return key.isNotEmpty &&
        key != 'YOUR_HF_API_KEY_HERE' &&
        key.startsWith('hf_') &&
        key.length > 10;
  }

  /// Check if fallback mode is enabled (no API key but AI features still work)
  static bool get isFallbackMode => !isConfigured;

  /// Check if any AI features are available (API or fallback)
  static bool get hasAIFeatures => true; // Always true with fallback system

  /// Get configuration status message
  static String get configurationStatus {
    if (!isConfigured) {
      return '''
⚠️ AI Features Not Configured

Get your FREE Hugging Face API key:
1. Visit: https://huggingface.co/settings/tokens
2. Sign up (no payment required)
3. Create a "Read" token
4. Configure using one of these methods:

Method 1 - Environment Variable (Recommended):
   flutter run --dart-define=HF_API_KEY=your_token_here

Method 2 - .env file:
   Create .env file in project root
   Add: HF_API_KEY=your_token_here
   Install flutter_dotenv package

See docs/features/AI_QUICK_START.md for details
''';
    }
    return '✅ AI Features Configured\nModel: $hfModel';
  }

  /// Validate API key format
  static bool validateApiKey(String key) {
    return key.isNotEmpty && key.startsWith('hf_') && key.length >= 20;
  }
}
