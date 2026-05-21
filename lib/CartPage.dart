import 'package:flutter/material.dart';
import 'CartModel.dart';
import 'CheckOutPage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String rupiah(int v) => v.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomBar(context),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "Cart",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: CartData.items.isEmpty
                ? const Center(child: Text("Cart masih kosong"))
                : ListView.builder(
                    itemCount: CartData.items.length,
                    itemBuilder: (context, index) {
                      final item = CartData.items[index];
                      return _item(index, item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Color(0xFFC7BA9D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Items (${CartData.totalItems})"),
              Text(
                "Total ${rupiah(CartData.totalPrice)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              if (CartData.items.isEmpty) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CheckoutPage(items: List.from(CartData.items), name: ''),
                ),
              );
            },
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE4DCC4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                "Checkout",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(int index, CartItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Image.asset(item.img, width: 55, height: 55, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(rupiah(item.price * item.quantity)),
              ],
            ),
          ),
          Text("x${item.quantity}"),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                CartData.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }
}
