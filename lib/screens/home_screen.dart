import 'dart:convert'; // ← TAMBAH
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/database_helper.dart';
import '../models/menu_item.dart';
import '../widgets/product_card.dart';
import 'detail_screen.dart';
import 'search_screen.dart';
import 'see_all_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _displayName = 'Sruputer';
  String? _photoBase64; // ← TAMBAH
  String _selectedCategory = 'Semua';
  List<MenuItem> _menuItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadMenu();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    final userId = prefs.getInt('user_id');

    if (name != null && name.isNotEmpty) {
      setState(() => _displayName = name);
    }

    // ← TAMBAH: ambil foto dari DB
    if (userId != null) {
      final user = await DatabaseHelper.instance.getUser(userId);
      if (user != null && mounted) {
        setState(() => _photoBase64 = user['photo']);
      }
    }
  }

  Future<void> _loadMenu() async {
    setState(() => _isLoading = true);
    try {
      final categoryFilter =
          _selectedCategory == 'Semua' ? null : _selectedCategory;
      final rawList =
          await DatabaseHelper.instance.getMenuItems(category: categoryFilter);
      setState(() {
        _menuItems = rawList.map((m) => MenuItem.fromMap(m)).toList();
      });
    } catch (e) {
      debugPrint('Error loading menu: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  // ← TAMBAH: widget avatar kecil untuk header
  Widget _buildHeaderAvatar() {
    final hasPhoto = _photoBase64 != null && _photoBase64!.isNotEmpty;
    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.brown.shade200,
      backgroundImage:
          hasPhoto ? MemoryImage(base64Decode(_photoBase64!)) : null,
      child: !hasPhoto
          ? Text(
              _displayName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50.withOpacity(0.5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadMenu,
          color: Colors.brown,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── Header ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    // ← GANTI Column → Row
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Greeting + Nama (kiri)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _displayName,
                              style: TextStyle(
                                color: Colors.brown.shade900,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Avatar (kanan)
                      _buildHeaderAvatar(),
                    ],
                  ),
                ),
              ),

              // Search Bar Hero Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.brown.shade800, Colors.brown.shade900],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Promo Sruput Spesial!',
                          style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Beli 3 Bayar 2 Kopi Instan Sruputan',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const SearchScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey),
                                SizedBox(width: 12),
                                Text(
                                  'Cari kopi andalanmu di sini...',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Category Selector
              SliverToBoxAdapter(
                child: Container(
                  height: 45,
                  margin: const EdgeInsets.symmetric(vertical: 12.0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: ['Semua', 'Coffee', 'Non Coffee'].map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: ChoiceChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.brown.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: Colors.brown.shade800,
                          backgroundColor: Colors.white,
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.brown.shade200,
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedCategory = category);
                              _loadMenu();
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pilihan Menu Terbaik',
                        style: TextStyle(
                            color: Colors.brown.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SeeAllScreen()),
                          ).then((value) => _loadMenu());
                        },
                        child: Text(
                          'Lihat Semua',
                          style: TextStyle(
                              color: Colors.amber.shade900,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // Grid of items
              _isLoading
                  ? const SliverFillRemaining(
                      child: Center(
                          child:
                              CircularProgressIndicator(color: Colors.brown)),
                    )
                  : _menuItems.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.coffee,
                                    size: 64, color: Colors.brown.shade200),
                                const SizedBox(height: 12),
                                const Text('Belum ada menu di kategori ini.',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.76,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = _menuItems[index];
                                return ProductCard(
                                  item: item,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              DetailScreen(item: item)),
                                    ).then((value) => _loadMenu());
                                  },
                                  onFavoriteTap: () async {
                                    await DatabaseHelper.instance
                                        .toggleFavorite(
                                            item.id!, item.isFavorite);
                                    _loadMenu();
                                  },
                                );
                              },
                              childCount: _menuItems.length,
                            ),
                          ),
                        ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
