# 🌐 API Integration Guide

## Overview
The Diet Planner app is integrated with **multiple excellent public APIs** to provide comprehensive nutrition data, food information, and recipe discovery. All primary features work **WITHOUT any API keys** using free, public APIs!

---

## ✅ Integrated APIs

### 1. **OpenFoodFacts API** ⭐ PRIMARY
**Status**: ✅ **Working Now - No API Key Required**

**Details:**
- **Website**: https://world.openfoodfacts.org
- **Database**: 2.8+ million food products worldwide
- **Features**:
  - Product search by name
  - Barcode scanning lookup
  - Complete nutrition data (calories, protein, carbs, fat)
  - Brand information
  - Serving sizes
- **Rate Limit**: No official limit (reasonable use)
- **Cost**: 100% FREE, no registration needed

**Example Usage:**
```dart
// Search for foods
final results = await EnhancedApiService.instance.searchOpenFoodFacts('apple');

// Lookup by barcode
final product = await EnhancedApiService.instance.fetchFoodByBarcode('3017620422003');
```

**API Endpoints:**
- Search: `https://world.openfoodfacts.org/cgi/search.pl`
- Barcode: `https://world.openfoodfacts.org/api/v0/product/{barcode}.json`

---

### 2. **TheMealDB API** ⭐ PRIMARY
**Status**: ✅ **Working Now - No API Key Required**

**Details:**
- **Website**: https://www.themealdb.com/api.php
- **Database**: 300+ recipes with full instructions
- **Features**:
  - Recipe search by name
  - Random recipe discovery
  - Filter by category (Vegan, Vegetarian, Seafood, etc.)
  - Filter by cuisine (Italian, Chinese, Mexican, etc.)
  - Full ingredients list
  - Step-by-step instructions
  - YouTube video links
  - Recipe images
- **Rate Limit**: No known limit
- **Cost**: 100% FREE forever

**Example Usage:**
```dart
// Search recipes
final recipes = await EnhancedApiService.instance.searchRecipes('chicken');

// Get random recipes
final random = await EnhancedApiService.instance.getRandomRecipes(count: 5);

// Filter by category
final vegan = await EnhancedApiService.instance.getRecipesByCategory('Vegan');
```

**Available Categories:**
- Beef, Chicken, Dessert, Lamb, Pasta, Pork, Seafood
- Vegan, Vegetarian, Breakfast, and more

---

### 3. **CalorieNinjas API** (Optional Enhancement)
**Status**: 🔧 **Optional - Requires Free API Key**

**Details:**
- **Website**: https://calorieninjas.com/api
- **Signup**: Instant, no credit card required
- **Free Tier**: 500 requests/month
- **Features**:
  - Natural language nutrition search
  - "1 apple" or "2 eggs" queries
  - Accurate calorie and macro data
  - Fallback when OpenFoodFacts has no results
- **Cost**: FREE tier available

**How to Get API Key:**
1. Visit https://calorieninjas.com/api
2. Click "Get API Key"
3. Sign up with email (instant approval)
4. Copy your API key
5. Add to `lib/services/api_config.dart`:
   ```dart
   static const String? calorieNinjasApiKey = 'YOUR_KEY_HERE';
   ```

**Example Usage:**
```dart
final results = await EnhancedApiService.instance.searchCalorieNinjas(
  'chicken breast',
  apiKey: ApiConfig.calorieNinjasApiKey,
);
```

---

### 4. **Edamam Recipe API** (Optional Enhancement)
**Status**: 🔧 **Optional - Requires Free API Key**

**Details:**
- **Website**: https://developer.edamam.com/
- **Signup**: Free account required
- **Free Tier**: 10,000 requests/month
- **Features**:
  - 2.3+ million recipes
  - Advanced nutritional analysis
  - Diet labels (Low-Carb, High-Protein, etc.)
  - Health labels (Vegan, Gluten-Free, etc.)
  - Complete ingredient breakdown
- **Cost**: FREE tier with generous limits

**How to Get API Credentials:**
1. Visit https://developer.edamam.com/
2. Sign up for free account
3. Choose "Recipe Search API"
4. Get your App ID and App Key
5. Add to `lib/services/api_config.dart`:
   ```dart
   static const String? edamamAppId = 'YOUR_APP_ID';
   static const String? edamamAppKey = 'YOUR_APP_KEY';
   ```

**Example Usage:**
```dart
final recipes = await EnhancedApiService.instance.searchEdamamRecipes(
  'pasta',
  appId: ApiConfig.edamamAppId!,
  appKey: ApiConfig.edamamAppKey!,
);
```

---

## 🚀 Smart Search Features

### Multi-API Food Search
The app automatically tries multiple APIs to find the best results:

```dart
final results = await EnhancedApiService.instance.smartFoodSearch('banana');
```

**Search Order:**
1. **OpenFoodFacts** (free, fast, large database)
2. **CalorieNinjas** (if API key provided and first search fails)

### Multi-API Recipe Search
Combines results from multiple sources:

```dart
final recipes = await EnhancedApiService.instance.smartRecipeSearch(
  'healthy dinner',
  edamamAppId: apiId,
  edamamAppKey: apiKey,
);
```

**Search Order:**
1. **TheMealDB** (free, always works)
2. **Edamam** (if credentials provided, adds more results)

---

## 📋 Configuration File

**Location**: `lib/services/api_config.dart`

**Current Settings:**
```dart
class ApiConfig {
  // Working APIs (No keys needed)
  static const bool useOpenFoodFacts = true;  ✅
  static const bool useTheMealDB = true;      ✅
  
  // Optional Enhanced APIs (Add your keys)
  static const String? calorieNinjasApiKey = null;  // Optional
  static const String? edamamAppId = null;          // Optional
  static const String? edamamAppKey = null;         // Optional
}
```

**To Add Optional Keys:**
1. Open `lib/services/api_config.dart`
2. Uncomment the lines
3. Replace `YOUR_KEY_HERE` with your actual key
4. Save and restart the app

---

## 🎯 Features by API

### Food Logging Features
- ✅ **Search any food** - OpenFoodFacts
- ✅ **Scan barcodes** - OpenFoodFacts
- ✅ **Get nutrition data** - OpenFoodFacts
- 🔧 **Natural language search** - CalorieNinjas (optional)

### Recipe Features
- ✅ **Search recipes** - TheMealDB
- ✅ **Random recipes** - TheMealDB
- ✅ **Filter by category** - TheMealDB
- ✅ **Full instructions** - TheMealDB
- ✅ **Ingredient lists** - TheMealDB
- 🔧 **Advanced recipes** - Edamam (optional)
- 🔧 **Diet filtering** - Edamam (optional)

### Meal Planning Features
- ✅ **Create meal plans** - Built-in service
- ✅ **Track nutrition** - Built-in calculations
- ✅ **Copy plans** - Built-in functionality
- ✅ **Add foods to meals** - OpenFoodFacts integration

---

## 🔍 API Response Examples

### OpenFoodFacts Product
```json
{
  "code": "3017620422003",
  "product_name": "Nutella",
  "brands": "Ferrero",
  "nutriments": {
    "energy-kcal_100g": 539,
    "proteins_100g": 6.3,
    "carbohydrates_100g": 57.5,
    "fat_100g": 30.9
  },
  "serving_size": "15g"
}
```

### TheMealDB Recipe
```json
{
  "idMeal": "52772",
  "strMeal": "Teriyaki Chicken",
  "strCategory": "Chicken",
  "strArea": "Japanese",
  "strInstructions": "Step-by-step...",
  "strMealThumb": "https://...",
  "strIngredient1": "soy sauce",
  "strMeasure1": "3 tbs"
}
```

---

## ⚡ Performance & Caching

### Built-in Optimizations
1. **Local Caching**: All searched foods cached in memory
2. **Smart Timeouts**: 10-second timeout per API call
3. **Fallback Logic**: Automatically tries backup APIs
4. **Error Handling**: Graceful failures with user feedback

### Best Practices
- Search results are cached to reduce API calls
- Barcode lookups are instant (single API call)
- Recipe images use `cached_network_image` for performance

---

## 🛠️ Troubleshooting

### Issue: "No results found"
**Solutions:**
1. Check internet connection
2. Try different search terms
3. Verify spelling
4. Try barcode scanning instead

### Issue: "API timeout"
**Solutions:**
1. Check internet speed
2. Try again (temporary network issue)
3. Search for more common items

### Issue: "CalorieNinjas not working"
**Solutions:**
1. Verify API key is correct in `api_config.dart`
2. Check you haven't exceeded 500 requests/month
3. Ensure key is uncommented in config

### Issue: "Edamam not working"
**Solutions:**
1. Verify both App ID and App Key are set
2. Check credentials are correct
3. Ensure you selected "Recipe Search API" during signup

---

## 📊 API Comparison

| Feature | OpenFoodFacts | TheMealDB | CalorieNinjas | Edamam |
|---------|---------------|-----------|---------------|---------|
| **Cost** | FREE | FREE | FREE* | FREE* |
| **API Key** | ❌ No | ❌ No | ✅ Yes | ✅ Yes |
| **Database Size** | 2.8M products | 300+ recipes | Large | 2.3M recipes |
| **Barcode Scan** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **Recipe Search** | ❌ No | ✅ Yes | ❌ No | ✅ Yes |
| **Instructions** | ❌ No | ✅ Yes | ❌ No | ✅ Yes |
| **Natural Language** | ❌ No | ❌ No | ✅ Yes | ❌ No |
| **Rate Limit** | None | None | 500/month | 10K/month |

*Free tier available

---

## 🎓 Learning Resources

### API Documentation
- **OpenFoodFacts**: https://wiki.openfoodfacts.org/API
- **TheMealDB**: https://www.themealdb.com/api.php
- **CalorieNinjas**: https://calorieninjas.com/api
- **Edamam**: https://developer.edamam.com/edamam-docs-recipe-api

### Code Examples
All API integrations are in:
- `lib/services/enhanced_api_service.dart` - Main API service
- `lib/services/api_config.dart` - Configuration
- `lib/widgets/food_search.dart` - Food search UI
- `lib/screens/recipe_screen_enhanced.dart` - Recipe UI

---

## ✅ Quick Start Checklist

**Minimum Setup (Works Immediately):**
- [x] OpenFoodFacts - Already configured ✅
- [x] TheMealDB - Already configured ✅
- [x] Food search - Working ✅
- [x] Barcode scanning - Working ✅
- [x] Recipe discovery - Working ✅

**Optional Enhancements:**
- [ ] Sign up for CalorieNinjas (5 min)
- [ ] Add CalorieNinjas API key to config
- [ ] Sign up for Edamam (5 min)
- [ ] Add Edamam credentials to config

---

## 🎉 Summary

Your Diet Planner app now has:
- ✅ **2.8M+ food database** via OpenFoodFacts
- ✅ **300+ recipes** via TheMealDB
- ✅ **Barcode scanning** capability
- ✅ **Zero configuration** needed to start
- ✅ **Optional enhancements** available
- ✅ **Smart multi-API search**
- ✅ **Automatic fallback** logic
- ✅ **Professional error handling**

**All core features work immediately without any API keys or setup!** 🚀
