# 🔧 Fix: Invalid CSRF Token Error

## Problem
Getting "Invalid CSRF token" when clicking "Continue with Google"

## Root Cause
localhost/127.0.0.1 not authorized in Firebase Authentication

---

## ✅ SOLUTION (Choose One):

### **Option A: Add Authorized Domains in Firebase (Recommended)**

#### Step 1: Firebase Console
1. Go to: https://console.firebase.google.com/
2. Select project: **dietplanner-7bb9e**

#### Step 2: Add localhost
1. Click **Authentication** (left sidebar)
2. Click **Settings** tab
3. Scroll to **"Authorized domains"**
4. Click **"Add domain"**
5. Type: `localhost`
6. Click **"Add"**

#### Step 3: Also add 127.0.0.1
1. Click **"Add domain"** again
2. Type: `127.0.0.1`
3. Click **"Add"**

#### Step 4: Wait & Test
1. Wait 2-5 minutes for changes to propagate
2. Close browser tab
3. Stop Flutter app (Ctrl+C)
4. Clear browser cache or use Incognito mode
5. Run: `flutter run -d chrome`
6. Try Google Sign-In again

---

### **Option B: Update Google Cloud Console (Advanced)**

#### Step 1: Go to Google Cloud Console
1. https://console.cloud.google.com/
2. Select project: **dietplanner-7bb9e**

#### Step 2: Update OAuth Client
1. **APIs & Services** → **Credentials**
2. Find OAuth 2.0 Client ID (Web client)
3. Click to edit

#### Step 3: Add Origins
**Authorized JavaScript origins:**
- `http://localhost`
- `http://localhost:54701`
- `http://127.0.0.1`

**Authorized redirect URIs:**
- `http://localhost`
- `http://localhost:54701`
- `http://127.0.0.1`

#### Step 4: Save
1. Click **"SAVE"**
2. Wait 5 minutes
3. Restart app

---

### **Option C: Use Email/Password (Works Immediately)**

While waiting for Google Sign-In to work:

1. Click **"Sign Up"** on login screen
2. Enter:
   - Name: Your Name
   - Email: your@email.com
   - Password: (at least 6 characters)
3. Click **"Sign Up"**

✅ This works immediately, no waiting!

You can try Google Sign-In again later.

---

## 🧪 Verification

After applying fixes, test:

1. **Open app**
2. **Go to Profile tab**
3. **Click "Sign In"**
4. **Click "Continue with Google"**
5. **Select Google account**

✅ Success: Redirected to Home screen
❌ Still error: Try Option C (Email/Password)

---

## 📝 Summary

**Quick Fix (2 minutes):**
1. Firebase Console → Authentication → Settings
2. Add "localhost" to Authorized domains
3. Wait 5 minutes
4. Try again

**Immediate Alternative:**
Use Email/Password sign up instead

---

## ✅ What I've Already Done

Updated your code to add explicit scopes:
```dart
GoogleSignIn(
  clientId: 'your-client-id',
  scopes: ['email', 'profile'],  ← Added
)
```

This should help with the CSRF issue.

---

## 🆘 Still Not Working?

**Use Email Authentication:**
It's already enabled and works perfectly!

1. Sign Up with email
2. Test all features
3. Your data syncs to Firebase
4. Fix Google Sign-In later

**Both methods give you the same features!**

---

Built with ❤️ - Firebase Integration Team
