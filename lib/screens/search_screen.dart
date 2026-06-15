import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/menu_item.dart';
import '../widgets/product_card.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<MenuItem> _results = [];
  bool _isLoading = false;

  void _onSearchChanged() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      final raw = await DatabaseHelper.instance.getMenuItems(query: query);
      setState(() {
        _results = raw.map((m) => MenuItem.fromMap(m)).toList();
      });
    } catch (e) {
      debugPrint('Error searching menu: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50.withOpacity(0.5),
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Cari kopi, susu, matcha...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
        backgroundColor: Colors.brown.shade800,
        foregroundColor: Colors.white,
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _searchController.text.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 64, color: Colors.brown.shade200),
                      const SizedBox(height: 12),
                      const Text(
                        'Ketik nama sruputan kesukaanmu.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : _results.isEmpty
                  ? const Center(
                      child: Text(
                        'Menu tidak ditemukan. Coba ketik kata kunci lain.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.76,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final item = _results[index];
                        return ProductCard(
                          item: item,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(item: item),
                              ),
                            ).then((value) => _onSearchChanged());
                          },
                          onFavoriteTap: () async {
                            await DatabaseHelper.instance.toggleFavorite(item.id!, item.isFavorite);
                            _onSearchChanged();
                          },
                        );
                      },
                    ),
    );
  }
}
