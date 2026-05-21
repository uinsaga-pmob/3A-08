import 'package:flutter/material.dart';

class PopularNonCoffeePage extends StatelessWidget {
  const PopularNonCoffeePage({super.key});

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
                    "Popular Non Coffee",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
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
                itemCount: nonCoffeeItems.length,
                itemBuilder: (context, index) {
                  final item = nonCoffeeItems[index];

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
                          Center(
                            child: Image.asset(item["image"], height: 110),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            item["title"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          Text(
                            item["subtitle"],
                            style: const TextStyle(fontSize: 12),
                          ),

                          const Spacer(),

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
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> nonCoffeeItems = [
  {
    "image": "assets/images/esteh.png",
    "title": "Sruput",
    "subtitle": "Es Teh",
    "price": "6.000",
  },
  {
    "image": "assets/images/coklat1.png",
    "title": "Sruput",
    "subtitle": "Chocolatos",
    "price": "6.000",
  },
  {
    "image": "assets/images/matcha1.png",
    "title": "Sruput",
    "subtitle": "Matcha",
    "price": "6.000",
  },
  {
    "image": "assets/images/nutrisari.png",
    "title": "Sruput",
    "subtitle": "Nutrisari",
    "price": "6.000",
  },
];
