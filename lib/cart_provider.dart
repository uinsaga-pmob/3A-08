import 'package:flutter/material.dart';

class CartItem {
  final String img;
  final String name;
  final int price;
  int quantity;

  CartItem({
    required this.img,
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(String img, String name, int price, int quantity) {
    _items.add(CartItem(
      img: img,
      name: name,
      price: price,
      quantity: quantity,
    ));
    notifyListeners();
  }

  int get total {
    return _items.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }
}
