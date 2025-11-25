# 🚀 API Quick Start Guide

## ✅ What's Working RIGHT NOW (No Setup Required)

Your Diet Planner app is **fully functional** with these features already working:

### 1. **Food Search** 🔍
- Search 2.8M+ food products
- Get complete nutrition data
- Powered by **OpenFoodFacts** (FREE, no API key)

**Try searching:**
- "apple"
- "chicken breast"
- "brown rice"
- "nutella"

### 2. **Barcode Scanning** 📱
- Scan any food barcode
- Instant nutrition lookup
- Powered by **OpenFoodFacts** (FREE, no API key)

**Try scanning:**
- Cereal boxes
- Packaged foods
- Beverages
- Snacks

### 3. **Recipe Discovery** 👨‍🍳
- Browse 300+ recipes
- Full ingredients & instructions
- Random recipe discovery
- Filter by category (Vegan, Chicken, Pasta, etc.)
- Powered by **TheMealDB** (FREE, no API key)

**Try searching:**
- "pasta"
- "chicken"
- "vegan"
- "dessert"

---

## 🎯 How to Use the APIs

### Food Logging

1. **Navigate to "Log" tab**
2. **Search for food:**
   - Type food name
   - Click "Search"
   - Results appear instantly from OpenFoodFacts
3. **Or scan barcode:**
   - Click scanner icon in header
   - Point camera at barcode
   - Food details appear automatically
4. **Add to log:**
   - Click "+" on any food
   - It's logged to today

### Recipe Browsing

1. **Navigate to "Recipes" tab**
2. **Browse random recipes** (shown by default)
3. **Search recipes:**
   - Type dish name
   - Press Enter or click Search
4. **Filter by category:**
   - Tap category chips (Vegan, Chicken, etc.)
5. **View details:**
   - Tap any recipe card
   - See full instructions and ingredients

---

## 🔧 Optional: Add More Data Sources

Want even MORE food data and recipes? Add these **optional FREE API keys**:

### Option 1: CalorieNinjas (Natural Language Food Search)

**What it adds:**
- Search like "2 eggs and toast"
- More accurate portion sizes
- Fallback when OpenFoodFacts has no results

**How to add (5 minutes):**

1. **Sign up:**
   - Visit: https://calorieninjas.com/api
   - Click "Get API Key"
   - Enter your email
   - Instant approval!

2. **Get your key:**
   - Check email or dashboard
   - Copy API key

3. **Add to app:**
   - Open: `lib/services/api_config.dart`
   - Find line 27: `static const String? calorieNinjasApiKey = null;`
   - Change to: `static const String? calorieNinjasApiKey = 'YOUR_KEY_HERE';`
   - Save file
   - Restart app

**Free tier:** 500 searches/month

---

### Option 2: Edamam Recipe API (Advanced Recipes)

**What it adds:**
- 2.3M+ recipes (vs 300)
- Diet filtering (Low-Carb, Keto, etc.)
- Health labels (Gluten-Free, Dairy-Free)
- Advanced nutrition analysis

**How to add (5 minutes):**

1. **Sign up:**
   - Visit: https://developer.edamam.com/
   - Create free account
   - Choose "Recipe Search API"

2. **Get credentials:**
   - Copy App ID
   - Copy App Key

3. **Add to app:**
   - Open: `lib/services/api_config.dart`
   - Find lines 28-29:
     ```dart
     static const String? edamamAppId = null;
     static const String? edamamAppKey = null;
     ```
   - Change to:
     ```dart
     static const String? edamamAppId = 'YOUR_APP_ID';
     static const String? edamamAppKey = 'YOUR_APP_KEY';
     ```
   - Save file
   - Restart app

**Free tier:** 10,000 searches/month

---

## 📱 Testing the APIs

### Test Food Search

1. Open app → Go to "Log" tab
2. Search "banana"
3. Should see results from OpenFoodFacts
4. Check bottom: "Results from OpenFoodFacts"
5. Tap "+" to add to log

### Test Barcode Scan

1. Open app → Go to "Log" tab
2. Click scanner icon in header
3. Point at any food barcode
4. Food details should appear
5. Click "Add" to log it

### Test Recipe Search

1. Open app → Go to "Recipes" tab
2. See 6 random recipes (loaded on start)
3. Search "chicken curry"
4. Should see matching recipes
5. Tap any recipe to see details
6. Scroll to see ingredients & instructions

### Test Recipe Categories

1. Go to "Recipes" tab
2. Scroll category chips at top
3. Tap "Vegan"
4. See only vegan recipes
5. Tap "Dessert"
6. See only desserts

---

## 🐛 Troubleshooting

### "No results found" when searching

**Fix:**
- Check internet connection
- Try different search term
- Verify spelling
- Try more common foods first

### Barcode scanner not working

**Fix:**
- Grant camera permissions
- Ensure good lighting
- Hold steady on barcode
- Try manual search instead

### Recipes not loading

**Fix:**
- Check internet connection
- Wait a few seconds for images to load
- Try refresh (search again)

### API source not showing

**Fix:**
- Check `lib/services/api_config.dart`
- Ensure `showApiSource = true` (line 70)
- Restart app

---

## 📊 What Each API Provides

| API | Food Search | Barcode | Recipes | Instructions | Free? |
|-----|-------------|---------|---------|--------------|-------|
| **OpenFoodFacts** | ✅ 2.8M items | ✅ Yes | ❌ No | ❌ No | ✅ Yes |
| **TheMealDB** | ❌ No | ❌ No | ✅ 300+ | ✅ Full | ✅ Yes |
| **CalorieNinjas** | ✅ Natural language | ❌ No | ❌ No | ❌ No | ✅ 500/mo |
| **Edamam** | ❌ No | ❌ No | ✅ 2.3M+ | ✅ Full | ✅ 10K/mo |

---

## 💡 Pro Tips

### Better Food Search Results
1. Use brand names: "Skippy peanut butter"
2. Be specific: "grilled chicken breast" not just "chicken"
3. Try barcode scan for packaged foods
4. Check serving sizes carefully

### Better Recipe Discovery
1. Use category filters first
2. Search single ingredients: "chicken" not "chicken recipe"
3. Browse random recipes for inspiration
4. Save favorites to meal planner

### Maximize Free Tiers
1. **Cache results:** App automatically caches searches
2. **Batch queries:** Search once, browse results
3. **Use OpenFoodFacts first:** No limits!
4. **TheMealDB unlimited:** Browse freely

---

## ✅ Summary

**Working NOW without setup:**
- ✅ Search 2.8M+ foods (OpenFoodFacts)
- ✅ Scan barcodes (OpenFoodFacts)
- ✅ Browse 300+ recipes (TheMealDB)
- ✅ Full nutrition data
- ✅ Recipe instructions
- ✅ Zero configuration needed!

**Optional (5 min each):**
- 🔧 CalorieNinjas for natural language search
- 🔧 Edamam for 2M+ more recipes

**Your app is fully functional right now!** 🎉

Just install, open, and start searching. No API keys required for core features!
