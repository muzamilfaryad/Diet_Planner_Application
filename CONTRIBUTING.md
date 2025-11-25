# Contributing to Diet Planner Application

Thank you for your interest in contributing to the Diet Planner Application! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Development Workflow](#development-workflow)
- [Code Standards](#code-standards)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other community members

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/Diet_Planner_Application.git
   cd Diet_Planner_Application
   ```

3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/muzamilfaryad/Diet_Planner_Application.git
   ```

## Development Setup

### Prerequisites

- **Flutter SDK** (v3.x or higher)
- **Dart SDK** (included with Flutter)
- **Git** for version control
- **IDE**: VS Code or Android Studio with Flutter plugin

### Installation

1. Navigate to the Flutter app directory:
   ```bash
   cd diet_planner_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Verify setup:
   ```bash
   flutter doctor
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Development Workflow

### Creating a Branch

Always create a new branch for your work:

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `test/` - Adding tests

### Making Changes

1. **Keep commits atomic** - One logical change per commit
2. **Write clear commit messages**:
   ```
   Short summary (50 chars or less)
   
   More detailed explanation if needed. Wrap at 72 characters.
   Explain what and why, not how.
   ```

3. **Sync with upstream** regularly:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

## Code Standards

### Dart/Flutter Guidelines

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` to check code quality
- Format code with `flutter format .`
- Keep functions small and focused (< 50 lines ideally)
- Use meaningful variable and function names
- Add comments for complex logic

### Code Organization

```
lib/
├── models/          # Data models
├── services/        # Business logic & API services
├── screens/         # UI screens
├── widgets/         # Reusable UI components
├── config/          # Configuration files
└── main.dart        # Application entry point
```

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE` or `camelCase`

## Testing Guidelines

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/food_item_test.dart

# Run with coverage
flutter test --coverage
```

### Writing Tests

- Write tests for all new features
- Maintain minimum 70% code coverage
- Test edge cases and error conditions
- Use descriptive test names

Example:
```dart
test('FoodItem calculates calories correctly', () {
  final food = FoodItem(
    name: 'Test Food',
    protein: 10,
    carbs: 20,
    fat: 5,
  );
  
  expect(food.calories, equals(165)); // 10*4 + 20*4 + 5*9
});
```

## Pull Request Process

### Before Submitting

1. **Update documentation** if needed
2. **Run tests** and ensure they pass
3. **Format code**: `flutter format .`
4. **Analyze code**: `flutter analyze`
5. **Test on multiple platforms** (iOS, Android, Web)

### PR Guidelines

1. **Create a descriptive PR title**:
   - ✅ `Add barcode scanning feature for iOS`
   - ❌ `Update code`

2. **Provide detailed description**:
   ```markdown
   ## Description
   Brief description of changes
   
   ## Changes Made
   - List of changes
   - Another change
   
   ## Testing
   - How to test the changes
   - Test cases covered
   
   ## Screenshots (if applicable)
   Add screenshots for UI changes
   
   ## Related Issues
   Closes #123
   ```

3. **Keep PRs focused** - One feature/fix per PR
4. **Respond to review feedback** promptly
5. **Rebase on main** before merging

### PR Checklist

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings from analyzer
- [ ] Tests added/updated
- [ ] All tests passing
- [ ] Tested on multiple platforms
- [ ] No breaking changes (or documented)

## Reporting Issues

### Bug Reports

Use the bug report template and include:

- **Description**: Clear description of the bug
- **Steps to Reproduce**: Numbered steps
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **Screenshots**: If applicable
- **Environment**:
  - OS: [e.g., Windows 11, macOS 13]
  - Flutter version: [e.g., 3.16.0]
  - Device: [e.g., iPhone 14, Pixel 6]

### Feature Requests

Include:
- **Description**: Clear description of the feature
- **Use Case**: Why is this feature needed?
- **Proposed Solution**: How should it work?
- **Alternatives Considered**: Other approaches

## Documentation

- Update relevant documentation with code changes
- Add inline comments for complex logic
- Update `README.md` for new features
- Add guide to `docs/` for major features

## Questions?

- Check existing [documentation](docs/)
- Search [existing issues](https://github.com/muzamilfaryad/Diet_Planner_Application/issues)
- Open a [discussion](https://github.com/muzamilfaryad/Diet_Planner_Application/discussions)

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project documentation

Thank you for contributing! 🎉
