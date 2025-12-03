import 'package:flutter/material.dart';
import 'SuccesPaymentPage.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          const SizedBox(height: 20),

          const Text(
            "Cart",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          _cartItem(
            img: "assets/images/coffee1.png",
            title: "Kopi Sruput",
            subtitle: "Good Day Mocacino",
            price: "6.000",
          ),

          _cartItem(
            img: "assets/images/matcha1.png",
            title: "Sruput",
            subtitle: "Chocolatos Matcha",
            price: "6.000",
          ),

          const Spacer(),

          _bottomCheckoutBar(context),
        ],
      ),
    );
  }

  Widget _bottomCheckoutBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xFFC7BA9D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Items (2)", style: TextStyle(fontSize: 14)),
              Text("Total 12.000",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),

          const SizedBox(height: 14),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SuccessPaymentPage()),
              );
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE4DCC4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  "Checkout",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _cartItem({
    required String img,
    required String title,
    required String subtitle,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.circle_outlined, size: 22),

          const SizedBox(width: 12),

          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(price,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Row(
            children: const [
              Icon(Icons.timer_outlined, size: 20),
              SizedBox(width: 4),
              Text("2"),
            ],
          )
        ],
      ),
    );
  }
}
