import 'package:flutter/material.dart';
import 'FavoriteModel.dart';
import 'CartModel.dart';
import 'CheckOutPage.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key, required List favorites});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite")),
      body: FavoriteData.items.isEmpty
          ? const Center(child: Text("Favorite kosong"))
          : ListView.builder(
              itemCount: FavoriteData.items.length,
              itemBuilder: (_, i) {
                final item = FavoriteData.items[i];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.asset(item.img, width: 50),
                    title: Text(item.name),
                    subtitle: Text("Rp ${item.price}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ADD TO CART
                        IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () {
                            CartData.add(
                              CartItem(
                                img: item.img,
                                name: item.name,
                                price: item.price,
                                quantity: 1,
                              ),
                            );
                          },
                        ),

                        // DELETE FAVORITE
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              FavoriteData.remove(item.name);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          child: const Text("Checkout Favorite"),
          onPressed: () {
            for (var item in FavoriteData.items) {
              CartData.add(
                CartItem(
                  img: item.img,
                  name: item.name,
                  price: item.price,
                  quantity: 1,
                ),
              );
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CheckoutPage(
                  name: "Favorite",
                  items: List.from(CartData.items),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
