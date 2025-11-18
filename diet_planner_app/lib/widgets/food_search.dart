import 'package:flutter/material.dart';

import '../models/food_item.dart';
import '../services/enhanced_api_service.dart';
import '../services/api_config.dart';
import '../services/food_database_service.dart';

class FoodSearch extends StatefulWidget {
  final void Function(FoodItem) onAdd;

  const FoodSearch({super.key, required this.onAdd});

  @override
  State<FoodSearch> createState() => _FoodSearchState();
}

class _FoodSearchState extends State<FoodSearch> {
  final _api = EnhancedApiService.instance;
  final _db = FoodDatabaseService.instance;
  final _controller = TextEditingController();
  List<FoodItem> _results = [];
  bool _loading = false;
  String? _apiSource;

  Future<void> _search(String q) async {
    setState(() {
      _loading = true;
      _results = [];
      _apiSource = null;
    });

    try {
      // Use smart search that tries multiple APIs
      final res = await _api.smartFoodSearch(
        q,
        calorieNinjasKey: ApiConfig.calorieNinjasApiKey,
      );

      setState(() {
        _results = res;
        _loading = false;
        if (res.isNotEmpty) {
          // Detect which API was used based on ID prefix
          if (res.first.id.startsWith('off_')) {
            _apiSource = 'OpenFoodFacts';
          } else if (res.first.id.startsWith('cn_')) {
            _apiSource = 'CalorieNinjas';
          }
        }
      });
    } catch (e) {
      setState(() {
        _results = [];
        _loading = false;
        _apiSource = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Info banner for web users
        if (_results.isEmpty && !_loading && _controller.text.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF00B4D8).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF00B4D8).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF00B4D8),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Search 2.8M+ foods from OpenFoodFacts database',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Search foods...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  onSubmitted: _search,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _results.clear());
                        },
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: () => _search(_controller.text),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Search'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_apiSource != null &&
            ApiConfig.showApiSource &&
            _results.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 14,
                  color: const Color(0xFF06D6A0),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Found ${_results.length} matching items from $_apiSource',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _results.isEmpty
              ? _controller.text.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No foods found',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _results.length,
                  itemBuilder: (context, i) {
                    final f = _results[i];
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 200 + (i * 50)),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          f.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          '${f.calories.toStringAsFixed(0)} kcal · ${f.servingSizeGrams.toStringAsFixed(0)}g\n'
                          'P: ${f.protein}g · C: ${f.carbs}g · F: ${f.fat}g',
                        ),
                        trailing: IconButton.filledTonal(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            final loggedAt = DateTime.now();
                            _db.logFood(loggedAt, f);
                            // Notify parent to refresh UI
                            widget.onAdd(f);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added ${f.name}'),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () {
                                    final removed = _db.removeLoggedFood(
                                      loggedAt,
                                      f,
                                    );
                                    if (removed) {
                                      // Notify parent to refresh UI after undo
                                      widget.onAdd(f);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Removed ${f.name}'),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Unable to undo'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
