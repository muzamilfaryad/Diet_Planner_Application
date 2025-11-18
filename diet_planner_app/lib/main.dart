import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import 'screens/home_screen_redesigned.dart';
// auth screens imported where needed
import 'services/food_database_service.dart';
// Firebase auth service imported where needed in screens/services
import 'services/huggingface_ai_service.dart';
import 'config/ai_config.dart';
import 'models/food_item.dart';

final _logger = Logger();

void main() async {
  // Wrap everything in error handling to prevent blank screen
  FlutterError.onError = (FlutterErrorDetails details) {
    _logger.e('Flutter Error: ${details.exception}\n${details.stack}');
    FlutterError.presentError(details);
  };

  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Load environment variables from .env (if present)
    Map<String, String> envVars = {};
    try {
      await dotenv.load(fileName: ".env");
      envVars = Map<String, String>.from(dotenv.env);
      _logger.i('Environment variables loaded from .env');
    } catch (e) {
      _logger.w('No .env file found or error loading it: $e');
      _logger.i('App will run without Firebase and AI features');
    }

    // Initialize Firebase with configuration from environment variables
    // Only initialize if we have at least a project ID
    final projectId = envVars['FIREBASE_PROJECT_ID'] ?? '';
    if (projectId.isNotEmpty) {
      try {
        final firebaseOptions = FirebaseOptions(
          apiKey: envVars['FIREBASE_API_KEY'] ?? '',
          appId: envVars['FIREBASE_APP_ID'] ?? '',
          messagingSenderId: envVars['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
          projectId: projectId,
          authDomain: envVars['FIREBASE_AUTH_DOMAIN'] ?? '',
          storageBucket: envVars['FIREBASE_STORAGE_BUCKET'] ?? '',
          measurementId: envVars['FIREBASE_MEASUREMENT_ID'] ?? '',
        );

        await Firebase.initializeApp(options: firebaseOptions);
        _logger.i('Firebase initialized successfully');
      } catch (e, st) {
        _logger.e('Firebase initialization error: $e\n$st');
      }
    } else {
      _logger.w('Firebase not configured - app will work in offline mode');
    }

    // Initialize AI service - with automatic fallback if no API key
    final hfApiKey = envVars['HF_API_KEY'] ?? '';
    final hfModel = envVars['HF_MODEL'] ?? 'gpt2';

    if (hfApiKey.isNotEmpty && hfApiKey.startsWith('hf_')) {
      try {
        HuggingFaceAIService.instance.initialize(
          hfApiKey,
          apiUrl: AIConfig.hfApiUrl,
          model: hfModel,
        );
        _logger.i('✅ AI Features: ${HuggingFaceAIService.instance.status}');
      } catch (e, st) {
        _logger.w('AI API initialization error, using fallback mode: $e\n$st');
        _logger.i('✅ AI Features: ${HuggingFaceAIService.instance.status}');
      }
    } else {
      _logger.i('✅ AI Features: ${HuggingFaceAIService.instance.status}');
      _logger.i('💡 Optional: Add HF_API_KEY to .env for cloud AI features');
    }

    _seedLocalDatabase();
    runApp(const MyApp());
  } catch (e, st) {
    _logger.e('Fatal error in main: $e\n$st');
    // Run a minimal app to show error
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Error starting app: $e'))),
      ),
    );
  }
}

void _seedLocalDatabase() {
  // Add a few sample foods so the app is usable out-of-the-box.
  final db = FoodDatabaseService.instance;
  final now = DateTime.now();

  final apple = FoodItem(
    id: 'apple_1',
    name: 'Apple (medium)',
    calories: 95,
    protein: 0.5,
    carbs: 25,
    fat: 0.3,
    servingSizeGrams: 182,
  );

  final chicken = FoodItem(
    id: 'chicken_breast',
    name: 'Chicken Breast (100g)',
    calories: 165,
    protein: 31,
    carbs: 0,
    fat: 3.6,
    servingSizeGrams: 100,
  );

  final oats = FoodItem(
    id: 'oats_40g',
    name: 'Rolled Oats (40g)',
    calories: 150,
    protein: 5.0,
    carbs: 27.0,
    fat: 3.0,
    servingSizeGrams: 40,
  );

  db.addFood(apple);
  db.addFood(chicken);
  db.addFood(oats);

  // Log a sample breakfast so the home screen shows data immediately.
  db.logFood(now, oats);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // FirebaseAuthService can be accessed from screens/services when needed

  @override
  Widget build(BuildContext context) {
    // Modern color palette
    const primaryColor = Color(0xFF00B4D8);
    const secondaryColor = Color(0xFF90E0EF);
    const accentColor = Color(0xFF0077B6);
    // Theme accent colors (kept in theme definitions below)

    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        shadowColor: Color.fromRGBO(0, 0, 0, 0.05),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );

    // Try to load Google Fonts, fallback to system fonts if it fails
    TextTheme textTheme;
    TextTheme primaryTextTheme;
    try {
      textTheme = GoogleFonts.interTextTheme(base.textTheme);
      primaryTextTheme = GoogleFonts.interTextTheme(base.primaryTextTheme);
    } catch (e) {
      _logger.w('Failed to load Google Fonts: $e');
      textTheme = base.textTheme;
      primaryTextTheme = base.primaryTextTheme;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diet Planner',
      theme: base.copyWith(
        textTheme: textTheme,
        primaryTextTheme: primaryTextTheme,
      ),
      // Show home screen directly - Firebase auth optional
      // Users can access Profile screen to sign in if they want cloud sync
      home: const HomeScreenRedesigned(),
    );
  }
}
