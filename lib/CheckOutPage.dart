import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'SuccesPaymentPage.dart';

class CheckoutPage extends StatefulWidget {
  final String name;
  final int price;
  final int quantity;
  final String img;

  const CheckoutPage({
    super.key,
    required this.name,
    required this.price,
    required this.quantity,
    required this.img,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController tableController = TextEditingController();
  String selectedPayment = "Cash";

  String formatRupiah(int value) {
    final f = NumberFormat('#,###', 'en_US');
    return f.format(value).replaceAll(",", ".");
  }

  @override
  Widget build(BuildContext context) {
    int total = widget.price * widget.quantity;

    return Scaffold(
      backgroundColor: Colors.white,

      // ======================
      //  FIX: TOTAL DI BAWAH
      // ======================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: const BoxDecoration(
          color: Color(0xFFD9CFB6),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  "Total Pembayaran",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const Spacer(),
                Text(
                  formatRupiah(total),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            GestureDetector(
              onTap: () {
                if (tableController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Nomer meja tidak boleh kosong."),
                    ),
                  );
                  return;
                }

                print("Order success: meja ${tableController.text}");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuccessPaymentPage(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 90,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8B89D),
                  borderRadius: BorderRadius.circular(18),
                ),

                child: const Text(
                  "Order Now",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),

      // ======================
      //  KONTEN UTAMA
      // ======================
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              "Grab",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Your ${widget.name}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 25),

            buildOrderCard(
              widget.img,
              widget.name,
              "Good Day Moccacino",
              widget.price,
              widget.quantity,
            ),

            const SizedBox(height: 25),

            // NOMER MEJA
            const Text(
              "Nomer Meja",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: tableController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Masukkan nomor meja apa saja",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Payment Method",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            paymentButton(Icons.payments, "Cash"),
            const SizedBox(height: 12),
            paymentButton(Icons.qr_code, "Qris"),

            const SizedBox(height: 120), // supaya tidak tertutup card bawah
          ],
        ),
      ),
    );
  }

  Widget buildOrderCard(
    String img,
    String name,
    String subtitle,
    int price,
    int qty,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD9CFB6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(img, width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                formatRupiah(price),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.circle, size: 8),
              const SizedBox(width: 6),
              Text(
                "$qty",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget paymentButton(IconData icon, String label) {
    final bool active = selectedPayment == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black),
          color: active ? const Color(0xFFD9CFB6) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
