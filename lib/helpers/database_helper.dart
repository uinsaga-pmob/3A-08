import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('kopi_sruput.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textNullableType = 'TEXT';
    const integerType = 'INTEGER NOT NULL';
    const doubleType = 'REAL NOT NULL';

    // Users Table
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        name $textType,
        username $textType UNIQUE,
        password $textType,
        phone $textNullableType,
        dob $textNullableType,
        city $textNullableType,
        address $textNullableType
      )
    ''');

    // Menu Table
    await db.execute('''
      CREATE TABLE menu_items (
        id $idType,
        name $textType,
        category $textType,
        price $doubleType,
        description $textType,
        image_path $textNullableType,
        is_favorite $integerType
      )
    ''');

    // Cart Table
    await db.execute('''
      CREATE TABLE cart_items (
        id $idType,
        menu_id $integerType,
        quantity $integerType,
        temp_option $textType, -- 'Ice' or 'Hot'
        sugar_option $textType, -- 'Less', 'Normal', 'Extra'
        dine_option $textType, -- 'Dine In' or 'Take Away'
        FOREIGN KEY (menu_id) REFERENCES menu_items (id) ON DELETE CASCADE
      )
    ''');

    // Orders/History Table
    await db.execute('''
      CREATE TABLE orders (
        id $idType,
        table_number $textType,
        payment_method $textType,
        total_price $doubleType,
        order_time $textType,
        items_summary $textType -- Store structured text / JSON of items ordered
      )
    ''');

    // Seed default menu items
    await _seedMenu(db);
  }

  Future<void> _seedMenu(Database db) async {
    final defaultItems = [
      {
        'name': 'Kopi Sruput Good Day Mocacino',
        'category': 'Coffee',
        'price': 6000.0,
        'description': 'Kopi instan 3-in-1 Good Day rasa Mocacinno disajikan dingin dengan es batu segar.',
        'image_path': 'good_day_mocacino',
        'is_favorite': 1
      },
      {
        'name': 'Kopi Sruput Nescafe Classic',
        'category': 'Coffee',
        'price': 6000.0,
        'description': 'Kopi hitam murni berkualitas Nescafe Classic dengan sensasi rasa pekat.',
        'image_path': 'nescafe_classic',
        'is_favorite': 0
      },
      {
        'name': 'Kopi Sruput ABC Kopi Susu',
        'category': 'Coffee',
        'price': 6000.0,
        'description': 'Racikan kopi susu legendaris dari Kopi ABC, mantap diseruput kapan saja.',
        'image_path': 'abc_kopi_susu',
        'is_favorite': 0
      },
      {
        'name': 'Sruput Chocolatos Matcha',
        'category': 'Non Coffee',
        'price': 6000.0,
        'description': 'Minuman bubuk Matcha green tea manis dari Chocolatos, creamy dan segar.',
        'image_path': 'chocolatos_matcha',
        'is_favorite': 1
      },
      {
        'name': 'Sruput Chocolatos Choco',
        'category': 'Non Coffee',
        'price': 6000.0,
        'description': 'Cokelat Italia premium yang tebal dan manis khas Chocolatos, disajikan dengan es.',
        'image_path': 'chocolatos_choco',
        'is_favorite': 0
      },
      {
        'name': 'Sruput Energi Beng-Beng',
        'category': 'Non Coffee',
        'price': 6000.0,
        'description': 'Sajian dingin dari Drink Beng-Beng cokelat berenergi yang nikmat luar biasa.',
        'image_path': 'drink_beng_beng',
        'is_favorite': 0
      }
    ];

    for (var item in defaultItems) {
      await db.insert('menu_items', item);
    }
  }

  // --- USER OPERATIONS ---
  Future<int> registerUser(Map<String, dynamic> userRow) async {
    final db = await instance.database;
    try {
      return await db.insert('users', userRow);
    } catch (e) {
      return -1; // Username conflict or failure
    }
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> updateUserProfile(int userId, Map<String, dynamic> userRow) async {
    final db = await instance.database;
    return await db.update(
      'users',
      userRow,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<Map<String, dynamic>?> getUser(int userId) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) return maps.first;
    return null;
  }

  // --- MENU OPERATIONS ---
  Future<List<Map<String, dynamic>>> getMenuItems({String? category, String? query}) async {
    final db = await instance.database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (category != null) {
      whereClause += 'category = ?';
      whereArgs.add(category);
    }

    if (query != null && query.isNotEmpty) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'name LIKE ?';
      whereArgs.add('%$query%');
    }

    if (whereClause.isNotEmpty) {
      return await db.query('menu_items', where: whereClause, whereArgs: whereArgs);
    } else {
      return await db.query('menu_items');
    }
  }

  Future<int> insertMenuItem(Map<String, dynamic> menuItem) async {
    final db = await instance.database;
    return await db.insert('menu_items', menuItem);
  }

  Future<int> toggleFavorite(int menuId, bool currentFavorite) async {
    final db = await instance.database;
    return await db.update(
      'menu_items',
      {'is_favorite': currentFavorite ? 0 : 1},
      where: 'id = ?',
      whereArgs: [menuId],
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await instance.database;
    return await db.query('menu_items', where: 'is_favorite = ?', whereArgs: [1]);
  }

  // --- CART OPERATIONS ---
  Future<List<Map<String, dynamic>>> getCartWithDetails() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT cart_items.*, menu_items.name, menu_items.price, menu_items.image_path, menu_items.category
      FROM cart_items
      INNER JOIN menu_items ON cart_items.menu_id = menu_items.id
    ''');
  }

  Future<int> addToCart(Map<String, dynamic> cartRow) async {
    final db = await instance.database;
    // Check if the exact item with same options already exists:
    final existing = await db.query(
      'cart_items',
      where: 'menu_id = ? AND temp_option = ? AND sugar_option = ? AND dine_option = ?',
      whereArgs: [
        cartRow['menu_id'],
        cartRow['temp_option'],
        cartRow['sugar_option'],
        cartRow['dine_option']
      ],
    );

    if (existing.isNotEmpty) {
      int id = existing.first['id'] as int;
      int oldQty = existing.first['quantity'] as int;
      int newQty = oldQty + (cartRow['quantity'] as int);
      return await db.update(
        'cart_items',
        {'quantity': newQty},
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
      return await db.insert('cart_items', cartRow);
    }
  }

  Future<int> updateCartQuantity(int cartId, int quantity) async {
    final db = await instance.database;
    if (quantity <= 0) {
      return await db.delete('cart_items', where: 'id = ?', whereArgs: [cartId]);
    }
    return await db.update(
      'cart_items',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [cartId],
    );
  }

  Future<int> clearCart() async {
    final db = await instance.database;
    return await db.delete('cart_items');
  }

  // --- ORDER OPERATIONS ---
  Future<int> placeOrder(String tableNumber, String paymentMethod, double totalPrice) async {
    final db = await instance.database;
    
    // Fetch current cart items to create a summary
    final cartItems = await getCartWithDetails();
    if (cartItems.isEmpty) return -1;

    String summary = cartItems.map((item) {
      return "${item['name']} (${item['quantity']}x) - ${item['temp_option']}, Sugar: ${item['sugar_option']}, ${item['dine_option']}";
    }).join('\n');

    // Create Order Row
    final orderId = await db.insert('orders', {
      'table_number': tableNumber,
      'payment_method': paymentMethod,
      'total_price': totalPrice,
      'order_time': DateTime.now().toIso8601String(),
      'items_summary': summary
    });

    // Clear the cart
    await clearCart();
    return orderId;
  }

  Future<List<Map<String, dynamic>>> getOrderHistory() async {
    final db = await instance.database;
    return await db.query('orders', orderBy: 'id DESC');
  }

  Future close() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }
}
