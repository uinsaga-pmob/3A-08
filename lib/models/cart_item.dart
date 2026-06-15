import 'menu_item.dart';

class CartItem {
  final MenuItem menu;
  int quantity;
  String size; // 'S', 'M', 'L'
  String ice;  // 'None', 'Less', 'Normal'
  String sugar; // 'None', 'Less', 'Normal'

  CartItem({
    required this.menu,
    this.quantity = 1,
    this.size = 'M',
    this.ice = 'Normal',
    this.sugar = 'Normal',
  });

  double get totalPrice {
    double sizeExtra = 0.0;
    if (size == 'L') {
      sizeExtra = 4000.0;
    } else if (size == 'S') {
      sizeExtra = -2000.0;
    }
    return (menu.price + sizeExtra) * quantity;
  }
}
