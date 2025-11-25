import 'package:flutter/material.dart';

import '../models/food_item.dart';
import '../services/barcode_scanner_service.dart';
import '../services/food_database_service.dart';
import '../services/huggingface_ai_service.dart';
import '../widgets/food_search.dart';
import '../widgets/ai_food_parser.dart';

class LogFoodScreen extends StatefulWidget {
  final void Function(FoodItem) onAdd;

  const LogFoodScreen({super.key, required this.onAdd});

  @override
  State<LogFoodScreen> createState() => _LogFoodScreenState();
}

class _LogFoodScreenState extends State<LogFoodScreen> {
  final _scanner = BarcodeScannerService();
  final _db = FoodDatabaseService.instance;
  bool _scanning = false;

  Future<void> _scanAndLookup() async {
    // Check if scanning is supported, offer manual entry on web
    if (!_scanner.isSupported()) {
      _showManualBarcodeEntry();
      return;
    }

    setState(() => _scanning = true);
    final code = await _scanner.scanBarcode();
    setState(() => _scanning = false);

    if (code == null) {
      if (!mounted) return;
      // Offer manual entry as fallback
      final retry = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Scan Cancelled'),
          content: const Text('Would you like to enter the barcode manually?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Enter Manually'),
            ),
          ],
        ),
      );

      if (retry == true) {
        _showManualBarcodeEntry();
      }
      return;
    }

    await _lookupAndShowProduct(code);
  }

  Future<void> _showManualBarcodeEntry() async {
    final controller = TextEditingController();
    final barcode = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Barcode'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Barcode Number',
            hintText: 'e.g., 3017620422003',
            prefixIcon: Icon(Icons.qr_code),
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Lookup'),
          ),
        ],
      ),
    );

    if (barcode != null && barcode.isNotEmpty) {
      await _lookupAndShowProduct(barcode);
    }
  }

  Future<void> _lookupAndShowProduct(String code) async {
    if (!mounted) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Looking up product...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Lookup remote
    final item = await _db.fetchFoodByBarcode(code);

    if (!mounted) return;
    Navigator.pop(context); // Close loading dialog

    if (item == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No product found for barcode: $code'),
          backgroundColor: Colors.orange,
          action: SnackBarAction(
            label: 'Try Again',
            onPressed: _showManualBarcodeEntry,
          ),
        ),
      );
      return;
    }

    // Show beautiful preview dialog
    final added = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF00B4D8).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF00B4D8),
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Product Found!', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B4D8).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildNutritionRow(
                      'Calories',
                      '${item.calories.toStringAsFixed(0)} kcal',
                      Icons.local_fire_department,
                      Colors.orange,
                    ),
                    const Divider(height: 16),
                    _buildNutritionRow(
                      'Serving Size',
                      '${item.servingSizeGrams.toStringAsFixed(0)}g',
                      Icons.scale,
                      Colors.blue,
                    ),
                    const Divider(height: 16),
                    _buildNutritionRow(
                      'Protein',
                      '${item.protein.toStringAsFixed(1)}g',
                      Icons.egg_alt,
                      const Color(0xFFEF476F),
                    ),
                    const Divider(height: 16),
                    _buildNutritionRow(
                      'Carbs',
                      '${item.carbs.toStringAsFixed(1)}g',
                      Icons.bakery_dining,
                      const Color(0xFFFFB703),
                    ),
                    const Divider(height: 16),
                    _buildNutritionRow(
                      'Fat',
                      '${item.fat.toStringAsFixed(1)}g',
                      Icons.water_drop,
                      const Color(0xFF06D6A0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Barcode: $code',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.add),
            label: const Text('Add to Log'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );

    if (added == true) {
      if (!mounted) return;
      final now = DateTime.now();
      _db.logFood(now, item);
      widget.onAdd(item);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Added ${item.name}')),
            ],
          ),
          backgroundColor: const Color(0xFF06D6A0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Widget _buildNutritionRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<void> _showAddCustomDialog() async {
    final nameCtrl = TextEditingController();
    final caloriesCtrl = TextEditingController();
    final proteinCtrl = TextEditingController();
    final carbsCtrl = TextEditingController();
    final fatCtrl = TextEditingController();
    final servingCtrl = TextEditingController(text: '100');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Food'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: caloriesCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Calories'),
              ),
              TextField(
                controller: proteinCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Protein (g)'),
              ),
              TextField(
                controller: carbsCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Carbs (g)'),
              ),
              TextField(
                controller: fatCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Fat (g)'),
              ),
              TextField(
                controller: servingCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Serving size (g)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != true) return;

    final name = nameCtrl.text.trim();
    final calories = double.tryParse(caloriesCtrl.text) ?? 0.0;
    final protein = double.tryParse(proteinCtrl.text) ?? 0.0;
    final carbs = double.tryParse(carbsCtrl.text) ?? 0.0;
    final fat = double.tryParse(fatCtrl.text) ?? 0.0;
    final serving = double.tryParse(servingCtrl.text) ?? 100.0;

    if (name.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a name')));
      return;
    }

    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final item = FoodItem(
      id: id,
      name: name,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      servingSizeGrams: serving,
    );
    final now = DateTime.now();
    _db.logFood(now, item);
    if (!mounted) return;
    widget.onAdd(item);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Added $name')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: const Text('Log Food'),
              pinned: true,
              expandedHeight: 140,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF00B4D8), Color(0xFF90E0EF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(painter: _CirclePainter()),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Log Your Food 🍽️',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Scan, search, or add manually',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                  ),
                                  icon: _scanning
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                              Colors.white,
                                            ),
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.qr_code_scanner_rounded,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                  onPressed: _scanning ? null : _scanAndLookup,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // AI Food Parser
                    if (HuggingFaceAIService.instance.isInitialized)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: AIFoodParser(
                          onFoodParsed: (food) {
                            final now = DateTime.now();
                            _db.logFood(now, food);
                            widget.onAdd(food);
                          },
                        ),
                      ),
                    // Regular Food Search
                    FoodSearch(onAdd: widget.onAdd),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCustomDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Custom Food'),
      ),
    );
  }
}

// Decorative circle painter for header background
class _CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Draw decorative circles
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 60, paint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.6), 40, paint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.8), 30, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
