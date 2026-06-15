import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/menu_item.dart';
import '../widgets/product_card.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<MenuItem> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    try {
      final rawList = await DatabaseHelper.instance.getFavorites();
      setState(() {
        _favorites = rawList.map((m) => MenuItem.fromMap(m)).toList();
      });
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50.withOpacity(0.5),
      appBar: AppBar(
        title: const Text('Menu Favoritmu'),
        backgroundColor: Colors.brown.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _favorites.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_outline, size: 64, color: Colors.brown.shade200),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada menu favorit.',
                        style: TextStyle(
                          color: Colors.brown.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tekan icon hati pada menu untuk menambahkan.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadFavorites,
                  color: Colors.brown,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.76,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final item = _favorites[index];
                      return ProductCard(
                        item: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(item: item),
                            ),
                          ).then((value) => _loadFavorites());
                        },
                        onFavoriteTap: () async {
                          await DatabaseHelper.instance.toggleFavorite(item.id!, item.isFavorite);
                          _loadFavorites();
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
