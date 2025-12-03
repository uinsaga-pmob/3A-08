import 'package:flutter/material.dart';

class PopularCoffeePage extends StatelessWidget {
  const PopularCoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    "Popular Coffee",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // biar title tetap center
                ],
              ),
            ),

            const SizedBox(height: 10),

            // GRID PRODUK
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: coffeeItems.length,
                itemBuilder: (context, index) {
                  final item = coffeeItems[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7BA9D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // IMAGE
                          Center(
                            child: Image.asset(
                              item["image"],
                              height: 110,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // TITLE
                          Text(
                            item["title"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            item["subtitle"],
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),

                          const Spacer(),

                          // PRICE + ICON
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item["price"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(Icons.add_circle_outline),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// DATA DUMMY
List<Map<String, dynamic>> coffeeItems = [
  {
    "image": "assets/images/kopi1.png",
    "title": "Kopi Sruput",
    "subtitle": "Good Day Mocacinno",
    "price": "6.000"
  },
  {
    "image": "assets/images/kopi2.png",
    "title": "Kopi Sruput",
    "subtitle": "Nescafe Classic",
    "price": "6.000"
  },
  {
    "image": "assets/images/kopi3.png",
    "title": "Kopi Sruput",
    "subtitle": "ABC Kopi Susu",
    "price": "6.000"
  },
  {
    "image": "assets/images/kopi4.png",
    "title": "Kopi Sruput",
    "subtitle": "Good Day Mocaflo",
    "price": "6.000"
  },
];
