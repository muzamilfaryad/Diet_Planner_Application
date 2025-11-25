# 🔧 Enable Google People API - Quick Fix

## Error You're Seeing:
```
People API has not been used in project 1037372126451 before or it is disabled.
Status: PERMISSION_DENIED
```

## ✅ SOLUTION (2 minutes):

### Step 1: Click This Link
**Direct link to enable the API:**
https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=1037372126451

### Step 2: Enable the API
1. You'll see "People API" page
2. Click the **"ENABLE"** button
3. Wait 10 seconds for activation

### Step 3: Test Again
1. Close your browser tab
2. Restart the app: `flutter run -d chrome`
3. Try "Continue with Google" again
4. ✅ Should work now!

---

## Alternative Quick Links:

**If the direct link doesn't work:**

1. Go to: https://console.cloud.google.com/
2. Select project: **dietplanner-7bb9e**
3. Search for "People API" in the search bar
4. Click on it
5. Click "ENABLE"

---

## ✅ What This API Does:
- Gets user's name from Google account
- Gets user's email from Google account
- Gets profile picture (optional)

Required for Google Sign-In to work properly.

---

## 🎉 After Enabling:
Google Sign-In will work perfectly!
