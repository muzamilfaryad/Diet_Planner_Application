# 🤖 AI Features Guide - Diet Planner App

## Overview

Your Diet Planner app now includes powerful AI features powered by **Google's Gemini AI** (free tier). These features provide intelligent nutrition advice, natural language food logging, recipe generation, and meal planning.

---

## 🎯 AI Features Included

### 1. **AI Nutrition Advisor Chatbot** 💬
- Ask any nutrition or diet-related questions
- Get personalized advice from an AI nutrition expert
- Topics: weight loss, muscle gain, meal timing, supplements, etc.
- **Access:** Home screen → "AI Advisor" card

### 2. **AI Food Parser** 🍎
- Log food using natural language descriptions
- Examples: "2 large eggs", "a bowl of oatmeal", "grilled chicken breast"
- AI automatically calculates calories and macros
- **Access:** Log Food screen (top section when AI is enabled)

### 3. **AI Recipe Generator** 🍳
- Generate custom recipes from ingredients you have
- Specify dietary restrictions (vegan, keto, gluten-free, etc.)
- Choose cuisine type (Italian, Mexican, Asian, etc.)
- Set target calories per serving
- **Access:** Home screen → "Recipe Gen" card

### 4. **AI Meal Planning** (Coming in future updates)
- Generate complete meal plans based on your goals
- Balanced macros and calorie targets
- Personalized to dietary preferences

---

## 🔧 Setup Instructions

### Step 1: Get Your Free Gemini API Key

1. Visit **[Google AI Studio](https://makersuite.google.com/app/apikey)**
2. Sign in with your Google account
3. Click **"Create API Key"**
4. Copy your API key (starts with `AIza...`)

### Step 2: Add API Key to Your App

1. Open the file: `lib/config/ai_config.dart`
2. Replace `YOUR_GEMINI_API_KEY_HERE` with your actual API key:

```dart
class AIConfig {
  static const String geminiApiKey = 'AIzaSy...YOUR_ACTUAL_KEY...';
  
  static bool get isConfigured => geminiApiKey != 'YOUR_GEMINI_API_KEY_HERE' && geminiApiKey.isNotEmpty;
}
```

3. Save the file
4. Run `flutter pub get` in terminal
5. Restart the app

### Step 3: Test AI Features

1. Launch the app
2. Check console logs for: `✅ Gemini AI initialized successfully! 🤖`
3. Try the AI features from the home screen

---

## 📊 Free Tier Limits

Google Gemini API Free Tier:
- ✅ **60 requests per minute**
- ✅ **1,500 requests per day**
- ✅ **No credit card required**
- ✅ Perfect for personal use

These limits are more than enough for typical daily usage!

---

## 🎨 How to Use Each Feature

### AI Nutrition Advisor

1. Tap **"AI Advisor"** on home screen
2. Type your nutrition question
3. Or use quick suggestion chips
4. Get instant AI-powered advice

**Example Questions:**
- "How many calories should I eat to lose 1 pound per week?"
- "What are the best protein sources for vegetarians?"
- "Is intermittent fasting effective?"
- "What should I eat before a workout?"

---

### AI Food Parser

1. Go to **Log Food** screen
2. See the AI Food Parser section at top (blue gradient box)
3. Type natural descriptions like:
   - "2 scrambled eggs"
   - "large apple"
   - "bowl of brown rice"
   - "grilled salmon fillet"
4. Press the sparkle icon or hit enter
5. Food is automatically logged with nutrition data!

**Tips:**
- Be specific: "large apple" vs just "apple"
- Include quantity: "2 slices of bread"
- Mention cooking method: "grilled", "fried", "raw"

---

### AI Recipe Generator

1. Tap **"Recipe Gen"** on home screen
2. Add ingredients you have (tap the chips or type manually)
3. Optional: Set dietary restrictions
4. Optional: Choose cuisine type
5. Optional: Set target calories
6. Tap **"Generate Recipe"**
7. Get a complete recipe with:
   - Ingredient list with amounts
   - Step-by-step instructions
   - Nutrition information
   - Cooking time
   - Chef's tips

**Example:**
- Ingredients: chicken breast, broccoli, rice, soy sauce
- Cuisine: Asian
- Calories: 500
- Result: Custom Asian chicken bowl recipe!

---

## 🔒 Security Best Practices

### For Development:
- Keep API key in `ai_config.dart`
- Add `ai_config.dart` to `.gitignore`
- Never commit real API keys to GitHub

### For Production:
- Use environment variables
- Store keys in secure storage (Firebase Remote Config, AWS Secrets Manager, etc.)
- Implement backend proxy for API calls
- Monitor usage and set up alerts

---

## ⚠️ Troubleshooting

### "AI features require API key configuration"
**Solution:** You haven't added your API key yet. Follow Step 2 above.

### "AI service not initialized"
**Solution:** 
1. Check console logs for errors
2. Verify API key is correct
3. Ensure you ran `flutter pub get`
4. Restart the app

### "Could not parse food description"
**Solution:**
1. Make your description more specific
2. Include quantity and size
3. Try simpler descriptions
4. Example: Instead of "my mom's special pasta", try "bowl of spaghetti with tomato sauce"

### "Error generating recipe"
**Solution:**
1. Check internet connection
2. Ensure you have at least 2-3 ingredients
3. Try again (sometimes AI needs a retry)
4. Check if you've hit daily rate limit (1,500 requests/day)

### Rate Limit Exceeded
**Solution:**
- Wait for the limit to reset (daily at midnight PST)
- Or upgrade to paid tier if needed (rarely necessary for personal use)

---

## 📱 Feature Availability

| Feature | Status | Access |
|---------|--------|--------|
| AI Nutrition Advisor | ✅ Ready | Home → AI Advisor |
| AI Food Parser | ✅ Ready | Log Food screen |
| AI Recipe Generator | ✅ Ready | Home → Recipe Gen |
| AI Meal Planner | 🚧 Coming Soon | - |
| AI Progress Insights | 🚧 Coming Soon | - |

---

## 💡 Tips for Best Results

### Food Parser:
- ✅ "2 large eggs" → Better
- ❌ "some eggs" → Vague

### Nutrition Advisor:
- ✅ Ask specific questions
- ✅ Provide context (age, goals, etc.)
- ❌ Don't ask for medical advice

### Recipe Generator:
- ✅ Use 3-8 ingredients for best results
- ✅ Be specific about restrictions
- ❌ Don't use too many ingredients (10+)

---

## 🔮 Future AI Features (Planned)

- 📊 **AI Progress Analyzer:** Get insights on your nutrition trends
- 🎯 **Smart Goal Setting:** AI-recommended goals based on your data
- 📸 **Food Image Recognition:** Take photo → Auto-log nutrition
- 🗣️ **Voice Input:** Speak to log food hands-free
- 🔔 **AI Meal Reminders:** Smart timing based on your schedule
- 📈 **Predictive Analytics:** Forecast weight trends

---

## 🆘 Support

### Need Help?
1. Check this guide first
2. Review console logs for errors
3. Test with simple queries first
4. Ensure stable internet connection

### Report Issues:
- Provide console error logs
- Describe what you were trying to do
- Include example input that failed

---

## 🎉 You're All Set!

Your Diet Planner app is now powered by AI! Enjoy intelligent nutrition guidance, effortless food logging, and personalized recipe creation.

**Remember:** The AI features work best with:
- ✅ Stable internet connection
- ✅ Valid API key configured
- ✅ Specific, clear inputs
- ✅ Reasonable expectations (AI is smart but not perfect!)

Happy tracking! 🍎💪📊
