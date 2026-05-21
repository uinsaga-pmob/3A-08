<<<<<<< HEAD
import 'dart:io';

import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'add_product_page.dart';
import 'edit_product_page.dart';

=======
import 'package:flutter/material.dart';
import 'FavoritPage.dart';
import 'FavoriteModel.dart';
import 'NonPopCoffee.dart';
import 'PopCoffe.dart';
import 'ProductPage.dart';

>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
<<<<<<< HEAD
  List<Map<String, dynamic>> products = [];

  // ======================
  // LOAD PRODUCTS
  // ======================
  Future loadProducts() async {
    final data = await DatabaseHelper.instance.getProducts();

    setState(() {
      products = data;
    });
  }
=======
  final TextEditingController searchController = TextEditingController();

  // LIST FAVORIT GLOBAL DI HOMEPAGE
  List<Map<String, dynamic>> favorites = [];

  // ================================
  // LIST PRODUK (SUMBER SEARCH)
  // ================================
  final List<Map<String, dynamic>> allProducts = [
    {
      "img": "assets/images/coffee1.png",
      "name": "Kopi Sruput 1",
      "price": "6000",
    },
    {
      "img": "assets/images/coffee2.png",
      "name": "Kopi Sruput 2",
      "price": "8000",
    },
    {
      "img": "assets/images/coffee3.png",
      "name": "Kopi Sruput 3",
      "price": "10000",
    },
    {"img": "assets/images/matcha1.png", "name": "Green Tea", "price": "6000"},
    {
      "img": "assets/images/coklat1.png",
      "name": "Choco Latte",
      "price": "6000",
    },
  ];

  List<Map<String, dynamic>> filteredProducts = [];
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD

    loadProducts();
  }

  // ======================
  // DELETE PRODUCT
  // ======================
  Future deleteProduct(int id) async {
    await DatabaseHelper.instance.deleteProduct(id);

    loadProducts();
=======
    filteredProducts = List.from(allProducts);

    searchController.addListener(() {
      filterSearch(searchController.text);
    });
  }

  void filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = List.from(allProducts);
      } else {
        filteredProducts = allProducts
            .where(
              (item) =>
                  item["name"].toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

<<<<<<< HEAD
      // ======================
      // BOTTOM NAVIGATION
      // ======================
=======
      // =========================
      // BOTTOM NAVIGATION BAR
      // =========================
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
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

        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
<<<<<<< HEAD

          children: [
            Icon(Icons.home, size: 28),

            Icon(Icons.favorite_border, size: 28),

            Icon(Icons.shopping_cart_outlined, size: 28),

            Icon(Icons.person_outline, size: 28),
=======
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/home"),
              child: const Icon(Icons.home, size: 28),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoritePage(favorites: []),
                  ),
                );
              },

              child: const Icon(Icons.favorite_border, size: 28),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/cart"),
              child: const Icon(Icons.shopping_cart_outlined, size: 28),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/profile"),
              child: const Icon(Icons.person_outline, size: 28),
            ),
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
          ],
        ),
      ),

<<<<<<< HEAD
      // ======================
      // FLOATING BUTTON
      // ======================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,

        child: const Icon(Icons.add, color: Colors.white),

        onPressed: () async {
          final result = await Navigator.push(
            context,

            MaterialPageRoute(builder: (_) => const AddProductPage()),
          );

          if (result == true) {
            loadProducts();
          }
        },
      ),

      // ======================
      // BODY
      // ======================
=======
      // =========================
      //         BODY
      // =========================
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
<<<<<<< HEAD
            // ======================
            // HEADER
            // ======================
=======
            // =========================
            // HEADER + SEARCH
            // =========================
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
            Container(
              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),

              decoration: const BoxDecoration(
                color: Color(0xFFC7BA9D),
<<<<<<< HEAD

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),

                  bottomRight: Radius.circular(30),
=======
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
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

                  // SEARCH BAR FIX
                  Container(
                    height: 45,

                    decoration: BoxDecoration(
                      color: const Color(0xFFE4DCC4),

                      borderRadius: BorderRadius.circular(16),
                    ),
<<<<<<< HEAD

                    child: const TextField(
                      decoration: InputDecoration(
=======
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
                        prefixIcon: Icon(Icons.search),

                        hintText: "Search",

                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ======================
            // TITLE
            // ======================
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),

              child: Text(
                "Popular Coffee",

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

<<<<<<< HEAD
            // ======================
            // PRODUCT LIST
            // ======================
            products.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),

                      child: Text("Belum ada product"),
                    ),
                  )
                : SizedBox(
                    height: 250,

                    child: ListView(
                      scrollDirection: Axis.horizontal,

                      padding: const EdgeInsets.only(left: 20),

                      children: products.map((product) {
                        return _productCard(context: context, product: product);
                      }).toList(),
                    ),
                  ),
=======
            // ======================================
            //   SEARCH RESULT (JIKA ADA QUERY)
            // ======================================
            if (searchController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: filteredProducts.map((item) {
                    return ListTile(
                      leading: Image.asset(item["img"], width: 45),
                      title: Text(item["name"]),
                      trailing: Text(item["price"]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductPage(
                              img: item["img"],
                              name: item["name"],
                              price: int.parse(item["price"]),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

            // ======================================
            //   SECTION ASLI (hanya tampil saat kosong)
            // ======================================
            if (searchController.text.isEmpty) ...[
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

              // POPULAR COFFEE
              _sectionTitle(
                title: "Popular Coffee",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PopularCoffeePage()),
                ),
              ),

              const SizedBox(height: 15),

              // LIST PRODUCT 1
              _horizontalList([
                allProducts[0],
                allProducts[1],
                allProducts[2],
              ], context),

              const SizedBox(height: 25),

              // POPULAR NON COFFEE
              _sectionTitle(
                title: "Popular Non Coffee",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PopularNonCoffeePage(),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              _horizontalList([allProducts[3], allProducts[4]], context),
            ],
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
          ],
        ),
      ),
    );
  }

  // ======================
<<<<<<< HEAD
  // PRODUCT CARD
  // ======================
=======
  // HELPER WIDGETS
  // ======================

  Widget _sectionTitle({required String title, required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: onTap,
            child: const Text(
              "See All",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _horizontalList(
    List<Map<String, dynamic>> items,
    BuildContext context,
  ) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: items.length,
        itemBuilder: (_, i) {
          var item = items[i];
          return _productCard(
            context: context,
            img: item["img"],
            name: item["name"],
            price: item["price"],
          );
        },
      ),
    );
  }

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

>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
  Widget _productCard({
    required BuildContext context,

    required Map<String, dynamic> product,
  }) {
    return GestureDetector(
<<<<<<< HEAD
      // ======================
      // LONG PRESS MENU
      // ======================
      onLongPress: () {
        showModalBottomSheet(
          context: context,

          builder: (_) {
            return Container(
              padding: const EdgeInsets.all(20),

              height: 180,

              child: Column(
                children: [
                  // EDIT
                  ListTile(
                    leading: const Icon(Icons.edit),

                    title: const Text("Edit"),

                    onTap: () async {
                      Navigator.pop(context);

                      final result = await Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => EditProductPage(product: product),
                        ),
                      );

                      if (result == true) {
                        loadProducts();
                      }
                    },
                  ),

                  // DELETE
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),

                    title: const Text("Delete"),

                    onTap: () async {
                      await deleteProduct(product['id']);

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
=======
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProductPage(img: img, name: name, price: int.parse(price)),
          ),
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
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
                  // IMAGE
                  Container(
                    height: 110,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),

                      child: Image.file(
                        File(product['image']),

                        fit: BoxFit.cover,

                        width: double.infinity,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // NAME
                  Text(
                    product['name'],

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

<<<<<<< HEAD
                  const SizedBox(height: 4),

                  // PRICE
                  Text("Rp ${product['price']}"),
                ],
=======
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: Icon(
                  FavoriteData.isFavorite(name)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 18,
                  color: FavoriteData.isFavorite(name)
                      ? Colors.red
                      : Colors.black,
                ),
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
              ),
            ),

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
