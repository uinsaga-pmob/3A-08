class FavoriteItem {
  final String img;
  final String name;
  final int price;

  FavoriteItem({
    required this.img,
    required this.name,
    required this.price,
  });
}

class FavoriteData {
  static final List<FavoriteItem> _items = [];

  static List<FavoriteItem> get items => _items;

  static bool isFavorite(String name) {
    return _items.any((item) => item.name == name);
  }

  static void toggle(FavoriteItem item) {
    final index = _items.indexWhere((i) => i.name == item.name);
    if (index >= 0) {
      _items.removeAt(index);
    } else {
      _items.add(item);
    }
  }

  static void remove(String name) {
    _items.removeWhere((i) => i.name == name);
  }
}
