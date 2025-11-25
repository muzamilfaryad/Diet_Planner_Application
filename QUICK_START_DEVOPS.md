# 🚀 Quick Start Guide for Developers

## Welcome to Diet Planner Application!

This guide will get you up and running in minutes.

---

## ⚡ Instant Setup (5 minutes)

### 1. Prerequisites Check
```bash
flutter doctor
git --version
```

### 2. Clone & Install
```bash
git clone https://github.com/muzamilfaryad/Diet_Planner_Application.git
cd Diet_Planner_Application/diet_planner_app
flutter pub get
```

### 3. Run the App
```bash
# Android/iOS
flutter run

# Web
flutter run -d chrome
```

**That's it!** The app works immediately with free APIs (no keys needed).

---

## 📁 Project Structure at a Glance

```
FlutterProjectDietPlanner/
├── diet_planner_app/         # 👈 Main Flutter app (work here)
│   ├── lib/
│   │   ├── screens/          # UI screens
│   │   ├── services/         # API & business logic
│   │   ├── models/           # Data models
│   │   └── widgets/          # Reusable components
│   └── pubspec.yaml
├── docs/                     # 📚 All documentation
├── .github/                  # CI/CD & templates
└── README.md                 # Start here
```

---

## 🎯 Common Tasks

### Run Tests
```bash
cd diet_planner_app
flutter test
```

### Check Code Quality
```bash
flutter analyze
dart format .
```

### Build Release
```bash
# Android APK
flutter build apk --release

# Web
flutter build web --release
```

---

## 📚 Key Documentation

| What | Where |
|------|-------|
| **Getting Started** | [README.md](README.md) |
| **All Docs** | [docs/README.md](docs/README.md) |
| **Firebase Setup** | [docs/setup/FIREBASE_SETUP_GUIDE.md](docs/setup/FIREBASE_SETUP_GUIDE.md) |
| **API Setup** | [docs/guides/API_INTEGRATION_GUIDE.md](docs/guides/API_INTEGRATION_GUIDE.md) |
| **Contributing** | [CONTRIBUTING.md](CONTRIBUTING.md) |
| **DevOps Summary** | [DEVOPS_SUMMARY.md](DEVOPS_SUMMARY.md) |

---

## 🔥 Optional: Firebase Setup (10 minutes)

1. Create Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Follow [docs/setup/FIREBASE_SETUP_GUIDE.md](docs/setup/FIREBASE_SETUP_GUIDE.md)
3. Enable Authentication and Firestore
4. Done! Users can now sign in and sync data.

---

## 🤖 Optional: AI Features (5 minutes)

1. Get free Gemini API key from [ai.google.dev](https://ai.google.dev)
2. Add to `lib/config/ai_config.dart`
3. See [docs/features/AI_QUICK_START.md](docs/features/AI_QUICK_START.md)

---

## 🐛 Troubleshooting

### App won't run?
```bash
flutter clean
flutter pub get
flutter run
```

### API issues?
- Check internet connection
- See [docs/guides/CORS_FIX_DOCUMENTATION.md](docs/guides/CORS_FIX_DOCUMENTATION.md) for web

### Firebase errors?
- Verify [docs/setup/FIREBASE_SETUP_GUIDE.md](docs/setup/FIREBASE_SETUP_GUIDE.md) steps
- Check Firebase Console for enabled services

---

## 🤝 Contributing

1. **Fork** the repo
2. **Create branch**: `git checkout -b feature/my-feature`
3. **Make changes** and test
4. **Commit**: `git commit -m 'Add feature'`
5. **Push**: `git push origin feature/my-feature`
6. **Open PR** on GitHub

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## 📋 Pre-Commit Checklist

Before committing code:

```bash
# Format code
dart format .

# Analyze
flutter analyze

# Test
flutter test

# Build (verify no errors)
flutter build apk --debug
```

---

## 🎨 Code Style

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `camelCase` or `SCREAMING_SNAKE_CASE`

EditorConfig is set up - your IDE will handle most formatting automatically.

---

## 🔒 Security Reminders

**Never commit:**
- ❌ API keys
- ❌ Firebase credentials  
- ❌ `.env` files
- ❌ `api_keys.dart` with real keys

**Always:**
- ✅ Use environment variables for secrets
- ✅ Check `.gitignore` before committing
- ✅ Review changes before pushing

---

## 🚀 Release Process

1. **Update version** in `pubspec.yaml`
2. **Update** [CHANGELOG.md](CHANGELOG.md)
3. **Test** thoroughly
4. **Build release** versions
5. **Tag release**: `git tag v1.0.0`
6. **Push tags**: `git push --tags`
7. **Create GitHub release** with notes

---

## 📊 Project Status

- **Version**: 1.0.0
- **Status**: ✅ Production Ready
- **Flutter**: 3.16.0+
- **Platforms**: Android, iOS, Web
- **License**: MIT

---

## 💡 Tips for New Contributors

1. **Start small**: Pick a "good first issue" label
2. **Ask questions**: Use GitHub Discussions
3. **Read docs**: Check `docs/` before asking
4. **Test**: Always test on multiple platforms
5. **Be patient**: Reviews take time

---

## 📞 Need Help?

- **Issues**: [GitHub Issues](https://github.com/muzamilfaryad/Diet_Planner_Application/issues)
- **Discussions**: [GitHub Discussions](https://github.com/muzamilfaryad/Diet_Planner_Application/discussions)
- **Security**: See [SECURITY.md](SECURITY.md)
- **Docs**: [docs/README.md](docs/README.md)

---

## ⭐ Quick Commands Reference

```bash
# Setup
flutter pub get

# Run
flutter run
flutter run -d chrome

# Test
flutter test
flutter test --coverage

# Quality
flutter analyze
dart format .

# Build
flutter build apk --release
flutter build web --release
flutter build ios --release

# Clean
flutter clean

# Update dependencies
flutter pub upgrade
```

---

## 🎉 You're Ready!

You now have everything you need to:
- ✅ Run the application
- ✅ Make changes
- ✅ Submit contributions
- ✅ Deploy to production

**Happy coding!** 🚀

---

*For detailed information, see [DEVOPS_SUMMARY.md](DEVOPS_SUMMARY.md)*
