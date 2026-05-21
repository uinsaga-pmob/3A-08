import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'CartModel.dart';
import 'SuccesPaymentPage.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> items;

  const CheckoutPage({super.key, required this.items, required String name});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController tableController = TextEditingController();
  String selectedPayment = "Cash";

  String rupiah(int v) {
    final f = NumberFormat('#,###', 'en_US');
    return f.format(v).replaceAll(",", ".");
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.items.fold(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );

    return Scaffold(
      backgroundColor: Colors.white,

      // ===== BOTTOM TOTAL =====
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(18),
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
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  rupiah(total),
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
                      content: Text("Nomor meja tidak boleh kosong"),
                    ),
                  );
                  return;
                }

                CartData.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SuccessPaymentPage()),
                );
              },
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8B89D),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  "Order Now",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),

      // ===== CONTENT =====
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Checkout",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // ===== ORDER LIST =====
          ...widget.items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD9CFB6),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item.img,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rupiah(item.price),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "x${item.quantity}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),

          // ===== TABLE NUMBER =====
          const Text(
            "Nomor Meja",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              controller: tableController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Masukkan nomor meja",
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ===== PAYMENT =====
          const Text(
            "Payment Method",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          paymentButton(Icons.payments, "Cash"),
          const SizedBox(height: 12),
          paymentButton(Icons.qr_code, "QRIS"),

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget paymentButton(IconData icon, String label) {
    final active = selectedPayment == label;

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
          children: [Icon(icon), const SizedBox(width: 12), Text(label)],
        ),
      ),
    );
  }
}
