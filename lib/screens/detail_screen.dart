import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/database_helper.dart';
import '../models/menu_item.dart';
import '../widgets/image_placeholder.dart';

class DetailScreen extends StatefulWidget {
  final MenuItem item;
  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool _isFavorite;
  int _quantity = 1;
  String _tempOption = 'Ice'; // 'Ice' or 'Hot'
  String _sugarOption = 'Normal'; // 'Less', 'Normal', 'Extra'
  String _dineOption = 'Dine In'; // 'Dine In' or 'Take Away'

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.item.isFavorite;
  }

  void _toggleFavorite() async {
    await DatabaseHelper.instance.toggleFavorite(widget.item.id!, _isFavorite);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _addToCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      if (userId == null) {
        throw StateError('Pengguna belum masuk');
      }

      debugPrint('DetailScreen addToCart: user_id=$userId, menu_id=${widget.item.id}, quantity=$_quantity, temp=$_tempOption, sugar=$_sugarOption, dine=$_dineOption');
      final result = await DatabaseHelper.instance.addToCart({
        'user_id': userId,
        'menu_id': widget.item.id,
        'quantity': _quantity,
        'temp_option': _tempOption,
        'sugar_option': _sugarOption,
        'dine_option': _dineOption,
      });

      final cartItems = await DatabaseHelper.instance.getCartWithDetails(userId: userId);
      debugPrint('DetailScreen addToCart result: $result, cart items count: ${cartItems.length}, cartItems: $cartItems');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.item.name} berhasil ditambahkan ke keranjang!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Lihat',
              textColor: Colors.white,
              onPressed: () {
                // Return to shell, which switches to Cart tab
                Navigator.of(context).pop();
              },
            ),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan ke keranjang: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Kopi'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.brown.shade900,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.brown.shade900,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Pembayaran', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${(widget.item.price * _quantity).toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: ElevatedButton(
                  onPressed: _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Tambah ke Keranjang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Menu Hero Image
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AspectRatio(
                aspectRatio: 1.25,
                child: ImagePlaceholder(
                  imagePath: widget.item.imagePath,
                  borderRadius: 24,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.item.category,
                          style: TextStyle(
                            color: Colors.brown.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '4.8 (120+ Rating)',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.item.name,
                    style: TextStyle(
                      color: Colors.brown.shade900,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${widget.item.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  // Description
                  const SizedBox(height: 20),
                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      color: Colors.brown.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.description,
                    style: TextStyle(color: Colors.grey.shade600, height: 1.5),
                  ),

                  const Divider(height: 32),

                  // Selector Options (Suhu, Gula, Dine)
                  _buildOptionSection(
                    title: 'Pilihan Suhu Kup',
                    options: ['Ice', 'Hot'],
                    selectedValue: _tempOption,
                    onSelected: (val) => setState(() => _tempOption = val),
                  ),
                  const SizedBox(height: 16),
                  _buildOptionSection(
                    title: 'Kadar Gula',
                    options: ['Less', 'Normal', 'Extra'],
                    selectedValue: _sugarOption,
                    onSelected: (val) => setState(() => _sugarOption = val),
                  ),
                  const SizedBox(height: 16),
                  _buildOptionSection(
                    title: 'Metode Pengantaran',
                    options: ['Dine In', 'Take Away'],
                    selectedValue: _dineOption,
                    onSelected: (val) => setState(() => _dineOption = val),
                  ),

                  const Divider(height: 32),

                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jumlah Sruputan',
                        style: TextStyle(
                          color: Colors.brown.shade900,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          _buildQtyButton(Icons.remove, () {
                            if (_quantity > 1) {
                              setState(() => _quantity--);
                            }
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              _quantity.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildQtyButton(Icons.add, () {
                            setState(() => _quantity++);
                          }),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionSection({
    required String title,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: options.map((opt) {
            final isSel = opt == selectedValue;
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                onTap: () => onSelected(opt),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSel ? Colors.brown.shade800 : Colors.brown.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSel ? Colors.brown.shade800 : Colors.brown.shade200,
                    ),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      color: isSel ? Colors.white : Colors.brown.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.brown.shade200),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.brown.shade800, size: 18),
        onPressed: onTap,
      ),
    );
  }
}
