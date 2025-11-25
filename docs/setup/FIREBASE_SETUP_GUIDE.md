# 🔥 Firebase Integration Guide

## Overview
Diet Planner now includes **Firebase integration** for authentication and cloud data persistence. This allows users to:
- ✅ Sign in with email/password
- ✅ Sync data across devices
- ✅ Store meal plans in the cloud
- ✅ Save food logs to Firestore
- ✅ Offline support with local cache

---

## 📋 Table of Contents
1. [Firebase Setup](#firebase-setup)
2. [Configuration](#configuration)
3. [Features Implemented](#features-implemented)
4. [Architecture](#architecture)
5. [Usage Guide](#usage-guide)
6. [Security Rules](#security-rules)
7. [Testing](#testing)

---

## 🚀 Firebase Setup

### Step 1: Create Firebase Project

1. **Go to Firebase Console**
   - Visit https://console.firebase.google.com/
   - Click "Add project" or select existing project

2. **Project Settings**
   - Name: `Diet Planner` (or your choice)
   - Enable Google Analytics (optional)
   - Choose region

### Step 2: Add Apps to Firebase

#### **For Android:**

1. In Firebase Console, click "Add app" → Android icon
2. Register app with package name: `com.example.diet_planner_app`
3. Download `google-services.json`
4. Place file in: `android/app/google-services.json`
5. Update `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```
6. Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
}
```

#### **For iOS:**

1. In Firebase Console, click "Add app" → iOS icon
2. Register app with bundle ID: `com.example.dietPlannerApp`
3. Download `GoogleService-Info.plist`
4. Place file in: `ios/Runner/GoogleService-Info.plist`
5. Update `ios/Runner/Info.plist` (if needed for permissions)

#### **For Web:**

1. In Firebase Console, click "Add app" → Web icon
2. Register app name: `Diet Planner Web`
3. Copy the Firebase configuration object

### Step 3: Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click "Get started"
3. Enable **Email/Password** sign-in method
4. (Optional) Enable **Google Sign-In** for social auth

### Step 4: Create Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Choose **Start in test mode** (we'll add security rules later)
4. Select region (choose closest to your users)

---

## ⚙️ Configuration

### Update `main.dart`

Replace the Firebase options in `lib/main.dart` with your actual values:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    // Get these from Firebase Console → Project Settings → General
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    
    // For Android
    // authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    
    // For iOS
    // iosBundleId: 'com.example.dietPlannerApp',
    
    // For Web
    // storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  ),
);
```

**How to get these values:**
1. Go to Firebase Console
2. Click gear icon → Project Settings
3. Scroll down to "Your apps"
4. Click on your app (Android/iOS/Web)
5. Copy the configuration values

### Platform-Specific Configuration

#### **Android Setup**
```gradle
// android/app/build.gradle
android {
    defaultConfig {
        minSdkVersion 21  // Required for Firebase
    }
}
```

#### **iOS Setup**
```bash
# Update CocoaPods
cd ios
pod install
cd ..
```

#### **Web Setup**
Create `web/index.html` with Firebase SDK:
```html
<script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-auth-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore-compat.js"></script>
```

---

## ✨ Features Implemented

### 1. **Firebase Authentication** (`firebase_auth_service.dart`)

**Capabilities:**
- Email/password sign up
- Email/password sign in
- Password reset
- Sign out
- Account deletion
- User-friendly error messages

**Methods:**
```dart
// Sign up new user
await FirebaseAuthService.instance.signUpWithEmail(
  email: 'user@example.com',
  password: 'password123',
  displayName: 'John Doe',
);

// Sign in existing user
await FirebaseAuthService.instance.signInWithEmail(
  email: 'user@example.com',
  password: 'password123',
);

// Sign out
await FirebaseAuthService.instance.signOut();

// Reset password
await FirebaseAuthService.instance.sendPasswordResetEmail('user@example.com');
```

### 2. **Firestore Database** (`firestore_service.dart`)

**Collections Structure:**
```
users/
  {userId}/
    ├── profile data
    ├── food_logs/
    │   └── {date}/
    │       └── foods: []
    ├── meal_plans/
    │   └── {date}/
    │       └── plan: {}
    └── favorites/
        └── {foodId}/
```

**Capabilities:**
- Save/retrieve user profiles
- Log food items with date
- Save/retrieve meal plans
- Manage favorite foods
- Query date ranges

### 3. **Hybrid Data Storage**

The app uses a **hybrid approach**:
- **Local cache** for immediate access
- **Firebase sync** for cloud backup
- **Offline support** with automatic sync when online

**Data Flow:**
```
User Action → Local Cache (instant) → Firebase Sync (background)
                    ↓
              UI Updates Immediately
```

### 4. **Authentication Screens**

#### **Login Screen** (`login_screen.dart`)
- Email/password input
- Form validation
- Password visibility toggle
- Forgot password link
- Sign up navigation
- "Continue without signing in" option

#### **Signup Screen** (`signup_screen.dart`)
- Name, email, password fields
- Password confirmation
- Strong password validation
- Account creation
- Auto-login after signup

#### **Profile Screen** (`profile_screen.dart`)
- User info display
- Sign out option
- Account deletion
- App info
- Privacy policy

---

## 🏗️ Architecture

### Services Layer

**1. FirebaseAuthService** (Singleton)
- Manages authentication state
- Provides auth methods
- Handles errors

**2. FirestoreService** (Singleton)
- Database operations
- CRUD for user data
- Query operations

**3. FoodDatabaseService** (Updated)
- Local cache + Firebase sync
- Automatic background sync
- Offline support

**4. MealPlanService** (Updated)
- Meal plan management
- Firebase persistence
- Date-based queries

### Authentication Flow

```
App Start
    ↓
Firebase.initializeApp()
    ↓
StreamBuilder(authStateChanges)
    ↓
User Signed In? → Yes → HomeScreen
                  ↓
                  No → LoginScreen
                       ↓
                  Skip → HomeScreen (Guest Mode)
```

### Data Sync Flow

```
User Adds Food
    ↓
Save to Local Cache (instant UI update)
    ↓
Check if user is signed in
    ↓
Yes → Sync to Firebase (background)
    ↓
Update complete
```

---

## 📖 Usage Guide

### For Users

#### **Sign Up**
1. Open app (Login screen appears for first-time users)
2. Tap "Sign Up"
3. Enter name, email, password
4. Tap "Sign Up" button
5. Redirected to home screen

#### **Sign In**
1. Open app
2. Enter email and password
3. Tap "Sign In"
4. Data automatically synced from cloud

#### **Guest Mode**
1. Open app
2. Tap "Continue without signing in"
3. Use app normally (data stored locally only)
4. Sign in later to sync data

#### **Forgot Password**
1. On login screen, tap "Forgot Password?"
2. Enter email address
3. Check email for reset link
4. Create new password

#### **Sign Out**
1. Go to Profile tab
2. Tap "Sign Out"
3. Confirm action
4. Returned to login screen

### For Developers

#### **Check Authentication State**
```dart
final auth = FirebaseAuthService.instance;
if (auth.isSignedIn) {
  final userId = auth.currentUserId;
  final userName = auth.currentUser?.displayName;
}
```

#### **Save Data to Firestore**
```dart
final firestore = FirestoreService.instance;

// Save meal plan
await firestore.saveMealPlan(mealPlan);

// Log food
await firestore.logFood(DateTime.now(), foodItem);

// Add to favorites
await firestore.addFavoriteFood(foodItem);
```

#### **Load User Data**
```dart
// After sign in, load user data
await FoodDatabaseService.instance.loadUserData();
await MealPlanService.instance.loadMealPlans();
```

---

## 🔒 Security Rules

### Firestore Security Rules

Update your Firestore security rules to protect user data:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function to check if user is authenticated
    function isSignedIn() {
      return request.auth != null;
    }
    
    // Helper function to check if user owns the document
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if isOwner(userId);
      
      // Subcollections inherit parent rules
      match /{document=**} {
        allow read, write: if isOwner(userId);
      }
    }
  }
}
```

**What this does:**
- Users can only access their own data
- No unauthorized access
- Subcollections (food_logs, meal_plans, favorites) are protected
- Anonymous/guest users cannot read/write to Firestore

### To Apply Rules:
1. Go to Firebase Console → Firestore Database
2. Click "Rules" tab
3. Paste the rules above
4. Click "Publish"

---

## 🧪 Testing

### Test Authentication

```bash
# Run app in debug mode
flutter run

# Test flows:
1. Sign up with new email
2. Sign out
3. Sign in with same credentials
4. Test forgot password
5. Test guest mode
```

### Test Data Persistence

```bash
1. Sign in
2. Add food logs
3. Create meal plan
4. Sign out
5. Sign in on different device/browser
6. Verify data is synced
```

### Test Offline Mode

```bash
1. Turn off internet
2. Use app (local cache works)
3. Turn on internet
4. Sign in
5. Data syncs automatically
```

---

## 📊 Database Structure

### User Document
```json
{
  "name": "John Doe",
  "age": 30,
  "heightCm": 175,
  "weightKg": 75,
  "goal": {
    "dailyCalories": 2000,
    "proteinRatio": 0.25,
    "carbsRatio": 0.5,
    "fatRatio": 0.25
  },
  "updatedAt": "2024-11-09T12:00:00Z"
}
```

### Food Log Document
```json
{
  "date": "2024-11-09T00:00:00Z",
  "foods": [
    {
      "id": "food_123",
      "name": "Apple",
      "calories": 95,
      "protein": 0.5,
      "carbs": 25,
      "fat": 0.3,
      "servingSizeGrams": 182
    }
  ]
}
```

### Meal Plan Document
```json
{
  "date": "2024-11-09T00:00:00Z",
  "plan": {
    "id": "plan_2024-11-09",
    "date": "2024-11-09T00:00:00Z",
    "meals": [
      {
        "id": "meal_breakfast",
        "type": "breakfast",
        "foods": [],
        "scheduledTime": "2024-11-09T08:00:00Z"
      }
    ],
    "notes": "Meal prep day"
  },
  "updatedAt": "2024-11-09T12:00:00Z"
}
```

---

## 🔄 Migration Guide

### Migrating Existing Users

If you had users before Firebase integration:

1. **Guest Data Preservation**
   - Local data remains in memory
   - Users can sign up and keep using local data
   - Future sync to cloud when they sign in

2. **Data Export** (Optional)
   - Add export feature to save local data
   - Let users import after sign up

---

## 🐛 Troubleshooting

### Common Issues

**Issue: "FirebaseException: Project not found"**
- Check Firebase configuration in `main.dart`
- Ensure `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is in correct location

**Issue: "PlatformException: sign_in_failed"**
- Verify email/password authentication is enabled in Firebase Console
- Check network connection

**Issue: "Permission denied" on Firestore**
- Update security rules as shown above
- Ensure user is authenticated

**Issue: "FirebaseCore not initialized"**
- Ensure `Firebase.initializeApp()` is called before `runApp()`
- Check `WidgetsFlutterBinding.ensureInitialized()` is called

---

## 📈 Performance Tips

1. **Batch Writes** - Use batch writes for multiple updates
2. **Indexing** - Create indexes for complex queries
3. **Caching** - Local cache reduces Firebase reads
4. **Lazy Loading** - Load data on-demand
5. **Pagination** - Implement pagination for large datasets

---

## 🎉 Summary

✅ **Complete Firebase integration**
✅ **Email/password authentication**
✅ **Cloud data persistence**
✅ **Offline support**
✅ **Secure data access**
✅ **Multi-device sync**
✅ **Guest mode support**
✅ **Beautiful auth screens**

### Next Steps

1. **Set up your Firebase project**
2. **Update configuration values**
3. **Deploy security rules**
4. **Test authentication flow**
5. **Test data persistence**
6. **Deploy to production**

---

## 📞 Support

For issues or questions:
- Check Firebase Console logs
- Review Firestore security rules
- Test with Firebase Emulator Suite
- Consult Firebase documentation

---

**Built with ❤️ using Flutter + Firebase**
