import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import 'checkout_screen.dart';
import '../widgets/image_placeholder.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartWithDetails = [];
  bool _isLoading = true;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() async {
    setState(() => _isLoading = true);
    try {
      final list = await DatabaseHelper.instance.getCartWithDetails();
      double total = 0.0;
      for (var item in list) {
        final double price = (item['price'] as num).toDouble();
        final int qty = item['quantity'] as int;
        total += price * qty;
      }

      setState(() {
        _cartWithDetails = list;
        _totalPrice = total;
      });
    } catch (e) {
      debugPrint('Error loading cart: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateQty(int cartId, int currentQty, int delta) async {
    final newQty = currentQty + delta;
    await DatabaseHelper.instance.updateCartQuantity(cartId, newQty);
    _loadCart();
  }

  void _clearCart() async {
    await DatabaseHelper.instance.clearCart();
    _loadCart();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang dikosongkan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50.withOpacity(0.5),
      appBar: AppBar(
        title: const Text('Keranjang Sruput'),
        backgroundColor: Colors.brown.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: _cartWithDetails.isNotEmpty
            ? [
                TextButton(
                  onPressed: _clearCart,
                  child: const Text('Kosongkan', style: TextStyle(color: Colors.white)),
                )
              ]
            : null,
      ),
      bottomNavigationBar: _cartWithDetails.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Sruputan', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        Text(
                          'Rp ${_totalPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.amber.shade900,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutScreen(totalAmount: _totalPrice),
                            ),
                          ).then((value) => _loadCart());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown.shade800,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Lanjut ke Pembayaran',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : _cartWithDetails.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 72, color: Colors.brown.shade200),
                      const SizedBox(height: 16),
                      Text(
                        'Keranjangmu masih kosong!',
                        style: TextStyle(
                          color: Colors.brown.shade800,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ayo pilih kopi sruputan instan nikmat\ndan hemat di Beranda.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _cartWithDetails.length,
                  itemBuilder: (context, index) {
                    final item = _cartWithDetails[index];
                    final double price = (item['price'] as num).toDouble();
                    final int qty = item['quantity'] as int;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: ImagePlaceholder(
                                imagePath: item['image_path'] as String?,
                                borderRadius: 12,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item['temp_option']} • Gula: ${item['sugar_option']} • ${item['dine_option']}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Rp ${(price * qty).toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: Colors.amber.shade900,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                  onPressed: () => _updateQty(item['id'] as int, qty, -qty),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      icon: const Icon(Icons.remove_circle_outline, size: 22),
                                      onPressed: () => _updateQty(item['id'] as int, qty, -1),
                                    ),
                                    Text(
                                      qty.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      icon: const Icon(Icons.add_circle_outline, size: 22),
                                      onPressed: () => _updateQty(item['id'] as int, qty, 1),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
