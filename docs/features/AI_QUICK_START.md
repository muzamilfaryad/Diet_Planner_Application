# 🚀 AI Features Quick Start Guide

## Get Started in 2 Minutes!

### Step 1: Get Your Free API Key (1 minute)

1. Visit: **https://huggingface.co/settings/tokens**
2. Sign up or sign in (free, no payment info required)
3. Click "New token"
4. Name it "Diet Planner" and select "Read" role
5. Click "Create" and copy the token (starts with `hf_...`)

### Step 2: Add Key to App (1 minute)

1. Open: `diet_planner_app/lib/config/ai_config.dart`
2. Replace this line:
```dart
static const String hfApiKey = 'YOUR_HF_API_KEY_HERE';
```

With your actual key:
```dart
static const String hfApiKey = 'hf_...YOUR_KEY...';
```

3. Save the file

### Step 3: Install & Run (1 minute)

```bash
cd diet_planner_app
flutter pub get
flutter run
```

## ✅ Test AI Features

### 1. AI Nutrition Advisor
- Home screen → Tap "AI Advisor" card
- Ask: "How many calories should I eat to lose weight?"

### 2. AI Food Parser
- Tap "Log Food" in bottom navigation
- Type: "2 scrambled eggs"
- Press sparkle icon

### 3. AI Recipe Generator
- Home screen → Tap "Recipe Gen" card
- Add ingredients: chicken, rice, broccoli
- Tap "Generate Recipe"

---

## 🎁 What You Get (FREE!)

✅ **AI Nutrition Chatbot** - Unlimited questions  
✅ **Natural Language Food Logging** - "2 eggs" → Auto-logged  
✅ **Smart Recipe Generator** - From your ingredients  
✅ **Meal Planning Assistant** - Personalized plans  
✅ **1,000 requests/hour** - Very generous!  
✅ **24,000+ requests/day** - Perfect for personal use  
✅ **No credit card required** - Ever!  
✅ **Powered by Mistral AI** - Fast & accurate

---

## 💡 Quick Examples

### AI Advisor Questions:
```
"Best protein sources for vegetarians?"
"How to gain muscle and lose fat?"
"Is intermittent fasting effective?"
"Pre-workout meal ideas?"
```

### AI Food Parser:
```
"large apple"
"2 slices whole wheat bread"
"bowl of oatmeal"
"grilled chicken breast"
```

### Recipe Generator:
```
Ingredients: pasta, tomatoes, basil, olive oil
Cuisine: Italian
Calories: 500
→ Get custom pasta recipe!
```

---

## ⚠️ Troubleshooting

**"Setup required" on cards?**  
→ You forgot Step 2! Add your API key.

**Console shows warning?**  
→ Restart the app after adding the key.

**Food parser not showing?**  
→ API key not configured yet.

---

## 🎯 Pro Tips

1. **Be Specific:** "large apple" > "apple"
2. **Use Natural Language:** "2 scrambled eggs with cheese"
3. **Ask Detailed Questions:** Include your age/goals for better advice
4. **Try Quick Chips:** Tap the suggestion chips for examples

---

## 📖 Full Documentation

For detailed guides, troubleshooting, and advanced features:
→ See `AI_FEATURES_GUIDE.md`

---

## 🎉 That's It!

You're ready to use AI-powered nutrition tracking!

**Total setup time:** ~2 minutes  
**Cost:** $0 (Free forever, no payment info needed)  
**Value:** Unlimited intelligent nutrition assistance 🚀  
**API:** Hugging Face (1,000 requests/hour)

For detailed setup instructions, see: `HUGGINGFACE_API_SETUP.md`

Enjoy your AI-powered Diet Planner! 💪📊🍎
