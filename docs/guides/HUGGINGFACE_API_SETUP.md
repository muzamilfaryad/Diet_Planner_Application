# 🚀 Hugging Face AI API Setup Guide

## ✅ Why Hugging Face?

Your app now uses **Hugging Face Inference API** - a completely **FREE** AI service with:
- ✨ **No payment information required**
- 🚀 **1,000 requests per hour** (free tier)
- 🔓 **No credit card needed**
- 🎯 **Multiple AI models available**
- 💯 **Generous free limits**

---

## 📝 Setup Steps (Takes 2 minutes!)

### Step 1: Create Free Hugging Face Account

1. Go to: **https://huggingface.co/join**
2. Sign up with your email (completely free, no payment info)
3. Verify your email

### Step 2: Generate Your Free API Key

1. Go to: **https://huggingface.co/settings/tokens**
2. Click **"New token"** button
3. Give it a name (e.g., "Diet Planner App")
4. Select **"Read"** role (this is all you need)
5. Click **"Create"**
6. **Copy your token** (starts with `hf_...`)

### Step 3: Add API Key to Your App

1. Open file: `diet_planner_app/lib/config/ai_config.dart`
2. Find this line:
   ```dart
   static const String hfApiKey = 'YOUR_HF_API_KEY_HERE';
   ```
3. Replace `'YOUR_HF_API_KEY_HERE'` with your actual token:
   ```dart
   static const String hfApiKey = 'hf_xxxxxxxxxxxxxxxxxxxxxxxxx';
   ```
4. **Save the file**

### Step 4: Run Your App

```bash
cd diet_planner_app
flutter run
```

---

## 🎉 That's It!

Your AI features will now work:
- 🍎 **AI Food Parser** - Describe food naturally ("2 large apples")
- 🍳 **Recipe Generator** - Create recipes from ingredients
- 📊 **Meal Planner** - AI-powered meal planning
- 💬 **Nutrition Advisor** - Ask nutrition questions
- 🎯 **Meal Analysis** - Get AI insights on your meals

---

## 🔧 Troubleshooting

### "Model is loading" message?
- **First request** takes 5-10 seconds (model needs to load)
- Subsequent requests are fast
- The app automatically retries for you

### API key not working?
- Make sure it starts with `hf_`
- Copy the FULL token (they're long!)
- Check you selected "Read" role when creating
- Make sure you saved the `ai_config.dart` file

### Need more requests?
- Free tier: 1,000 requests/hour (very generous!)
- If you need more, upgrade is cheap (~$9/month for 100k requests)

---

## 🎨 Alternative Free Models

You can switch to other free models by changing in `ai_config.dart`:

```dart
// Fast and accurate (default)
static const String hfModel = 'mistralai/Mistral-7B-Instruct-v0.2';

// Facebook's Llama 2 (also great)
static const String hfModel = 'meta-llama/Llama-2-7b-chat-hf';

// Google's T5 (great for Q&A)
static const String hfModel = 'google/flan-t5-xxl';

// More powerful but slower
static const String hfModel = 'mistralai/Mixtral-8x7B-Instruct-v0.1';
```

---

## 📚 Resources

- **Hugging Face Website**: https://huggingface.co
- **Get API Token**: https://huggingface.co/settings/tokens
- **Browse Models**: https://huggingface.co/models
- **API Documentation**: https://huggingface.co/docs/api-inference/

---

## 🔒 Security Note

**NEVER commit your API key to Git!**

For production, use:
- Environment variables
- Flutter secure storage
- CI/CD secrets
- Backend proxy

---

## 💡 Benefits Over Previous API

| Feature | Groq | Hugging Face |
|---------|------|--------------|
| **Cost** | Free credits expire | Always free |
| **Payment** | May require card | Never needed |
| **Rate Limit** | 30/minute | 1,000/hour |
| **Setup Time** | Complex | 2 minutes |
| **Models** | Limited | 100+ options |

---

Need help? The app now shows clear error messages with guidance!
