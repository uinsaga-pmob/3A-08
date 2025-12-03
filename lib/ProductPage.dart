import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'CheckOutPage.dart';

class ProductPage extends StatefulWidget {
  final String img;
  final String name;
  final int price;

  const ProductPage({
    super.key,
    required this.img,
    required this.name,
    required this.price,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 2;

  String availableIn = "Ice";
  String sugar = "Less";
  String serve = "Dine In";

  String formatRupiah(int value) {
    final f = NumberFormat('#,###', 'en_US');
    return f.format(value).replaceAll(",", ".");
  }

  @override
  Widget build(BuildContext context) {
    int total = widget.price * quantity;

    return Scaffold(
      backgroundColor: const Color(0xFFD4C7B4),
      body: Stack(
        children: [
          // BACK BUTTON
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 26),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // CART BUTTON
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, size: 26),
              onPressed: () {},
            ),
          ),

          // PRODUCT IMAGE (ATAS)
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 240,
                child: Image.asset(widget.img, fit: BoxFit.contain),
              ),
            ),
          ),

          // WHITE CONTENT AREA
          Positioned(
            top: 330,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
              ),
              child: ListView(
                children: [
                  // BEIGE CARD
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9CFB6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Good Day Moccacino",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.favorite_border, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              formatRupiah(widget.price),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // OVERLAP FIX (MENAIKKAN CARD TANPA MARGIN MINUS)
                      Positioned(
                        top: -40,
                        left: 0,
                        right: 0,
                        child: SizedBox(height: 0),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  buildSection("Available in"),
                  Row(
                    children: [
                      buildPill("Ice", availableIn),
                      const SizedBox(width: 10),
                      buildPill("Hot", availableIn),
                    ],
                  ),

                  const SizedBox(height: 20),

                  buildSection("Sugar"),
                  Row(
                    children: [
                      buildPill("Less", sugar),
                      const SizedBox(width: 10),
                      buildPill("Normal", sugar),
                      const SizedBox(width: 10),
                      buildPill("Extra", sugar),
                    ],
                  ),

                  const SizedBox(height: 20),

                  buildSection("Available in"),
                  Row(
                    children: [
                      buildPill("Dine In", serve),
                      const SizedBox(width: 10),
                      buildPill("Take Away", serve),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // TOTAL
                  Row(
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        formatRupiah(total),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      // MINUS
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                          ),
                          child: const Icon(Icons.remove),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        "$quantity",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // PLUS
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),

                      const Spacer(),

                      // ORDER NOW BUTTON (FIX)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutPage(
                                name: widget.name,
                                price: widget.price,
                                quantity: quantity,
                                img: widget.img,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9CFB6),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Text(
                            "Order Now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====== WIDGET: SECTION TITLE ======
  Widget buildSection(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // ====== WIDGET: PILL BUTTON ======
  Widget buildPill(String label, String selected) {
    bool isSelected = label == selected;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (label == "Ice" || label == "Hot") {
            availableIn = label;
          } else if (label == "Less" || label == "Normal" || label == "Extra") {
            sugar = label;
          } else if (label == "Dine In" || label == "Take Away") {
            serve = label;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.black : Colors.black54),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
