import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../services/ai_service.dart';
import '../services/huggingface_ai_service.dart';

final Logger _logger = Logger();

class AINutritionAdvisorScreen extends StatefulWidget {
  const AINutritionAdvisorScreen({super.key});

  @override
  State<AINutritionAdvisorScreen> createState() =>
      _AINutritionAdvisorScreenState();
}

class _AINutritionAdvisorScreenState extends State<AINutritionAdvisorScreen> {
  final _hfService = HuggingFaceAIService.instance;
  final _geminiService = AIService.instance;
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Show AI status in welcome message
    final aiStatus = _geminiService.isConfigured
        ? '🌐 Cloud AI Mode (Gemini)'
        : _hfService.isInitialized
        ? '🌐 Cloud AI Mode (Hugging Face)'
        : '💾 Local AI Mode (Offline)';

    _addMessage(
      'Hello! 👋 I\'m your AI nutrition advisor.\n\nStatus: $aiStatus\n\nAsk me anything about diet, nutrition, healthy eating, meal planning, or weight management!',
      isUser: false,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addMessage(String text, {required bool isUser}) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: isUser));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final question = _messageController.text.trim();
    _messageController.clear();

    _addMessage(question, isUser: true);

    // AI service now works with fallback mode - no initialization check needed
    setState(() => _isLoading = true);

    try {
      _logger.d('📤 Sending question to AI service...');
      _logger.d('Gemini configured: ${_geminiService.isConfigured}');

      String? response;
      if (_geminiService.isConfigured) {
        response = await _geminiService.getDietAdvice(question);
      }

      response ??= await _hfService.getNutritionAdvice(question);

      if (response != null && response.isNotEmpty) {
        _logger.d('✅ AI Response received (${response.length} chars)');
        _addMessage(response, isUser: false);
      } else {
        _logger.w('⚠️ AI returned null or empty response');
        _addMessage(
          'Sorry, I couldn\'t generate a response. Please try rephrasing your question or ask something else.',
          isUser: false,
        );
      }
    } catch (e) {
      // This should rarely happen now since service auto-falls back to local AI
      _logger.e('❌ Unexpected chat error: $e');
      _addMessage(
        'Sorry, there was an unexpected error. Please try again.',
        isUser: false,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.psychology_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('AI Nutrition Advisor'),
          ],
        ),
        backgroundColor: const Color(0xFF00B4D8),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Quick suggestion chips
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF90E0EF).withValues(alpha: 0.1),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickChip('How many calories should I eat?'),
                  _buildQuickChip('Best protein sources?'),
                  _buildQuickChip('Lose weight tips'),
                  _buildQuickChip('Pre-workout meal ideas'),
                  _buildQuickChip('Healthy snacks'),
                ],
              ),
            ),
          ),

          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_rounded,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ask me anything about nutrition!',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),

          // Loading indicator
          if (_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF00B4D8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI is thinking...',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),

          // Input field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask a nutrition question...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00B4D8), Color(0xFF90E0EF)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: _isLoading ? null : _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text),
        onPressed: () {
          _messageController.text = text;
          _sendMessage();
        },
        backgroundColor: Colors.white,
        side: BorderSide(color: const Color(0xFF00B4D8).withValues(alpha: 0.3)),
        labelStyle: const TextStyle(color: Color(0xFF00B4D8), fontSize: 13),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFF00B4D8)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: message.isUser ? const Radius.circular(4) : null,
            bottomLeft: !message.isUser ? const Radius.circular(4) : null,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser)
              Row(
                children: [
                  Icon(
                    Icons.psychology_rounded,
                    size: 16,
                    color: const Color(0xFF00B4D8),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'AI Advisor',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            if (!message.isUser) const SizedBox(height: 6),
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser})
    : timestamp = DateTime.now();
}
