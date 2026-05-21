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

class CartData {
  static final List<CartItem> items = [];

  static void add(CartItem item) {
    final index = items.indexWhere((e) => e.name == item.name);
    if (index != -1) {
      items[index].quantity += item.quantity;
    } else {
      items.add(item);
    }
  }

  static void removeAt(int index) {
    items.removeAt(index);
  }

  static void clear() {
    items.clear();
  }

  static int get totalItems =>
      items.fold(0, (sum, item) => sum + item.quantity);

  static int get totalPrice =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);
}
