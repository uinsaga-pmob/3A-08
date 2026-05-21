import 'package:flutter/material.dart';
import 'HomePage.dart';

class SuccessPaymentPage extends StatelessWidget {
  const SuccessPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC7BA9D),
      body: Column(
        children: [
          const SizedBox(height: 80),

          const Text(
            "Thanks broo",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),

          const Spacer(),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle, size: 90, color: Colors.black),

                const SizedBox(height: 16),

                const Text(
                  "Thank You For Purchasing",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 6),

                const Text(
                  "Pesananmu akan segera diantar",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 28),

                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) => false,
                    );
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7BA9D),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
