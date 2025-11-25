# 🔧 AI Features Troubleshooting Guide

## Current Issue: "Sorry, I couldn't process that request"

This error typically happens due to one of these reasons:

---

## 🔍 Quick Fixes (Try in Order)

### 1. **Verify API Key Setup**

Your API key: `AIzaSyAp5aDcwj_uJKRSWXx5GYUs5x7d3icqx34`

**Steps:**
1. Visit: https://aistudio.google.com/app/apikey
2. Check if your key is listed and **enabled**
3. Click on your API key
4. **Remove all restrictions** (Allow all referrers)
5. Make sure "Gemini API" is enabled

---

### 2. **Check API Key Restrictions**

The API key might have **HTTP referrer restrictions** that block Flutter Web.

**Fix:**
1. Go to: https://console.cloud.google.com/apis/credentials
2. Find your API key
3. Click Edit (pencil icon)
4. Under "Website restrictions":
   - Select **"None"** (for testing)
   - Or add: `localhost:*`, `127.0.0.1:*`, `http://localhost/*`
5. Click Save

---

### 3. **Enable Gemini API**

Your project might not have Gemini API enabled.

**Fix:**
1. Visit: https://console.cloud.google.com/apis/library/generativelanguage.googleapis.com
2. Click **"ENABLE"**
3. Wait 1-2 minutes for activation
4. Restart your app

---

### 4. **CORS Issue (Most Likely for Web)**

Flutter Web has CORS restrictions when calling APIs directly.

**Temporary Fix:**
Test on **Android/iOS** instead of Web:
```bash
# Connect Android device or start emulator
flutter devices
flutter run -d <device-id>
```

**Permanent Fix (Advanced):**
- Use a backend proxy server
- Deploy to Firebase Hosting (has CORS configured)
- Or use Gemini through Firebase Extensions

---

### 5. **Check Console Logs**

Open Browser Dev Tools (F12) and check for errors:
- Red errors about CORS
- API key errors
- Network failures

---

## 🎯 Recommended Solution

### For Development (Quick Test):

**Option A: Test on Mobile** ✅
```bash
# This bypasses CORS issues
flutter run -d android
# or
flutter run -d ios
```

**Option B: Use Different API Endpoint**
The Gemini API might work better through Firebase:
1. Set up Firebase Functions
2. Call Gemini from backend
3. Your app calls Firebase Functions

---

### For Production:

**Best Practice: Backend Proxy**

1. Create a simple backend (Node.js, Python, etc.)
2. Backend calls Gemini API
3. Your app calls your backend

Example structure:
```
User App → Your Backend → Gemini API
        ←                ←
```

Benefits:
- No CORS issues
- API key stays secure
- Better error handling
- Rate limiting control

---

## 🧪 Test Your API Key Directly

Open this URL in browser (replace with your key):
```
https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAp5aDcwj_uJKRSWXx5GYUs5x7d3icqx34

POST Body:
{
  "contents": [{
    "parts":[{
      "text": "Say hello"
    }]
  }]
}
```

If this works, the key is valid. If not, check restrictions.

---

## 💡 Alternative: Test on Mobile First

Since web has CORS issues, let's test on mobile:

```bash
# 1. Check available devices
flutter devices

# 2. Run on Android
flutter run -d android

# 3. Or run on Chrome (but might have CORS)
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

---

## ⚠️ Common Error Messages

### "API key not valid"
- Key is wrong or not enabled
- Go to https://aistudio.google.com/app/apikey and create new one

### "CORS policy error"
- You're on Flutter Web
- Test on mobile or use backend proxy

### "Model not found"
- Gemini API not enabled
- Enable at: https://console.cloud.google.com/apis/library

### "Quota exceeded"
- Used all 1,500 daily requests
- Wait until midnight PST or upgrade

---

## 🎯 Immediate Action Plan

**Try this NOW:**

1. **Test API Key Online:**
   - Go to: https://aistudio.google.com/
   - Try the playground with your key
   - If it works there, it's a CORS issue

2. **Run on Mobile Instead:**
   ```bash
   flutter run -d android
   ```

3. **Check Console:**
   - Open Chrome Dev Tools (F12)
   - Look for error messages
   - Share the exact error message

4. **Verify API Status:**
   - Visit: https://status.cloud.google.com/
   - Check if Gemini API is operational

---

## 📞 Next Steps

**If still not working:**

1. **Share the console error** (exact message from browser F12)
2. **Test on mobile** to isolate if it's CORS
3. **Create new API key** and try again
4. **Check regional restrictions** (Gemini might not be available in all countries)

---

## 🔐 Security Note

For production apps, NEVER put API keys in client-side code!

**Proper Setup:**
1. Backend server with API key
2. Client calls backend
3. Backend calls Gemini
4. Backend returns response

This prevents:
- API key exposure
- CORS issues
- Rate limit problems
- Unauthorized usage

---

## ✅ Quick Win

**Want to see AI working RIGHT NOW?**

Run on Android emulator:
```bash
# Start emulator
flutter emulators
flutter emulators --launch <emulator-name>

# Run app
flutter run -d android
```

AI features will work perfectly on mobile! 🎉

---

## 📧 Still Need Help?

Provide these details:
1. Exact error message from console (F12)
2. Screenshot of error
3. Are you on Web, Android, or iOS?
4. Did the API key work in Gemini playground?
