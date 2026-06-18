import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    debugPrint('SQLite DB path: $path');

    return await openDatabase(
      path,
      version: 4, // ← naik dari 3 ke 4
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE cart_items ADD COLUMN user_id INTEGER');
      await db.execute('ALTER TABLE orders ADD COLUMN user_id INTEGER');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE user_favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          menu_id INTEGER NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
          FOREIGN KEY (menu_id) REFERENCES menu_items (id) ON DELETE CASCADE
        )
      ''');
    }
    if (oldVersion < 4) {
      // ← TAMBAHAN BARU: kolom photo
      await db.execute('ALTER TABLE users ADD COLUMN photo TEXT');
      debugPrint('Migration v4: kolom photo berhasil ditambahkan');
    }
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
        address $textNullableType,
        photo $textNullableType
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
        image_url $textNullableType,
        is_favorite $integerType
      )
    ''');

    // Cart Table
    await db.execute('''
      CREATE TABLE cart_items (
        id $idType,
        user_id INTEGER,
        menu_id $integerType,
        quantity $integerType,
        temp_option $textType,
        sugar_option $textType,
        dine_option $textType,
        FOREIGN KEY (menu_id) REFERENCES menu_items (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // User Favorites Table
    await db.execute('''
      CREATE TABLE user_favorites (
        id $idType,
        user_id INTEGER NOT NULL,
        menu_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (menu_id) REFERENCES menu_items (id) ON DELETE CASCADE,
        UNIQUE(user_id, menu_id)
      )
    ''');

    // Orders Table
    await db.execute('''
      CREATE TABLE orders (
        id $idType,
        user_id INTEGER,
        table_number $textType,
        payment_method $textType,
        total_price $doubleType,
        order_time $textType,
        items_summary $textType
      )
    ''');

    await _seedMenu(db);
  }

  Future<void> _seedMenu(Database db) async {
    final defaultItems = [
      {
        'name': 'Kopi Sruput Good Day Mocacino',
        'category': 'Coffee',
        'price': 6000.0,
        'description':
            'Kopi instan 3-in-1 Good Day rasa Mocacinno disajikan dingin dengan es batu segar.',
        'image_path': 'good_day_mocacino',
        'is_favorite': 1,
        'image_url':
            'https://id-live-01.slatic.net/p/60c80838ea24bb139229da0e468ab652.jpg',
      },
      {
        'name': 'Kopi Sruput Nescafe Classic',
        'category': 'Coffee',
        'price': 6000.0,
        'description':
            'Kopi hitam murni berkualitas Nescafe Classic dengan sensasi rasa pekat.',
        'image_path': 'nescafe_classic',
        'image_url':
            'https://i.ytimg.com/vi/SSOqewxGSs4/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLDuDWpYCs59WiI5_YxYiCuYNIHG-w',
        'is_favorite': 0,
      },
      {
        'name': 'Kopi Sruput ABC Kopi Susu',
        'category': 'Coffee',
        'price': 6000.0,
        'description':
            'Racikan kopi susu legendaris dari Kopi ABC, mantap diseruput kapan saja.',
        'image_path': 'abc_kopi_susu',
        'image_url': 'https://example.com/images/abc_kopi_susu.jpg',
        'is_favorite': 0
      },
      {
        'name': 'Sruput Chocolatos Matcha',
        'category': 'Non Coffee',
        'price': 6000.0,
        'description':
            'Minuman bubuk Matcha green tea manis dari Chocolatos, creamy dan segar.',
        'image_path': 'chocolatos_matcha',
        'image_url': 'https://example.com/images/chocolatos_matcha.jpg',
        'is_favorite': 1
      },
      {
        'name': 'Sruput Chocolatos Choco',
        'category': 'Non Coffee',
        'price': 6000.0,
        'description':
            'Cokelat Italia premium yang tebal dan manis khas Chocolatos, disajikan dengan es.',
        'image_path': 'chocolatos_choco',
        'image_url': 'https://example.com/images/chocolatos_choco.jpg',
        'is_favorite': 0
      },
      {
        'name': 'Sruput Energi Beng-Beng',
        'category': 'Non Coffee',
        'price': 6000.0,
        'description':
            'Sajian dingin dari Drink Beng-Beng cokelat berenergi yang nikmat luar biasa.',
        'image_path': 'drink_beng_beng',
        'image_url': 'https://example.com/images/drink_beng_beng.jpg',
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
      return -1;
    }
  }

  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) return maps.first;
    return null;
  }

  Future<int> updateUserProfile(
      int userId, Map<String, dynamic> userRow) async {
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
  Future<int?> _currentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<List<Map<String, dynamic>>> getMenuItems(
      {String? category, String? query}) async {
    final db = await instance.database;
    final userId = await _currentUserId();
    final queryBuffer = StringBuffer('''
      SELECT menu_items.*,
        CASE WHEN user_favorites.id IS NOT NULL THEN 1 ELSE 0 END AS is_favorite
      FROM menu_items
      LEFT JOIN user_favorites ON menu_items.id = user_favorites.menu_id AND user_favorites.user_id = ?
    ''');
    final whereArgs = <dynamic>[userId];

    if (category != null) {
      queryBuffer.write(' WHERE category = ?');
      whereArgs.add(category);
    }

    if (query != null && query.isNotEmpty) {
      queryBuffer.write(whereArgs.length > 1 ? ' AND ' : ' WHERE ');
      queryBuffer.write('name LIKE ?');
      whereArgs.add('%$query%');
    }

    return await db.rawQuery(queryBuffer.toString(), whereArgs);
  }

  Future<int> insertMenuItem(Map<String, dynamic> menuItem) async {
    final db = await instance.database;
    return await db.insert('menu_items', menuItem);
  }

  Future<int> toggleFavorite(int menuId, bool currentFavorite) async {
    final db = await instance.database;
    final userId = await _currentUserId();
    if (userId == null) throw StateError('Pengguna belum masuk');

    if (currentFavorite) {
      return await db.delete(
        'user_favorites',
        where: 'user_id = ? AND menu_id = ?',
        whereArgs: [userId, menuId],
      );
    }

    return await db.insert('user_favorites', {
      'user_id': userId,
      'menu_id': menuId,
    });
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await instance.database;
    final userId = await _currentUserId();
    if (userId == null) return [];

    return await db.rawQuery('''
      SELECT menu_items.*, 1 AS is_favorite
      FROM menu_items
      INNER JOIN user_favorites ON menu_items.id = user_favorites.menu_id
      WHERE user_favorites.user_id = ?
    ''', [userId]);
  }

  // --- CART OPERATIONS ---
  Future<List<Map<String, dynamic>>> getCartWithDetails({int? userId}) async {
    final db = await instance.database;
    final query = StringBuffer('''
      SELECT cart_items.*, menu_items.name, menu_items.price, menu_items.image_path, menu_items.category
      FROM cart_items
      INNER JOIN menu_items ON cart_items.menu_id = menu_items.id
    ''');
    final args = <dynamic>[];

    if (userId != null) {
      query.write(' WHERE cart_items.user_id = ?');
      args.add(userId);
    }

    return await db.rawQuery(query.toString(), args);
  }

  Future<int> addToCart(Map<String, dynamic> cartRow) async {
    final db = await instance.database;
    if (cartRow['user_id'] == null)
      throw ArgumentError('user_id cannot be null');
    if (cartRow['menu_id'] == null)
      throw ArgumentError('menu_id cannot be null');
    final quantity = cartRow['quantity'] as int?;
    if (quantity == null || quantity <= 0)
      throw ArgumentError('quantity must be positive');

    final existing = await db.query(
      'cart_items',
      where:
          'user_id = ? AND menu_id = ? AND temp_option = ? AND sugar_option = ? AND dine_option = ?',
      whereArgs: [
        cartRow['user_id'],
        cartRow['menu_id'],
        cartRow['temp_option'],
        cartRow['sugar_option'],
        cartRow['dine_option']
      ],
    );

    if (existing.isNotEmpty) {
      int id = existing.first['id'] as int;
      int newQty = (existing.first['quantity'] as int) + quantity;
      return await db.update('cart_items', {'quantity': newQty},
          where: 'id = ?', whereArgs: [id]);
    } else {
      return await db.insert('cart_items', cartRow);
    }
  }

  Future<int> updateCartQuantity(int cartId, int quantity) async {
    final db = await instance.database;
    if (quantity <= 0) {
      return await db
          .delete('cart_items', where: 'id = ?', whereArgs: [cartId]);
    }
    return await db.update('cart_items', {'quantity': quantity},
        where: 'id = ?', whereArgs: [cartId]);
  }

  Future<int> clearCart({int? userId}) async {
    final db = await instance.database;
    if (userId != null) {
      return await db
          .delete('cart_items', where: 'user_id = ?', whereArgs: [userId]);
    }
    return await db.delete('cart_items');
  }

  // --- ORDER OPERATIONS ---
  Future<int> placeOrder(int userId, String tableNumber, String paymentMethod,
      double totalPrice) async {
    final db = await instance.database;
    final cartItems = await getCartWithDetails(userId: userId);
    if (cartItems.isEmpty) return -1;

    String summary = cartItems.map((item) {
      return "${item['name']} (${item['quantity']}x) - ${item['temp_option']}, Sugar: ${item['sugar_option']}, ${item['dine_option']}";
    }).join('\n');

    final orderId = await db.insert('orders', {
      'user_id': userId,
      'table_number': tableNumber,
      'payment_method': paymentMethod,
      'total_price': totalPrice,
      'order_time': DateTime.now().toIso8601String(),
      'items_summary': summary
    });

    await clearCart(userId: userId);
    return orderId;
  }

  Future<List<Map<String, dynamic>>> getOrderHistory({int? userId}) async {
    final db = await instance.database;
    if (userId != null) {
      return await db.query('orders',
          where: 'user_id = ?', whereArgs: [userId], orderBy: 'id DESC');
    }
    return await db.query('orders', orderBy: 'id DESC');
  }

  Future close() async {
    final db = _database;
    if (db != null) await db.close();
  }
}
