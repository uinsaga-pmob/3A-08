class MenuItem {
  final int? id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String? imagePath;
  final String? imageUrl;
  final bool isFavorite;

  MenuItem({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    this.imagePath,
    this.imageUrl,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'image_path': imagePath,
      'image_url': imageUrl,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      imagePath: map['image_path'] as String?,
      imageUrl: map['image_url'] as String?,
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
    );
  }
}
