import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/menu_item.dart';
import '../widgets/product_card.dart';
import 'detail_screen.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({super.key});

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  List<MenuItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    try {
      final list = await DatabaseHelper.instance.getMenuItems();
      setState(() {
        _items = list.map((m) => MenuItem.fromMap(m)).toList();
      });
    } catch (e) {
      debugPrint('Error loading see all: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50.withOpacity(0.5),
      appBar: AppBar(
        title: const Text('Semua Menu Sruputan'),
        backgroundColor: Colors.brown.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : RefreshIndicator(
              onRefresh: _loadAll,
              color: Colors.brown,
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.76,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ProductCard(
                    item: item,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(item: item),
                        ),
                      ).then((value) => _loadAll());
                    },
                    onFavoriteTap: () async {
                      await DatabaseHelper.instance.toggleFavorite(item.id!, item.isFavorite);
                      _loadAll();
                    },
                  );
                },
              ),
            ),
    );
  }
}
