# Changelog

All notable changes to the Diet Planner Application will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-11-09

### Added
- **Core Features**
  - Food logging with calorie and macro tracking
  - Barcode scanning for quick food entry (mobile & web)
  - Meal planning with 4 meal types (Breakfast, Lunch, Dinner, Snack)
  - Recipe discovery with 300+ recipes from TheMealDB
  - 7-day progress tracking with visual indicators
  - Beautiful animated UI with Material Design 3

- **Firebase Integration**
  - Firebase Authentication (Email/Password & Google Sign-In)
  - Cloud Firestore for data persistence
  - Real-time sync across devices
  - Offline support with local caching
  - Guest mode for anonymous usage

- **AI Features** (Optional)
  - AI Nutrition Advisor chatbot powered by Gemini
  - Natural language food parsing
  - AI recipe generator
  - Smart meal suggestions

- **API Integration**
  - OpenFoodFacts API (2.8M+ food products)
  - TheMealDB API (300+ recipes)
  - Optional: CalorieNinjas, Edamam APIs
  - CORS proxy for web platform

- **UI/UX**
  - Animated progress rings
  - Gradient themes throughout
  - Glassmorphism effects
  - Staggered card animations
  - Empty states with actionable messages
  - Responsive design for all screen sizes

- **DevOps**
  - Professional project structure
  - Comprehensive documentation
  - CI/CD ready configuration
  - Version control with Git

### Changed
- Reorganized documentation into `/docs` folder structure
- Updated pubspec.yaml with proper descriptions
- Improved code organization and separation of concerns

### Removed
- Node.js artifacts (package.json, node_modules) - Not needed for Flutter
- Redundant documentation files from root
- Template files from production code

### Fixed
- CORS issues on web platform
- Google Sign-In authentication flow
- Recipe layout rendering issues
- Search functionality improvements

### Security
- API keys moved to secure configuration
- Firebase security rules implemented
- User data isolation in Firestore
- Sensitive files added to .gitignore

## [Unreleased]

### Planned Features
- [ ] Weekly meal plan calendar view
- [ ] Meal templates and favorites
- [ ] Shopping list auto-generation
- [ ] Weight tracking with charts
- [ ] Dark mode support
- [ ] Export data (PDF/CSV)
- [ ] Social features (share recipes/plans)
- [ ] Push notifications for meal reminders
- [ ] Water intake tracking
- [ ] Exercise integration
- [ ] Multi-language support
- [ ] Desktop app support

---

## Version History

- **1.0.0** (2024-11-09) - Initial production release
- **0.9.0** (2024-11) - Beta testing phase
- **0.5.0** (2024-10) - Alpha version with core features
- **0.1.0** (2024-09) - Project inception

---

## Links

- [Repository](https://github.com/muzamilfaryad/Diet_Planner_Application)
- [Issues](https://github.com/muzamilfaryad/Diet_Planner_Application/issues)
- [Documentation](docs/)
