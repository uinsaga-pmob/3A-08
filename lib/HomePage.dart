import 'package:flutter/material.dart';
import 'NonPopCoffee.dart';
import 'PopCoffe.dart';
import 'ProductPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // BOTTOM NAV
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFFC7BA9D),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(Icons.home, size: 28),
            Icon(Icons.favorite_border, size: 28),
            Icon(Icons.shopping_cart_outlined, size: 28),
            Icon(Icons.person_outline, size: 28),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xFFC7BA9D),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Grab",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Your Kopi Sruput",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 20),

                  // SEARCH BAR
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4DCC4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CATEGORY BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _categoryButton("Coffee", true),
                  const SizedBox(width: 10),
                  _categoryButton("Non Coffee", false),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // POPULAR COFFEE — FIXED
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Popular Coffee",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PopularCoffeePage(),
                        ),
                      );
                    },
                    child: const Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // PRODUCT LIST 1
            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                children: [
                  _productCard(
                    context: context,
                    img: "assets/images/coffee1.png",
                    name: "Kopi Sruput 1",
                    price: "6.000",
                  ),
                  _productCard(
                    context: context,
                    img: "assets/images/coffee2.png",
                    name: "Kopi Sruput 2",
                    price: "8.000",
                  ),
                  _productCard(
                    context: context,
                    img: "assets/images/coffee3.png",
                    name: "Kopi Sruput 3",
                    price: "10.000",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // POPULAR NON COFFEE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Popular Non Coffee",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PopularNonCoffeePage(),
                        ),
                      );
                    },
                    child: const Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // PRODUCT LIST 2
            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                children: [
                  _productCard(
                    context: context,
                    img: "assets/images/matcha1.png",
                    name: "Green Tea",
                    price: "6.000",
                  ),
                  _productCard(
                    context: context,
                    img: "assets/images/coklat1.png",
                    name: "Choco Latte",
                    price: "6.000",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CATEGORY BUTTON
  Widget _categoryButton(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFC7BA9D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC7BA9D)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: active ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // PRODUCT CARD
  Widget _productCard({
    required BuildContext context,
    required String img,
    required String name,
    required String price,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductPage(
              img: img,
              name: name,
              price: int.parse(price.replaceAll('.', '')),
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFE5D8C5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(img),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(price),
                ],
              ),
            ),

            // FAVORITE BUTTON
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.favorite_border,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),

            // ADD BUTTON
            Positioned(
              bottom: 12,
              right: 12,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.black,
                child: const Icon(Icons.add, size: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
