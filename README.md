# 🥗 Diet Planner - Multi-Platform Nutrition & Meal Management Application

[![Platform](https://img.shields.io/badge/Platform-Flutter-blue?logo=flutter&logoColor=white)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-brightgreen)](#)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Maintenance](https://img.shields.io/badge/Maintained-yes-green.svg)](https://github.com/muzamilfaryad/Diet_Planner_Application/graphs/commit-activity)
[![Security](https://img.shields.io/badge/Security-Policy-blue)](SECURITY.md)

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

### 🔥 Firebase Integration
- **Email/Password Authentication**: Secure user accounts
- **Cloud Firestore**: Real-time data sync across devices
- **Offline Support**: Local cache with automatic sync
- **Guest Mode**: Use app without signing in
- **Profile Management**: Sign in/out, password reset
- **Data Privacy**: User data isolated and secure

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

**Optional AI Enhancements** (free, secure setup):
- 🤖 **Hugging Face AI** - Natural language food parsing, recipe generation, nutrition chatbot
  - **Status**: ✅ **FIXED & SECURED** (Nov 2024)
  - **Setup**: See [AI_INTEGRATION_GUIDE.md](AI_INTEGRATION_GUIDE.md)
  - Get free API key (no payment): https://huggingface.co/settings/tokens

**Other Optional APIs**:
- 🔧 **CalorieNinjas** - Enhanced nutrition search
- 🔧 **Edamam** - Advanced recipe search with 2.3M+ recipes

See [docs/guides/API_INTEGRATION_GUIDE.md](docs/guides/API_INTEGRATION_GUIDE.md) for details.

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
│   │   ├── config/                # Configuration files
│   │   ├── models/                # Data models (User, Meal, FoodItem, etc.)
│   │   ├── services/              # Business logic & API integration
│   │   ├── screens/               # UI screens
│   │   ├── widgets/               # Reusable UI components
│   │   └── main.dart              # Application entry point
│   ├── android/                   # Android platform files
│   ├── ios/                       # iOS platform files
│   ├── web/                       # Web platform files
│   └── pubspec.yaml               # Dependencies & configuration
├── docs/                          # 📚 Documentation
│   ├── setup/                     # Setup & configuration guides
│   ├── features/                  # Feature documentation
│   ├── guides/                    # Integration & development guides
│   └── README.md                  # Documentation index
├── CHANGELOG.md                   # Version history
├── CONTRIBUTING.md                # Contribution guidelines
├── LICENSE                        # MIT License
├── SECURITY.md                    # Security policy
└── README.md                      # This file
```

---

## 📚 Documentation

Comprehensive documentation is available in the [`docs/`](docs/) directory:

### Quick Links
- **[Documentation Index](docs/README.md)** - Complete documentation overview
- **[Contributing Guide](CONTRIBUTING.md)** - How to contribute
- **[Changelog](CHANGELOG.md)** - Version history and updates
- **[Security Policy](SECURITY.md)** - Security guidelines and reporting

### Popular Guides
- **[Firebase Setup](docs/setup/FIREBASE_SETUP_GUIDE.md)** - Backend integration
- **[API Integration](docs/guides/API_INTEGRATION_GUIDE.md)** - API configuration
- **[AI Features](docs/features/AI_FEATURES_GUIDE.md)** - AI capabilities
- **[Production Checklist](docs/guides/PRODUCTION_READY_CHECKLIST.md)** - Deployment guide

**→ See [docs/README.md](docs/README.md) for complete documentation index**

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
- [x] **User Authentication**: Firebase Auth integration ✅ **NEW!**
- [x] **Data Persistence**: Save user data to cloud (Firestore) ✅ **NEW!**
- [x] **Offline Support**: Local database with sync ✅ **NEW!**
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
