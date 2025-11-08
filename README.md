# 🥗 Diet Planner - Multi-Platform Nutrition & Meal Management Application

[![Platform](https://img.shields.io/badge/Platform-Flutter-blue?logo=flutter&logoColor=white)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-brightgreen)](#)

A comprehensive, cross-platform mobile and web application built with Flutter that empowers users to manage their nutritional goals, track calorie intake, create personalized meal plans, and discover recipes. Featuring barcode scanning, real-time API integration, and a modern, beautiful UI.

---

## 🌟 Key Features

### 📊 Nutrition Tracking
- **Real-time Calorie & Macro Tracking**: Accurately log meals and view real-time breakdown of Calories, Protein, Carbs, and Fats
- **Animated Progress Ring**: Beautiful circular progress indicator showing daily calorie goals with smooth animations
- **7-Day History**: Track your progress over time with visual indicators and achievement badges
- **Smart Food Search**: Multi-API food search powered by OpenFoodFacts (2.8M+ products)

### 📱 Barcode Scanning
- **Camera-based scanning** on mobile (Android/iOS)
- **Manual entry fallback** for web and backup
- **Real-time product lookup** from OpenFoodFacts database
- **Beautiful product preview** dialog with complete nutrition information
- **Support for all standard barcode formats** (EAN-13, UPC-A, QR Code, etc.)

### 🍽️ Meal Planning
- **Daily Meal Plans**: Create and manage meal plans for any date (past or future)
- **Four Meal Types**: Breakfast, Lunch, Dinner, and Snack with scheduled times
- **Quick Add Feature**: Smart FAB that suggests meals based on current time
- **Copy Plans**: Duplicate entire day's plan to another date
- **Notes Support**: Add annotations to meal plans
- **Food Management**: Add/remove foods from meals with undo support

### 🍳 Recipe Discovery
- **300+ Recipes**: Powered by TheMealDB API
- **Recipe Search**: Find recipes by name, category, or cuisine
- **Random Recipes**: Discover new meal ideas
- **Filter Options**: Vegan, Vegetarian, Seafood, and more
- **Full Instructions**: Step-by-step cooking instructions
- **Ingredient Lists**: Complete ingredient breakdown
- **YouTube Videos**: Linked cooking tutorials

### 🎨 Modern UI/UX
- **Material Design 3**: Modern, clean design language
- **Gradient Themes**: Eye-catching color schemes throughout
- **Smooth Animations**: Micro-interactions and transitions
- **Glassmorphism Effects**: Frosted glass components
- **Staggered Animations**: Delightful card entrance effects
- **Responsive Design**: Adapts to all screen sizes
- **Empty States**: Clear, actionable empty state messages

---

## 🚀 Quick Start

### Prerequisites
- **Flutter SDK** (v3.x or higher)
- **Dart SDK** (included with Flutter)
- An IDE: VS Code or Android Studio with Flutter plugin
- Verify installation:
  ```bash
  flutter doctor
  ```

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/muzamilfaryad/Diet_Planner_Application.git
   cd Diet_Planner_Application/diet_planner_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

4. **For web platform**:
   ```bash
   flutter run -d chrome
   ```

### 🎯 No API Keys Required!
The app works immediately without any configuration. Core features use free public APIs:
- ✅ **OpenFoodFacts** - Food database and barcode lookup
- ✅ **TheMealDB** - Recipe discovery and search

**Optional Enhancements** (requires free API keys):
- 🔧 **CalorieNinjas** - Natural language nutrition search
- 🔧 **Edamam** - Advanced recipe search with 2.3M+ recipes

See [API_INTEGRATION_GUIDE.md](API_INTEGRATION_GUIDE.md) for details.

---

## 💻 Technology Stack

| Area | Technology | Purpose |
|------|------------|---------|
| **Framework** | Flutter (Dart) | Cross-platform app development |
| **State Management** | StatefulWidgets + Services | Business logic separation |
| **UI Design** | Material Design 3 | Modern, consistent UI |
| **Fonts** | Google Fonts (Inter) | Professional typography |
| **Food Data** | OpenFoodFacts API | 2.8M+ food products |
| **Recipes** | TheMealDB API | 300+ recipes with instructions |
| **Barcode Scanning** | flutter_barcode_scanner | Camera-based product lookup |
| **HTTP** | http package | API communication |
| **Image Caching** | cached_network_image | Optimized image loading |

---

## 📁 Project Structure

```
FlutterProjectDietPlanner/
├── diet_planner_app/              # Main Flutter application
│   ├── lib/
│   │   ├── models/                # Data models (User, Meal, FoodItem, etc.)
│   │   │   ├── food_item.dart
│   │   │   ├── meal.dart
│   │   │   ├── meal_plan.dart
│   │   │   └── user_profile.dart
│   │   ├── services/              # Business logic & API integration
│   │   │   ├── enhanced_api_service.dart
│   │   │   ├── meal_plan_service.dart
│   │   │   ├── barcode_scanner_service.dart
│   │   │   └── api_config.dart
│   │   ├── screens/               # UI screens
│   │   │   ├── home_screen_redesigned.dart
│   │   │   ├── log_food_screen.dart
│   │   │   ├── meal_planner_screen.dart
│   │   │   ├── progress_screen.dart
│   │   │   └── recipe_screen_enhanced.dart
│   │   ├── widgets/               # Reusable UI components
│   │   │   ├── animated_progress_ring.dart
│   │   │   ├── glass_card.dart
│   │   │   └── food_search.dart
│   │   └── main.dart              # Application entry point
│   ├── android/                   # Android specific files
│   ├── ios/                       # iOS specific files
│   ├── web/                       # Web specific files
│   └── pubspec.yaml               # Dependencies & configuration
├── API_INTEGRATION_GUIDE.md       # Complete API documentation
├── MEAL_PLANNER_FEATURES.md       # Meal planning feature details
├── BARCODE_SCANNING_GUIDE.md      # Barcode implementation guide
├── UI_ENHANCEMENTS.md             # Design system documentation
└── README.md                      # This file
```

---

## 📚 Documentation

Detailed documentation is available for each major feature:

- **[API Integration Guide](API_INTEGRATION_GUIDE.md)** - Complete API setup and usage
- **[Meal Planner Features](MEAL_PLANNER_FEATURES.md)** - Meal planning functionality
- **[Barcode Scanning Guide](BARCODE_SCANNING_GUIDE.md)** - Barcode scanning implementation
- **[UI Enhancements](UI_ENHANCEMENTS.md)** - Design system and components
- **[API Quick Start](API_QUICK_START.md)** - Fast API setup guide
- **[Search Improvements](SEARCH_IMPROVEMENT_SUMMARY.md)** - Search functionality details
- **[Recipe Layout Fixes](RECIPE_LAYOUT_FIXES.md)** - Recipe UI improvements
- **[CORS Fix Documentation](CORS_FIX_DOCUMENTATION.md)** - Web API troubleshooting
- **[Git Push Guide](GIT_PUSH_GUIDE.md)** - Version control instructions

---

## ✨ Feature Highlights

### 🏠 Home Screen
- Personalized greeting with time-based messages
- Large animated calorie progress ring (200px)
- Macro breakdown (Protein, Carbs, Fat) with progress bars
- Today's meals list with calorie badges
- Beautiful gradient header with avatar
- Staggered card animations

### 📊 Progress Screen
- 7-day history with visual indicators
- Achievement badges (✅ Goal met, 📈 Good progress)
- Special highlight for today's card
- Gradient background with smooth transitions
- Circular progress rings for each day

### 🍽️ Food Logging
- Search 2.8M+ food products
- Barcode scanning capability
- Manual entry option
- Beautiful product preview dialogs
- Quick add to daily log
- Success notifications with undo

### 📅 Meal Planner
- Interactive date picker
- Daily nutrition summary
- Four meal types with scheduled times
- Food search integration
- Copy plans between dates
- Add notes to plans
- Clear entire day option

### 🍳 Recipe Browser
- Search by name, category, or cuisine
- Random recipe discovery
- Full ingredients and instructions
- YouTube video links
- Beautiful image cards
- Category filtering

---

## 🎨 Design System

### Color Palette
- **Primary**: #00B4D8 (Vibrant Cyan)
- **Secondary**: #90E0EF (Light Cyan)
- **Accent**: #0077B6 (Deep Blue)
- **Success**: #06D6A0 (Mint Green)
- **Warning**: #FFB703 (Amber)
- **Error**: #EF476F (Coral Red)

### Typography
- **Font Family**: Inter (Google Fonts)
- **Sizes**: 12-24px with clear hierarchy
- **Weights**: 400 (Regular), 600 (SemiBold), 700 (Bold)

### Components
- **Cards**: 20-24px border radius, soft shadows
- **Buttons**: Elevated with 16px radius, cyan primary color
- **Icons**: Rounded style with gradient backgrounds
- **Progress Rings**: Animated with gradient strokes
- **Bottom Navigation**: Frosted glass effect

---

## 🧪 Testing

### Manual Testing Checklist
- [x] Food search and logging
- [x] Barcode scanning (mobile & web)
- [x] Meal plan creation
- [x] Recipe search and filtering
- [x] Progress tracking
- [x] Date navigation
- [x] Plan copying
- [x] Food removal with undo
- [x] Empty states
- [x] Error handling

### Test Barcodes
Try these popular products:
- **Nutella**: 3017620422003
- **Coca-Cola**: 5449000000996
- **KitKat**: 7622210653918
- **Oreo**: 7622300700034

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **Commit your changes**:
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. **Push to the branch**:
   ```bash
   git push origin feature/AmazingFeature
   ```
5. **Open a Pull Request**

### Contribution Guidelines
- Follow the existing code style
- Add comments for complex logic
- Update documentation for new features
- Test on multiple platforms (mobile & web)
- Ensure no breaking changes

---

## 🐛 Troubleshooting

### Common Issues

**Issue**: API calls failing on web
- **Solution**: CORS proxy is implemented; check internet connection

**Issue**: Barcode scanning not working on web
- **Solution**: Use manual entry dialog (automatic fallback)

**Issue**: No food results found
- **Solution**: Try different search terms or use barcode scanning

**Issue**: Recipe images not loading
- **Solution**: Check internet connection; cached images will retry

See individual documentation files for more troubleshooting tips.

---

## 🔮 Future Enhancements

### Planned Features
- [ ] **User Authentication**: Firebase Auth integration
- [ ] **Data Persistence**: Save user data to cloud (Firestore)
- [ ] **Offline Support**: Local database with sync
- [ ] **Weekly View**: Calendar grid for meal planning
- [ ] **Meal Templates**: Save favorite meal combinations
- [ ] **Shopping List**: Auto-generate from meal plans
- [ ] **Recipe Favorites**: Save and organize favorite recipes
- [ ] **Nutrition Goals**: Custom daily macro targets
- [ ] **Weight Tracking**: Log and visualize weight changes
- [ ] **Dark Mode**: Complete dark theme support
- [ ] **Export Data**: PDF reports and CSV exports
- [ ] **Social Features**: Share recipes and meal plans
- [ ] **Notifications**: Meal reminders and goal alerts
- [ ] **Water Tracking**: Daily hydration monitoring
- [ ] **Exercise Integration**: Link workouts to calorie budget

---

## 📊 Performance

- **App Size**: ~15MB (with assets)
- **API Response Time**: 2-5 seconds average
- **Barcode Scan Speed**: < 1 second (mobile)
- **UI Frame Rate**: 60fps smooth animations
- **Startup Time**: < 2 seconds cold start

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

## 📧 Contact & Support

**Developer**: Muzamil Faryad  
**GitHub**: [@muzamilfaryad](https://github.com/muzamilfaryad)  
**Repository**: [Diet_Planner_Application](https://github.com/muzamilfaryad/Diet_Planner_Application)

### Get Help
- 📖 Check the [documentation files](.)
- 🐛 [Open an issue](https://github.com/muzamilfaryad/Diet_Planner_Application/issues)
- 💬 [Start a discussion](https://github.com/muzamilfaryad/Diet_Planner_Application/discussions)

---

## 🙏 Acknowledgments

### APIs & Data Sources
- **OpenFoodFacts** - Free nutrition database
- **TheMealDB** - Free recipe database
- **CalorieNinjas** - Enhanced nutrition data
- **Edamam** - Advanced recipe search

### Libraries & Packages
- **Flutter Team** - Amazing framework
- **flutter_barcode_scanner** - Barcode scanning
- **cached_network_image** - Image optimization
- **google_fonts** - Typography
- **http** - Network requests

### Design Inspiration
- Material Design 3 guidelines
- Modern fitness app patterns
- Dribbble design trends

---

## ⭐ Star History

If you find this project useful, please consider giving it a star ⭐ on GitHub!

---

## 🎉 Current Status

**Version**: 1.0.0  
**Status**: ✅ Production Ready  
**Last Updated**: November 2024

### What Works Now
- ✅ Complete food logging system
- ✅ Barcode scanning (mobile & web)
- ✅ Meal planning functionality
- ✅ Recipe discovery
- ✅ Progress tracking
- ✅ Beautiful modern UI
- ✅ Multi-platform support (iOS, Android, Web)
- ✅ Zero configuration required
- ✅ Professional design
- ✅ Smooth animations

**Ready to use right out of the box!** 🚀

---

**Built with ❤️ using Flutter**
