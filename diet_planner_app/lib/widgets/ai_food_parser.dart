import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/huggingface_ai_service.dart';

/// AI-powered food input widget
/// Users can type natural language descriptions like "2 large eggs" or "a bowl of oatmeal"
class AIFoodParser extends StatefulWidget {
  final Function(FoodItem) onFoodParsed;

  const AIFoodParser({super.key, required this.onFoodParsed});

  @override
  State<AIFoodParser> createState() => _AIFoodParserState();
}

class _AIFoodParserState extends State<AIFoodParser> {
  final _controller = TextEditingController();
  final _aiService = HuggingFaceAIService.instance;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _parseFood() async {
    if (_controller.text.trim().isEmpty) return;

    if (!_aiService.isInitialized) {
      setState(() {
        _errorMessage =
            'AI service not initialized. Please set up your API key.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final foodItem = await _aiService.parseFoodDescription(
        _controller.text.trim(),
      );

      if (foodItem != null) {
        widget.onFoodParsed(foodItem);
        _controller.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ Added ${foodItem.name}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage =
              'Could not parse food description. Try being more specific.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF00B4D8).withValues(alpha: 0.1),
            const Color(0xFF90E0EF).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00B4D8).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B4D8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Food Parser',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Describe your food naturally',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Example chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildExampleChip('a large apple', Icons.apple),
              _buildExampleChip('2 scrambled eggs', Icons.egg),
              _buildExampleChip('bowl of oatmeal', Icons.breakfast_dining),
              _buildExampleChip('grilled chicken breast', Icons.set_meal),
            ],
          ),

          const SizedBox(height: 16),

          // Input field
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'e.g., "2 slices of whole wheat bread"',
              prefixIcon: const Icon(Icons.edit_rounded),
              suffixIcon: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.auto_fix_high_rounded),
                      onPressed: _parseFood,
                      tooltip: 'Parse with AI',
                    ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (_) => _parseFood(),
            enabled: !_isLoading,
          ),

          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Info text
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_rounded,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI will estimate nutrition values based on your description',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExampleChip(String text, IconData icon) {
    return InkWell(
      onTap: () {
        _controller.text = text;
        _parseFood();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF00B4D8)),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
