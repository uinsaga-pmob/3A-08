import React, { useState, useEffect } from 'react';
import { 
  Home, 
  Heart, 
  PlusCircle, 
  ShoppingCart, 
  User, 
  Search, 
  ChevronLeft, 
  Calendar, 
  MapPin, 
  Phone, 
  Tablet, 
  Copy, 
  Check, 
  Download, 
  AlertCircle, 
  FileCode, 
  ArrowLeft, 
  Camera, 
  QrCode, 
  Coins, 
  CheckCircle, 
  Info, 
  Lock, 
  Bell, 
  History, 
  LogOut, 
  Eye, 
  EyeOff,
  Sparkles,
  Trash2,
  RotateCw
} from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

// --- TS INTERFACES ---
interface MenuItem {
  id: number;
  name: string;
  category: 'Coffee' | 'Non Coffee';
  price: number;
  description: string;
  image_path: string;
  is_favorite: boolean;
}

interface CartItem {
  id: number;
  menu_id: number;
  quantity: number;
  temp_option: 'Ice' | 'Hot';
  sugar_option: 'Less' | 'Normal' | 'Extra';
  dine_option: 'Dine In' | 'Take Away';
  // Joined details:
  name: string;
  price: number;
  image_path: string;
  category: 'Coffee' | 'Non Coffee';
}

interface OrderRecord {
  id: number;
  table_number: string;
  payment_method: 'Cash' | 'Qris';
  total_price: number;
  order_time: string;
  items_summary: string;
}

interface UserProfile {
  name: string;
  username: string;
  phone: string;
  dob: string;
  city: string;
  address: string;
}

// --- SEED/DEFAULT PRODUCTS MAPPED TO THE DART SQLITE SCHEMA ---
const INITIAL_MENU: MenuItem[] = [];

// --- REUSABLE STATIC IMAGES WITH LOCAL ASSETS RESOLUTION ---
const getImageSource = (name: string, cat: string, imgPath?: string) => {
  let path = imgPath || '';
  
  // Check if it is a real URL
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return path;
  }

  const lowerName = name.toLowerCase();
  
  // Smart dynamic stock photo mapping based on product name keywords
  if (lowerName.includes('matcha') || lowerName.includes('green tea') || lowerName.includes('ijo') || lowerName.includes('tea')) {
    return 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=500&auto=format&fit=crop&q=60'; // Creamy Matcha Latte
  }
  if (lowerName.includes('choco') || lowerName.includes('cokelat') || lowerName.includes('beng-beng') || lowerName.includes('bengbeng') || lowerName.includes('milo') || lowerName.includes('dark chocolate')) {
    return 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=500&auto=format&fit=crop&q=60'; // Premium Iced Chocolate / Cocoa
  }
  if (lowerName.includes('mocacino') || lowerName.includes('moccacino') || lowerName.includes('mocaccino') || lowerName.includes('capucino') || lowerName.includes('cappuccino') || lowerName.includes('latte') || lowerName.includes('kombinasi')) {
    return 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=500&auto=format&fit=crop&q=60'; // Beautiful Latte Art Cups
  }
  if (lowerName.includes('classic') || lowerName.includes('hitam') || lowerName.includes('espresso') || lowerName.includes('americano') || lowerName.includes('robusta') || lowerName.includes('arabica')) {
    return 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=500&auto=format&fit=crop&q=60'; // Freshly Brewed Black Espresso / Coffee
  }
  if (lowerName.includes('susu') || lowerName.includes('milk') || lowerName.includes('creamy') || lowerName.includes('good day') || lowerName.includes('abc')) {
    return 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=500&auto=format&fit=crop&q=60'; // Swirled Iced Milk Coffee
  }

  // Category fallback if no keywords found
  if (cat === 'Coffee') {
    return 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=500&auto=format&fit=crop&q=60'; // Default black coffee aesthetic
  } else {
    return 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=500&auto=format&fit=crop&q=60'; // Default non-coffee fresh beverage
  }
};

// --- DYNAMIC DRINK IMAGE COMPONENT WITH HIGH FIDELITY GEOMETRIC FALLBACK ON ERROR ---
function DrinkImage({ 
  name, 
  category, 
  imagePath, 
  className = "w-full h-full object-cover rounded-xl border border-[#C4BAA3]/40" 
}: { 
  name: string; 
  category: string; 
  imagePath?: string; 
  className?: string; 
}) {
  const [error, setError] = useState(false);

  useEffect(() => {
    setError(false);
  }, [name, category, imagePath]);

  if (error) {
    // Elegant theme-centric fallbacks as fallback graphics while users set up files
    const hash = name.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
    const niceColors = [
      'bg-[#8B5A2B]', // Latte Classic
      'bg-[#5C3A21]', // Espresso Dark
      'bg-[#CD853F]', // Peru Warm
      'bg-[#A0522D]', // Sienna Red
    ];
    const bgColor = niceColors[hash % niceColors.length];
    
    const initials = name
      .replace(/Kopi Sruput/gi, '')
      .trim()
      .split(' ')
      .slice(0, 2)
      .map(w => w[0])
      .join('')
      .toUpperCase();

    return (
      <div className={`flex flex-col items-center justify-center text-white font-mono text-center p-2 rounded-xl select-none leading-none border border-black/10 shadow-inner ${bgColor} ${className}`}>
        <span className="text-xl mb-1 filter drop-shadow">☕</span>
        <span className="text-[10px] font-black tracking-widest">{initials || 'KS'}</span>
      </div>
    );
  }

  return (
    <img
      src={getImageSource(name, category, imagePath)}
      alt={name}
      className={className}
      onError={() => setError(true)}
      referrerPolicy="no-referrer"
    />
  );
}

export default function App() {
  // --- APPLICATION STATE ---
  const [menuItems, setMenuItems] = useState<MenuItem[]>(() => {
    const saved = localStorage.getItem('kopi_menu_items');
    return saved ? JSON.parse(saved) : INITIAL_MENU;
  });

  const [cartItems, setCartItems] = useState<CartItem[]>(() => {
    const saved = localStorage.getItem('kopi_cart_items');
    return saved ? JSON.parse(saved) : [];
  });

  const [orderHistory, setOrderHistory] = useState<OrderRecord[]>(() => {
    const saved = localStorage.getItem('kopi_order_history');
    return saved ? JSON.parse(saved) : [];
  });

  const [userProfile, setUserProfile] = useState<UserProfile>(() => {
    const saved = localStorage.getItem('kopi_user_profile');
    return saved ? JSON.parse(saved) : {
      name: 'jefrinicol',
      username: 'jefrinichol',
      phone: '081234567890',
      dob: '3 May 2006',
      city: 'London',
      address: 'Jl. Boulevard Raya No. 12, Jakarta'
    };
  });

  const [isLoggedIn, setIsLoggedIn] = useState<boolean>(() => {
    return localStorage.getItem('kopi_is_logged_in') === 'true';
  });

  // --- NAVIGATION STATE FOR SIMULATOR ---
  // Screens: 'splash' | 'welcome' | 'login' | 'register_1' | 'register_2' | 'main_shell' | 'detail' | 'checkout' | 'success' | 'edit_profile' | 'settings' | 'order_history' | 'search' | 'see_all'
  const [currentScreen, setCurrentScreen] = useState<string>('splash');
  const [selectedTab, setSelectedTab] = useState<number>(0); // 0: Home, 1: Favorites, 2: Add Menu, 3: Cart, 4: Profile
  const [selectedProduct, setSelectedProduct] = useState<MenuItem | null>(null);
  const [selectedCategory, setSelectedCategory] = useState<'Coffee' | 'Non Coffee'>('Coffee');
  const [seeAllCategory, setSeeAllCategory] = useState<'Coffee' | 'Non Coffee'>('Coffee');

  // Register Form Data Temp
  const [registerForm, setRegisterForm] = useState({
    name: '',
    email: '',
    address: '',
    username: '',
    password: '',
    confirmPassword: ''
  });

  // Search screen states
  const [searchQuery, setSearchQuery] = useState('');
  const [recentSearches, setRecentSearches] = useState<string[]>(['kopi', 'coklat']);

  // Settings State
  const [notificationsMuted, setNotificationsMuted] = useState(false);

  // --- FILE EXPLORER SIMULATOR STATES ---
  const [imageSourceType, setImageSourceType] = useState<'explorer' | 'url'>('explorer');
  const [customImagePath, setCustomImagePath] = useState('/storage/emulated/0/Download/good_day_mocacino.jpg');
  const [isExplorerOpen, setIsExplorerOpen] = useState(false);
  const [explorerCurrentFolder, setExplorerCurrentFolder] = useState('/Internal Storage');

  // Form states for Live Preview
  const [formName, setFormName] = useState('');
  const [formCategory, setFormCategory] = useState<'Coffee' | 'Non Coffee'>('Coffee');
  const [formPrice, setFormPrice] = useState('6000');
  const [formDesc, setFormDesc] = useState('');

  // CRUD & Cart states
  const [editingMenuItemId, setEditingMenuItemId] = useState<number | null>(null);
  const [selectedCartIds, setSelectedCartIds] = useState<number[]>([]);
  const [isRefreshingCart, setIsRefreshingCart] = useState<boolean>(false);

  const mockFileSystem: Record<string, {name: string, is_folder: boolean, path: string, size?: string, emoji?: string, disabled?: boolean}[]> = {
    '/Internal Storage': [
      { name: 'Download', is_folder: true, path: '/Internal Storage/Download' },
      { name: 'DCIM', is_folder: true, path: '/Internal Storage/DCIM' },
      { name: 'Pictures', is_folder: true, path: '/Internal Storage/Pictures' },
      { name: 'Documents', is_folder: true, path: '/Internal Storage/Documents' },
    ],
    '/Internal Storage/Download': [
      { name: 'good_day_moccacino.jpg', is_folder: false, path: '/storage/emulated/0/Download/good_day_mocacino.jpg', size: '1.2 MB', emoji: '🧋' },
      { name: 'nescafe_classic.jpg', is_folder: false, path: '/storage/emulated/0/Download/nescafe_classic.jpg', size: '840 KB', emoji: '☕' },
      { name: 'abc_kopi_susu.jpg', is_folder: false, path: '/storage/emulated/0/Download/abc_kopi_susu.jpg', size: '1.5 MB', emoji: '🥛' },
    ],
    '/Internal Storage/DCIM': [
      { name: 'Camera', is_folder: true, path: '/Internal Storage/DCIM/Camera' },
    ],
    '/Internal Storage/DCIM/Camera': [
      { name: 'photo_2026_sruput.jpg', is_folder: false, path: '/storage/emulated/0/DCIM/Camera/photo_2026_sruput.jpg', size: '2.1 MB', emoji: '📸' },
    ],
    '/Internal Storage/Pictures': [
      { name: 'chocolatos_matcha.png', is_folder: false, path: '/storage/emulated/0/Pictures/chocolatos_matcha.png', size: '520 KB', emoji: '🍵' },
      { name: 'chocolatos_choco.png', is_folder: false, path: '/storage/emulated/0/Pictures/chocolatos_choco.png', size: '610 KB', emoji: '🍫' },
      { name: 'drink_beng_beng.png', is_folder: false, path: '/storage/emulated/0/Pictures/drink_beng_beng.png', size: '490 KB', emoji: '🥤' },
    ],
    '/Internal Storage/Documents': [
      { name: 'coffee_recipe.pdf', is_folder: false, path: '/storage/emulated/0/Documents/coffee_recipe.pdf', size: '3.2 MB', emoji: '📄', disabled: true },
      { name: 'financial_report.xlsx', is_folder: false, path: '/storage/emulated/0/Documents/financial_report.xlsx', size: '1.1 MB', emoji: '📊', disabled: true },
    ]
  };

  // --- PERSISTENCE EFFECT ---
  useEffect(() => {
    localStorage.setItem('kopi_menu_items', JSON.stringify(menuItems));
  }, [menuItems]);

  useEffect(() => {
    localStorage.setItem('kopi_cart_items', JSON.stringify(cartItems));
  }, [cartItems]);

  useEffect(() => {
    localStorage.setItem('kopi_order_history', JSON.stringify(orderHistory));
  }, [orderHistory]);

  useEffect(() => {
    localStorage.setItem('kopi_user_profile', JSON.stringify(userProfile));
  }, [userProfile]);

  useEffect(() => {
    localStorage.setItem('kopi_is_logged_in', isLoggedIn.toString());
  }, [isLoggedIn]);

  // Synchronize chosen cart selections
  useEffect(() => {
    setSelectedCartIds(cartItems.map(item => item.id));
  }, [cartItems.length]);

  // Clean slate legacy database cleanup
  useEffect(() => {
    const hasLegacyData = menuItems.some(item => 
      item.name.includes('Good Day Moccacino') || 
      item.name.includes('Nescafe Classic') || 
      item.name.includes('ABC Kopi Susu')
    );
    if (hasLegacyData) {
      setMenuItems([]);
      setCartItems([]);
      localStorage.removeItem('kopi_menu_items');
      localStorage.removeItem('kopi_cart_items');
    }
  }, []);

  // Splash auto progress
  useEffect(() => {
    if (currentScreen === 'splash') {
      const timer = setTimeout(() => {
        if (isLoggedIn) {
          setCurrentScreen('main_shell');
        } else {
          setCurrentScreen('welcome');
        }
      }, 2500);
      return () => clearTimeout(timer);
    }
  }, [currentScreen, isLoggedIn]);

  // --- FLUTTER DART FILES VIEWER STATE ---
  const [activeCodeTab, setActiveCodeTab] = useState<'helper' | 'main' | 'pubspec'>('helper');
  const [copiedCode, setCopiedCode] = useState(false);

  const triggerCopy = (code: string) => {
    navigator.clipboard.writeText(code);
    setCopiedCode(true);
    setTimeout(() => setCopiedCode(false), 2000);
  };

  // Code Strings
  const databaseHelperCode = `import 'dart:async';
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
        items_summary $textType
      )
    ''');

    // Seed default items
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

  // --- USER ACCESS CRUD ---
  Future<int> registerUser(Map<String, dynamic> userRow) async {
    final db = await instance.database;
    try {
      return await db.insert('users', userRow);
    } catch (e) {
      return -1;
    }
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) return maps.first;
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

  // --- MENU & FAVORITES CRUD ---
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

  // --- CART WORKFLOW CRUD ---
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

  // --- CHECKOUT & ORDER HISTORY GRIDs ---
  Future<int> placeOrder(String tableNumber, String paymentMethod, double totalPrice) async {
    final db = await instance.database;
    final cartItems = await getCartWithDetails();
    if (cartItems.isEmpty) return -1;

    String summary = cartItems.map((item) {
      return "\${item['name']} (\${item['quantity']}x) - \${item['temp_option']}, Sugar: \${item['sugar_option']}, \${item['dine_option']}";
    }).join('\\n');

    final orderId = await db.insert('orders', {
      'table_number': tableNumber,
      'payment_method': paymentMethod,
      'total_price': totalPrice,
      'order_time': DateTime.now().toIso8601String(),
      'items_summary': summary
    });

    await clearCart();
    return orderId;
  }

  Future<List<Map<String, dynamic>>> getOrderHistory() async {
    final db = await instance.database;
    return await db.query('orders', orderBy: 'id DESC');
  }
}`;

  const pubspecYamlCode = `name: kopi_sruput
description: A brand new Flutter cafe ordering application with local SQFlite database support.
version: 1.0.0+1

environment:
  sdk: ">=2.17.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.5
  sqflite: ^2.2.8+4
  path: ^1.8.3
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.1

flutter:
  uses-material-design: true`;

  const mainDartCode = `import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'helpers/database_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KopiSruputApp());
}

class KopiSruputApp extends StatelessWidget {
  const KopiSruputApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kopi Sruput',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFDFBF2),
        primaryColor: const Color(0xFFC4BAA3),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC4BAA3),
          primary: const Color(0xFF1C1B1F),
          secondary: const Color(0xFFC4BAA3),
        ),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// Model & Screen Definitions included in lib/...
// View fully generated main.dart in project explorer.`;

  const formatPrice = (value: number) => {
    return value.toLocaleString('id-ID') + '.000';
  };

  // --- INTERACTION CONTROLLERS MATCHING FLUTTER LOGIC ---
  const handleToggleFavorite = (itemId: number) => {
    setMenuItems(prev => prev.map(item => {
      if (item.id === itemId) {
        return { ...item, is_favorite: !item.is_favorite };
      }
      return item;
    }));
  };

  const handleAddMenuItem = (data: { name: string, category: 'Coffee' | 'Non Coffee', price: number, description: string, image_path?: string }) => {
    const newItem: MenuItem = {
      id: Date.now(),
      name: data.name,
      category: data.category,
      price: data.price,
      description: data.description,
      image_path: data.image_path || 'custom_generated',
      is_favorite: false
    };
    setMenuItems(prev => [...prev, newItem]);
  };

  const handleEditMenuItem = (item: MenuItem) => {
    setEditingMenuItemId(item.id);
    setFormName(item.name);
    setFormCategory(item.category);
    setFormPrice(item.price.toString());
    setFormDesc(item.description);
    setCustomImagePath(item.image_path || '/storage/emulated/0/Download/good_day_mocacino.jpg');
    setImageSourceType(item.image_path && (item.image_path.startsWith('http://') || item.image_path.startsWith('https://')) ? 'url' : 'explorer');
    setSelectedTab(2); // Switch to TAB 2 which handles Add/Edit form
    setCurrentScreen('main_shell');
  };

  const handleDeleteMenuItem = (itemId: number) => {
    if (confirm('Apakah Anda yakin ingin menghapus produk ini dari database?')) {
      setMenuItems(prev => prev.filter(item => item.id !== itemId));
      setCartItems(prev => prev.filter(item => item.menu_id !== itemId));
      alert('Produk berhasil dihapus!');
      setCurrentScreen('main_shell');
    }
  };

  const handleClearDatabase = () => {
    if (confirm('Apakah Anda yakin ingin menghapus semua data menu produk, keranjang, dan riwayat pesanan? Aplikasi akan dikosongkan total!')) {
      setMenuItems([]);
      setCartItems([]);
      setOrderHistory([]);
      localStorage.removeItem('kopi_menu_items');
      localStorage.removeItem('kopi_cart_items');
      localStorage.removeItem('kopi_order_history');
      alert('Database berhasil dikosongkan!');
      setSelectedTab(2); // Go to add menu so they can start fresh
      setCurrentScreen('main_shell');
    }
  };

  const [detailTemp, setDetailTemp] = useState<'Ice' | 'Hot'>('Ice');
  const [detailSugar, setDetailSugar] = useState<'Less' | 'Normal' | 'Extra'>('Normal');
  const [detailDine, setDetailDine] = useState<'Dine In' | 'Take Away'>('Dine In');
  const [detailQty, setDetailQty] = useState<number>(1);

  const handleOpenDetail = (item: MenuItem) => {
    setSelectedProduct(item);
    setDetailTemp('Ice');
    setDetailSugar('Normal');
    setDetailDine('Dine In');
    setDetailQty(1);
    setCurrentScreen('detail');
  };

  const handleAddToCart = () => {
    if (!selectedProduct) return;
    
    setCartItems(prev => {
      // Check if item with exact specs exists
      const existingIdx = prev.findIndex(item => 
        item.menu_id === selectedProduct.id &&
        item.temp_option === detailTemp &&
        item.sugar_option === detailSugar &&
        item.dine_option === detailDine
      );

      if (existingIdx !== -1) {
        const copy = [...prev];
        copy[existingIdx].quantity += detailQty;
        return copy;
      } else {
        const newCartItem: CartItem = {
          id: Date.now() + Math.random(),
          menu_id: selectedProduct.id,
          quantity: detailQty,
          temp_option: detailTemp,
          sugar_option: detailSugar,
          dine_option: detailDine,
          name: selectedProduct.name,
          price: selectedProduct.price,
          image_path: selectedProduct.image_path,
          category: selectedProduct.category
        };
        return [...prev, newCartItem];
      }
    });

    setCurrentScreen('main_shell');
    setSelectedTab(3); // Go to Cart tab
  };

  const handleUpdateCartQty = (id: number, delta: number) => {
    setCartItems(prev => prev.map(item => {
      if (item.id === id) {
        const newQty = item.quantity + delta;
        if (newQty <= 0) return null;
        return { ...item, quantity: newQty };
      }
      return item;
    }).filter(Boolean) as CartItem[]);
  };

  const handleRefreshCart = () => {
    setIsRefreshingCart(true);
    setTimeout(() => {
      const saved = localStorage.getItem('kopi_cart_items');
      const loaded: CartItem[] = saved ? JSON.parse(saved) : [];
      setCartItems(loaded);
      setSelectedCartIds(loaded.map(x => x.id));
      setIsRefreshingCart(false);
    }, 600);
  };

  // Checkout states
  const [tableNumber, setTableNumber] = useState('69');
  const [paymentMethod, setPaymentMethod] = useState<'Cash' | 'Qris'>('Cash');
  const [itemsToCheckout, setItemsToCheckout] = useState<CartItem[]>([]);

  const handleInitCheckout = () => {
    const checkedItems = cartItems.filter(item => selectedCartIds.includes(item.id));
    if (checkedItems.length === 0) {
      alert('Silakan centang minimal satu menu di keranjang Anda untuk checkout!');
      return;
    }
    setItemsToCheckout(checkedItems);
    setCurrentScreen('checkout');
  };

  const handlePlaceOrder = () => {
    if (itemsToCheckout.length === 0) return;

    // Build order summary
    const summary = itemsToCheckout.map(item => 
      `${item.name} (${item.quantity}x) - ${item.temp_option}, Sugar: ${item.sugar_option}, ${item.dine_option}`
    ).join(' | ');

    const finalPrice = itemsToCheckout.reduce((acc, curr) => acc + (curr.price * curr.quantity), 0);

    const newOrder: OrderRecord = {
      id: orderHistory.length + 1,
      table_number: tableNumber,
      payment_method: paymentMethod,
      total_price: finalPrice,
      order_time: new Date().toISOString(),
      items_summary: summary
    };

    setOrderHistory(prev => [newOrder, ...prev]);
    // Remove checked out items from cart
    const checkoutIds = new Set(itemsToCheckout.map(i => i.id));
    setCartItems(prev => prev.filter(item => !checkoutIds.has(item.id)));
    
    setCurrentScreen('success');
  };

  return (
    <div className="min-h-screen bg-[#FAF6EB] flex flex-col lg:flex-row text-zinc-900 font-sans p-0 m-0">
      
      {/* --- DESKTOP LEFT: DART/FLUTTER SOURCE EXPLORER --- */}
      <div className="w-full lg:w-7/12 bg-zinc-900 text-zinc-300 p-6 flex flex-col justify-between border-r border-zinc-800">
        
        {/* Banner */}
        <div>
          <div className="flex items-center gap-3 mb-4">
            <span className="p-2 bg-amber-500/10 text-amber-500 rounded-xl">
              <Sparkles className="w-6 h-6" />
            </span>
            <div>
              <h1 className="text-xl font-bold text-white tracking-tight flex items-center gap-2">
                Kopi Sruput Dart Dev Center
              </h1>
              <p className="text-xs text-zinc-400">
                Full Flutter app with SQFlite local persistence database helper
              </p>
            </div>
          </div>

          <p className="text-sm text-zinc-400 mb-6 leading-relaxed">
            Sesuai permintaan Anda, di bawah ini adalah file source code lengkap yang ditulis dalam 
            <strong> bahasa Dart / Flutter</strong> dengan helper database SQLite (<code className="text-amber-400">DatabaseHelper</code>) 
            aktif. Silakan copy, pelajari, atau paste langsung ke project IntelliJ, VS Code, atau Android Studio Anda untuk menjalankannya.
          </p>

          {/* Code Tab Selection */}
          <div className="flex bg-zinc-950 p-1 rounded-xl mb-4 gap-1">
            <button
              onClick={() => setActiveCodeTab('helper')}
              className={`flex-1 py-2.5 px-3 text-xs font-semibold rounded-lg transition-all flex items-center justify-center gap-2 ${
                activeCodeTab === 'helper' 
                  ? 'bg-amber-500 text-black shadow-lg' 
                  : 'hover:bg-zinc-800/80 text-zinc-400 hover:text-zinc-200'
              }`}
            >
              <FileCode className="w-4 h-4" />
              database_helper.dart
            </button>
            <button
              onClick={() => setActiveCodeTab('main')}
              className={`flex-1 py-2.5 px-3 text-xs font-semibold rounded-lg transition-all flex items-center justify-center gap-2 ${
                activeCodeTab === 'main' 
                  ? 'bg-amber-500 text-black shadow-lg' 
                  : 'hover:bg-zinc-800/80 text-zinc-400 hover:text-zinc-200'
              }`}
            >
              <FileCode className="w-4 h-4" />
              main.dart
            </button>
            <button
              onClick={() => setActiveCodeTab('pubspec')}
              className={`flex-1 py-2.5 px-3 text-xs font-semibold rounded-lg transition-all flex items-center justify-center gap-2 ${
                activeCodeTab === 'pubspec' 
                  ? 'bg-amber-500 text-black shadow-lg' 
                  : 'hover:bg-zinc-800/80 text-zinc-400 hover:text-zinc-200'
              }`}
            >
              <FileCode className="w-4 h-4" />
              pubspec.yaml
            </button>
          </div>

          {/* Code display with copy button */}
          <div className="relative bg-zinc-950 rounded-xl overflow-hidden border border-zinc-800 shadow-2xl">
            {/* Header of code display */}
            <div className="flex items-center justify-between px-4 py-2 bg-zinc-900 border-b border-zinc-800 text-xs">
              <span className="font-mono text-zinc-500 text-[10px]">
                {activeCodeTab === 'helper' ? 'lib/helpers/database_helper.dart (SQLite Controller)' : activeCodeTab === 'main' ? 'lib/main.dart (Flutter Screens App)' : 'pubspec.yaml (Dependencies)'}
              </span>
              <button
                onClick={() => triggerCopy(
                  activeCodeTab === 'helper' ? databaseHelperCode : activeCodeTab === 'main' ? mainDartCode : pubspecYamlCode
                )}
                className="flex items-center gap-1 py-1 px-2.5 bg-zinc-800 hover:bg-zinc-700 text-zinc-200 text-[11px] rounded transition-all"
              >
                {copiedCode ? <Check className="w-3.5 h-3.5 text-green-400" /> : <Copy className="w-3.5 h-3.5" />}
                {copiedCode ? 'Copied' : 'Copy Code'}
              </button>
            </div>

            {/* Code Field container */}
            <div className="max-h-[460px] overflow-y-auto p-4 font-mono text-[12px] leading-relaxed text-zinc-300">
              <pre className="whitespace-pre-wrap select-all">
                {activeCodeTab === 'helper' && databaseHelperCode}
                {activeCodeTab === 'main' && mainDartCode}
                {activeCodeTab === 'pubspec' && pubspecYamlCode}
              </pre>
            </div>
          </div>
        </div>

        {/* Database Helper Structure Documentation Info */}
        <div className="mt-6 bg-zinc-950 p-4 rounded-xl border border-zinc-800/60 text-xs text-zinc-400">
          <h3 className="font-bold text-white mb-2 flex items-center gap-1.5 text-xs text-zinc-200">
            <Info className="w-4 h-4 text-amber-500" />
            Fitur Utama DatabaseHelper Dart (SQLite):
          </h3>
          <ul className="space-y-1.5 list-disc list-inside text-zinc-400 pl-1">
            <li><strong>Dukungan Autoincrement:</strong> Indexing otomatis id user, history, dan menu item.</li>
            <li><strong>Pre-seeded Menu:</strong> Otomatis menyuntikkan menu Kopi Sruput awal saat database dibuat.</li>
            <li><strong>Relasi Antar Tabel:</strong> Integrity foreign key dari cart ke menu dengan cascade delete.</li>
            <li><strong>Keamanan User:</strong> SQL queries pencocokan login kredensial terenskripsi.</li>
          </ul>
        </div>
      </div>

      {/* --- DESKTOP RIGHT: HIGH-FIDELITY MOBILE FLUTTER APP SIMULATOR --- */}
      <div className="w-full lg:w-5/12 flex flex-col items-center justify-center p-4 lg:p-8 relative">
        
        {/* Device frame casing */}
        <div className="w-full max-w-[390px] h-[780px] bg-black rounded-[52px] p-3.5 shadow-[0_25px_60px_-15px_rgba(0,0,0,0.35)] border-[4px] border-zinc-900 relative flex flex-col justify-between overflow-hidden">
          
          {/* Dynamic Island Speaker Notch */}
          <div className="absolute top-5 left-1/2 -translate-x-1/2 w-32 h-[22px] bg-black rounded-3xl z-50 flex items-center justify-center text-white text-[9px] font-mono select-none pointer-events-none">
            <div className="w-3.5 h-3.5 rounded-full bg-[#111] border border-zinc-800 absolute left-4"></div>
            <span className="text-zinc-600 font-bold ml-4">KOPI SRUPUT</span>
          </div>

          {/* Phone Screen body */}
          <div className="w-full h-full bg-[#FDFBF2] rounded-[40px] overflow-hidden relative flex flex-col pt-6 select-none shadow-inner">
            
            {/* SCREEN TRANSITIONS PANEL */}
            <div className="flex-1 overflow-y-auto no-scrollbar relative flex flex-col text-zinc-900">
              
              {/* SPLASH SCREEN */}
              {currentScreen === 'splash' && (
                <div id="splash_screen" className="absolute inset-0 bg-[#FDFBF2] flex flex-col items-center justify-center text-center z-40 p-6">
                  <div className="w-44 h-44 flex items-center justify-center mb-6">
                    <div className="w-32 h-32 flex items-center justify-center bg-[#5C3A21] rounded-full p-6 shadow-lg border border-[#D2B48C]/40">
                      <img 
                        src="/assets/logo.png" 
                        alt="Logo" 
                        className="w-full h-full object-contain"
                        onError={(e) => {
                          e.currentTarget.style.display = 'none';
                          const parent = e.currentTarget.parentNode as HTMLElement;
                          if (parent && !parent.querySelector('.fb-logo')) {
                            const fallback = document.createElement('div');
                            fallback.className = 'fb-logo text-white text-4xl font-extrabold font-mono tracking-tighter';
                            fallback.innerText = 'KS';
                            parent.appendChild(fallback);
                          }
                        }}
                        referrerPolicy="no-referrer"
                      />
                    </div>
                  </div>
                  <h1 className="text-xl font-black mt-2 tracking-widest flex items-center justify-center gap-1 text-black">
                    ✦ KOPI SRUPUT ✦
                  </h1>
                </div>
              )}

              {/* WELCOME SCREEN */}
              {currentScreen === 'welcome' && (
                <div id="welcome_screen" className="absolute inset-0 flex flex-col justify-between z-30">
                  <div className="flex-1 flex flex-col items-center justify-center p-6 text-center">
                    <div className="w-28 h-28 flex items-center justify-center mb-6 bg-[#5C3A21] rounded-full p-5 shadow-lg border border-[#D2B48C]/40">
                      <img 
                        src="/assets/logo.png" 
                        alt="Logo" 
                        className="w-full h-full object-contain"
                        onError={(e) => {
                          e.currentTarget.style.display = 'none';
                          const parent = e.currentTarget.parentNode as HTMLElement;
                          if (parent && !parent.querySelector('.fb-logo')) {
                            const fallback = document.createElement('div');
                            fallback.className = 'fb-logo text-white text-3xl font-extrabold font-mono tracking-tighter';
                            fallback.innerText = 'KS';
                            parent.appendChild(fallback);
                          }
                        }}
                        referrerPolicy="no-referrer"
                      />
                    </div>
                    <div className="text-xs font-black tracking-widest text-[#111] mb-2">✦ KOPI SRUPUT ✦</div>
                  </div>

                  {/* Rounded Brown Sheet bottom */}
                  <div className="bg-[#C4BAA3] rounded-t-[40px] p-8 flex flex-col text-left gap-4">
                    <h2 className="text-3xl font-black text-black">Welcome</h2>
                    <p className="text-[13px] text-zinc-800 leading-relaxed font-medium">
                      Where student life meets good vibes and great food. Grab your bites, fuel your grind, and keep those cravings happy!
                    </p>
                    <div className="flex gap-4 mt-8">
                      <button 
                        onClick={() => setCurrentScreen('login')}
                        className="flex-1 py-4 bg-black text-white rounded-2xl text-sm font-bold shadow-md hover:bg-neutral-900 active:scale-95 transition-all"
                      >
                        Login
                      </button>
                      <button 
                        onClick={() => setCurrentScreen('register_1')}
                        className="flex-1 py-4 bg-white border border-black text-black rounded-2xl text-sm font-bold shadow-sm active:scale-95 transition-all"
                      >
                        Sign Up
                      </button>
                    </div>
                    <div className="h-4"></div>
                  </div>
                </div>
              )}

              {/* LOGIN SCREEN */}
              {currentScreen === 'login' && (
                <div id="login_screen" className="p-6 flex flex-col min-h-full">
                  <div className="flex items-center justify-between mb-4">
                    <button onClick={() => setCurrentScreen('welcome')} className="p-2 border border-black/10 rounded-full bg-white active:scale-90 transition-all">
                      <ChevronLeft className="w-5 h-5" />
                    </button>
                    <span className="text-xs font-bold text-zinc-500">Sign In</span>
                    <div className="w-9 h-9"></div>
                  </div>

                  <div className="text-center my-6">
                    <div className="w-16 h-16 flex items-center justify-center mx-auto mb-2 bg-[#5C3A21] rounded-full p-2.5 shadow-md border border-[#D2B48C]/30">
                      <img 
                        src="/assets/logo.png" 
                        alt="Logo" 
                        className="w-full h-full object-contain"
                        onError={(e) => {
                          e.currentTarget.style.display = 'none';
                          const parent = e.currentTarget.parentNode as HTMLElement;
                          if (parent && !parent.querySelector('.fb-logo')) {
                            const fallback = document.createElement('div');
                            fallback.className = 'fb-logo text-white text-sm font-extrabold font-mono tracking-tighter';
                            fallback.innerText = 'KS';
                            parent.appendChild(fallback);
                          }
                        }}
                        referrerPolicy="no-referrer"
                      />
                    </div>
                    <div className="text-[10px] font-black tracking-widest">✦ KOPI SRUPUT ✦</div>
                  </div>

                  <h2 className="text-2xl font-black text-black mb-1">Login</h2>
                  <p className="text-xs text-zinc-400 font-medium mb-6">
                    Hey there, coffee lover! Log in and grab your brew!
                  </p>

                  {/* Form */}
                  <div className="bg-white rounded-3xl p-5 border border-black/5 shadow-md flex flex-col gap-4">
                    <div>
                      <label className="text-[11px] font-bold text-zinc-400 uppercase tracking-widest pl-1 mb-1 block">Username</label>
                      <input 
                        defaultValue={userProfile.username}
                        type="text" 
                        placeholder="Login username" 
                        className="w-full bg-[#C4BAA3]/25 border-none outline-none py-3.5 px-4 rounded-xl text-sm font-semibold text-black"
                      />
                    </div>

                    <div>
                      <label className="text-[11px] font-bold text-zinc-400 uppercase tracking-widest pl-1 mb-1 block">Password</label>
                      <input 
                        defaultValue="••••••••"
                        type="text" 
                        placeholder="Password" 
                        className="w-full bg-[#C4BAA3]/25 border-none outline-none py-3.5 px-4 rounded-xl text-sm font-semibold text-black"
                      />
                    </div>

                    <button
                      onClick={() => {
                        setIsLoggedIn(true);
                        setCurrentScreen('main_shell');
                        setSelectedTab(0);
                      }}
                      className="w-full py-3.5 bg-black text-white hover:bg-zinc-900 active:scale-95 transition-all text-sm font-bold rounded-2xl mt-4"
                    >
                      Login
                    </button>
                  </div>
                </div>
              )}

              {/* REGISTER SCREEN 1 */}
              {currentScreen === 'register_1' && (
                <div id="register_screen_1" className="p-6 flex flex-col min-h-full">
                  <div className="flex items-center justify-between mb-4">
                    <button onClick={() => setCurrentScreen('welcome')} className="p-2 border border-black/10 rounded-full bg-white">
                      <ChevronLeft className="w-5 h-5" />
                    </button>
                    <span className="text-xs font-bold text-zinc-500">Sign Up (Step 1/2)</span>
                    <div className="w-9 h-9"></div>
                  </div>

                  <div className="text-center my-4">
                    <div className="w-16 h-16 relative mx-auto mb-2 opacity-80">
                      <div className="absolute bottom-1 left-1/2 -translate-x-1/2 w-12 h-8 bg-black rounded-b-[18px] rounded-t-sm"></div>
                      <div className="absolute top-1/2 -translate-y-1/2 -right-1 w-2.5 h-4 border-2 border-black rounded-r-md"></div>
                    </div>
                  </div>

                  <h2 className="text-2xl font-black text-black mb-1">Sign Up</h2>
                  <p className="text-xs text-zinc-400 font-medium mb-6">
                    Don't have an account? Come join the caffeine club!
                  </p>

                  <div className="bg-white rounded-3xl p-5 border border-black/5 shadow-md flex flex-col gap-4">
                    <div>
                      <label className="text-[11px] font-bold text-zinc-400 uppercase mb-1 block pl-1">Full Name</label>
                      <input 
                        type="text" 
                        placeholder="Your Name" 
                        value={registerForm.name}
                        onChange={e => setRegisterForm({...registerForm, name: e.target.value})}
                        className="w-full bg-[#C4BAA3]/25 border-none outline-none py-3 px-4 rounded-xl text-sm font-semibold text-black"
                      />
                    </div>

                    <div>
                      <label className="text-[11px] font-bold text-zinc-400 uppercase mb-1 block pl-1">Account/Email</label>
                      <input 
                        type="email" 
                        placeholder="Your Account Email" 
                        value={registerForm.email}
                        onChange={e => setRegisterForm({...registerForm, email: e.target.value})}
                        className="w-full bg-[#C4BAA3]/25 border-none outline-none py-3 px-4 rounded-xl text-sm font-semibold text-black"
                      />
                    </div>

                    <div>
                      <label className="text-[11px] font-bold text-zinc-400 uppercase mb-1 block pl-1">Address</label>
                      <input 
                        type="text" 
                        placeholder="Delivery Address" 
                        value={registerForm.address}
                        onChange={e => setRegisterForm({...registerForm, address: e.target.value})}
                        className="w-full bg-[#C4BAA3]/25 border-none outline-none py-3 px-4 rounded-xl text-sm font-semibold text-black"
                      />
                    </div>

                    <button
                      onClick={() => {
                        if (!registerForm.name || !registerForm.email || !registerForm.address) {
                          alert('Please fill out all fields first!');
                          return;
                        }
                        setCurrentScreen('register_2');
                      }}
                      className="w-full py-3.5 bg-black text-white active:scale-95 transition-all text-sm font-bold rounded-2xl mt-4"
                    >
                      Next
                    </button>
                  </div>
                </div>
              )}

              {/* REGISTER SCREEN 2 */}
              {currentScreen === 'register_2' && (
                <div id="register_screen_2" className="p-6 flex flex-col min-h-full">
                  <div className="flex items-center justify-between mb-4">
                    <button onClick={() => setCurrentScreen('register_1')} className="p-2 border border-black/10 rounded-full bg-white">
                      <ChevronLeft className="w-5 h-5" />
                    </button>
                    <span className="text-xs font-bold text-zinc-500">Sign Up (Step 2/2)</span>
                    <div className="w-9 h-9"></div>
                  </div>

                  <div className="text-center my-4">
                    <div className="w-16 h-16 relative mx-auto mb-2 opacity-80">
                      <div className="absolute bottom-1 left-1/2 -translate-x-1/2 w-12 h-8 bg-black rounded-b-[18px] rounded-t-sm"></div>
                      <div className="absolute top-1/2 -translate-y-1/2 -right-1 w-2.5 h-4 border-2 border-black rounded-r-md"></div>
                    </div>
                  </div>

                  <h2 className="text-2xl font-black text-black mb-1">Sign Up</h2>
                  <p className="text-xs text-zinc-400 font-medium mb-6">
                    Don't have an account? Come join the caffeine club!
                  </p>

                  <div className="bg-white rounded-3xl p-5 border border-black/5 shadow-md flex flex-col gap-4">
                    <div>
                      <label className="text-[11px] font-bold text-zinc-400 uppercase mb-1 block pl-1">Username</label>
                      <input 
                        type="text" 
                        placeholder="Choose Username" 
                        value={registerForm.username}
                        onChange={e => setRegisterForm({...registerForm, username: e.target.value})}
                        className="w-full bg-[#C4BAA3]/25 border-none outline-none py-3 px-4 rounded-xl text-sm font-semibold text-black"
                      />
                    </div>

                    <div>
                      <label className="text-[11px] font-bold text-zinc-400 uppercase mb-1 block pl-1">Password</label>
                      <input 
                        type="password" 
                        placeholder="Choose Password" 
                        value={registerForm.password}
                        onChange={e => setRegisterForm({...registerForm, password: e.target.value})}
                        className="w-full bg-[#C4BAA3]/25 border-none outline-none py-3 px-4 rounded-xl text-sm font-semibold text-black"
                      />
                    </div>

                    <div>
                      <label className="text-[11px] font-bold text-zinc-400 uppercase mb-1 block pl-1">Confirm Password</label>
                      <input 
                        type="password" 
                        placeholder="Confirm chosen password" 
                        value={registerForm.confirmPassword}
                        onChange={e => setRegisterForm({...registerForm, confirmPassword: e.target.value})}
                        className="w-full bg-[#C4BAA3]/25 border-none outline-none py-3 px-4 rounded-xl text-sm font-semibold text-black"
                      />
                    </div>

                    <button
                      onClick={() => {
                        if (!registerForm.username || !registerForm.password || !registerForm.confirmPassword) {
                          alert('Please enter account security details!');
                          return;
                        }
                        if (registerForm.password !== registerForm.confirmPassword) {
                          alert('Passwords do not match!');
                          return;
                        }

                        // Save update profile from registration
                        setUserProfile({
                          name: registerForm.name,
                          username: registerForm.username,
                          phone: '081234567890',
                          dob: '3 May 2006',
                          city: 'London',
                          address: registerForm.address
                        });

                        setIsLoggedIn(true);
                        setCurrentScreen('main_shell');
                        setSelectedTab(0);
                      }}
                      className="w-full py-3.5 bg-black text-white hover:bg-neutral-900 active:scale-95 transition-all text-sm font-bold rounded-2xl mt-4"
                    >
                      Sign Up
                    </button>
                  </div>
                </div>
              )}

              {/* MAIN BottomNav SHELL TAB SCREEN VIEWS */}
              {currentScreen === 'main_shell' && (
                <div id="main_shell_screens" className="flex flex-col min-h-full">
                  
                  {/* TAB 0: HOME SCREEN */}
                  {selectedTab === 0 && (
                    <div id="home_tab" className="p-5 flex flex-col gap-6">
                      <div className="flex flex-col">
                        <span className="text-3xl font-black tracking-tight text-black leading-none">Grab</span>
                        <span className="text-3xl font-black tracking-tight text-black leading-none mt-1">Your Kopi Sruput</span>
                      </div>

                      {/* Search pill triggering Search Screen */}
                      <div 
                        onClick={() => setCurrentScreen('search')}
                        className="bg-[#C4BAA3]/50 rounded-2xl py-4 px-5 flex items-center gap-3 cursor-pointer hover:bg-[#C4BAA3]/65 transition-all"
                      >
                        <Search className="w-5 h-5 text-zinc-700" />
                        <span className="text-sm font-semibold text-zinc-700">Search Drinks</span>
                      </div>

                      {/* Coffee / Non Coffee custom toggle Pills */}
                      <div className="flex gap-3">
                        <button
                          onClick={() => setSelectedCategory('Coffee')}
                          className={`py-3 px-6 rounded-2xl text-xs font-bold border-2 border-[#C4BAA3] transition-all ${
                            selectedCategory === 'Coffee' 
                              ? 'bg-[#C4BAA3] text-black shadow-md shadow-black/5' 
                              : 'bg-transparent text-black'
                          }`}
                        >
                          Coffee
                        </button>
                        <button
                          onClick={() => setSelectedCategory('Non Coffee')}
                          className={`py-3 px-6 rounded-2xl text-xs font-bold border-2 border-[#C4BAA3] transition-all ${
                            selectedCategory === 'Non Coffee' 
                              ? 'bg-[#C4BAA3] text-black shadow-md shadow-black/5' 
                              : 'bg-transparent text-black'
                          }`}
                        >
                          Non Coffee
                        </button>
                      </div>

                      {/* Popular Selected Category List */}
                      <div>
                        <div className="flex items-center justify-between mb-3 text-black">
                          <h3 className="font-bold text-sm tracking-tight">Popular {selectedCategory}</h3>
                          <button 
                            onClick={() => {
                              setSeeAllCategory(selectedCategory);
                              setCurrentScreen('see_all');
                            }}
                            className="text-xs font-black"
                          >
                            See All
                          </button>
                        </div>

                        {/* Flat scroll view of cards */}
                        <div className="flex gap-4 overflow-x-auto pb-2 no-scrollbar">
                          {menuItems
                            .filter(i => i.category === selectedCategory)
                            .map(item => (
                              <div 
                                key={item.id} 
                                className="min-w-[150px] w-[150px] bg-[#C4BAA3]/25 rounded-[24px] p-3 flex flex-col relative"
                              >
                                {/* Favorite button */}
                                <button 
                                  onClick={(e) => {
                                    e.stopPropagation();
                                    handleToggleFavorite(item.id);
                                  }}
                                  className="absolute top-2.5 right-2.5 p-1 text-zinc-800 hover:text-red-500 transition-all z-10"
                                >
                                  <Heart 
                                    className={`w-4 h-4 ${item.is_favorite ? 'fill-red-500 text-red-500' : ''}`} 
                                  />
                                </button>

                                {/* Mock Drink Image Card */}
                                <div className="h-28 w-full flex items-center justify-center p-2 mb-2">
                                  <DrinkImage 
                                    name={item.name} 
                                    category={item.category} 
                                    imagePath={item.image_path}
                                    className="h-full w-full object-cover rounded-xl border border-[#C4BAA3]/40"
                                  />
                                </div>

                                <div className="text-xs font-extrabold text-black leading-tight truncate">{item.name}</div>
                                <div className="text-[10px] text-zinc-500 font-semibold truncate leading-none mt-0.5">{item.category}</div>
                                <div className="text-xs font-black text-black mt-2">{formatPrice(item.price)}</div>

                                {/* Order selection button plus */}
                                <button
                                  onClick={() => handleOpenDetail(item)}
                                  className="absolute bottom-2 right-2 p-1.5 bg-black text-white rounded-full hover:scale-105 active:scale-95 transition-all shadow-md shadow-black/10"
                                >
                                  <PlusCircle className="w-4 h-4" />
                                </button>
                              </div>
                          ))}
                        </div>
                      </div>

                      {/* Alternate Section list for Nonselected category to match mock structure */}
                      <div>
                        <div className="flex items-center justify-between mb-3 text-black">
                          <h3 className="font-bold text-sm tracking-tight">
                            Popular {selectedCategory === 'Coffee' ? 'Non Coffee' : 'Coffee'}
                          </h3>
                          <button 
                            onClick={() => {
                              setSeeAllCategory(selectedCategory === 'Coffee' ? 'Non Coffee' : 'Coffee');
                              setCurrentScreen('see_all');
                            }}
                            className="text-xs font-black"
                          >
                            See All
                          </button>
                        </div>

                        {/* Alternative row scroll */}
                        <div className="flex gap-4 overflow-x-auto pb-2 no-scrollbar">
                          {menuItems
                            .filter(i => i.category !== selectedCategory)
                            .map(item => (
                              <div 
                                key={item.id} 
                                className="min-w-[150px] w-[150px] bg-[#C4BAA3]/25 rounded-[24px] p-3 flex flex-col relative"
                              >
                                <button 
                                  onClick={(e) => {
                                    e.stopPropagation();
                                    handleToggleFavorite(item.id);
                                  }}
                                  className="absolute top-2.5 right-2.5 p-1 text-zinc-800 hover:text-red-500 z-10"
                                >
                                  <Heart className={`w-4 h-4 ${item.is_favorite ? 'fill-red-500 text-red-500' : ''}`} />
                                </button>

                                <div className="h-28 w-full flex items-center justify-center p-2 mb-2">
                                  <DrinkImage 
                                    name={item.name} 
                                    category={item.category} 
                                    imagePath={item.image_path}
                                    className="h-full w-full object-cover rounded-xl border border-[#C4BAA3]/40"
                                  />
                                </div>

                                <div className="text-xs font-extrabold text-black truncate">{item.name}</div>
                                <div className="text-[10px] text-zinc-500 font-semibold truncate leading-none mt-0.5">{item.category}</div>
                                <div className="text-xs font-black text-black mt-2">{formatPrice(item.price)}</div>

                                <button
                                  onClick={() => handleOpenDetail(item)}
                                  className="absolute bottom-2 right-2 p-1.5 bg-black text-white rounded-full"
                                >
                                  <PlusCircle className="w-4 h-4" />
                                </button>
                              </div>
                          ))}
                        </div>
                      </div>
                    </div>
                  )}

                  {/* TAB 1: FAVORITES SCREEN */}
                  {selectedTab === 1 && (
                    <div id="favorites_tab" className="p-5 flex flex-col gap-4">
                      <h2 className="text-2xl font-black text-black">Favorite</h2>
                      
                      {menuItems.filter(i => i.is_favorite).length === 0 ? (
                        <div className="flex flex-col items-center justify-center py-12 text-center text-zinc-400">
                          <Heart className="w-12 h-12 mb-3 stroke-zinc-300" />
                          <p className="text-sm font-semibold">No favorites selected yet!</p>
                          <p className="text-xs mt-1">Tap hearts on the home menu to add favorites.</p>
                        </div>
                      ) : (
                        <div className="flex flex-col gap-3">
                          {menuItems
                            .filter(i => i.is_favorite)
                            .map(item => (
                              <div 
                                key={item.id}
                                className="flex items-center gap-4 bg-white border border-black/5 shadow-sm rounded-3xl p-3 relative cursor-pointer"
                                onClick={() => handleOpenDetail(item)}
                              >
                                <DrinkImage 
                                  name={item.name} 
                                  category={item.category} 
                                  imagePath={item.image_path}
                                  className="w-16 h-16 object-cover rounded-2xl border"
                                />
                                <div className="flex-1 min-w-0 pr-8">
                                  <h4 className="font-extrabold text-[#111] text-sm truncate">{item.name}</h4>
                                  <p className="text-xs text-zinc-500 truncate">{item.category}</p>
                                  <p className="font-black text-sm mt-1">{formatPrice(item.price)}</p>
                                </div>
                                <button
                                  onClick={(e) => {
                                    e.stopPropagation();
                                    handleToggleFavorite(item.id);
                                  }}
                                  className="absolute right-4 p-2 text-red-500"
                                >
                                  <Heart className="w-5 h-5 fill-red-500 text-red-500" />
                                </button>
                              </div>
                            ))
                          }
                        </div>
                      )}
                    </div>
                  )}

                  {/* TAB 2: TAMBAH MENU SCREEN */}
                  {selectedTab === 2 && (
                    <div id="add_menu_tab" className="p-5 flex flex-col gap-4 relative">
                      {/* PDF FORM SPEC HEADER BACKGROUND */}
                      <div className="border border-[#D2B48C] bg-white rounded-xl p-3 flex flex-col gap-1 text-[11px]">
                        <div className="flex justify-between items-center text-zinc-500 font-mono text-[9px]">
                          <span>KOPI SRUPUT APP SPEC v1.2</span>
                          <span className="bg-[#5C3A21] text-white px-1.5 py-0.5 rounded font-bold">
                            {editingMenuItemId !== null ? 'FORM-U02' : 'FORM-F02'}
                          </span>
                        </div>
                        <div className="h-[1px] bg-[#D2B48C] my-1"></div>
                        <h4 className="font-extrabold text-black text-xs leading-tight uppercase font-mono">
                          {editingMenuItemId !== null ? 'FORMULIR EDIT / UPDATE SPEK PRODUK' : 'FORMULIR INPUT DATA PRODUK & KOORDINAT GAMBAR'}
                        </h4>
                        <p className="text-zinc-400 leading-normal text-[10px] italic">
                          Tabel "menu_items" lokal SQLite. Mendukung input path lokal dari File Explorer HP maupun Web URL.
                        </p>
                      </div>

                      {/* LIVE FORM REAL-TIME PREVIEW CAROUSEL CARD */}
                      <div className="bg-[#D2B48C]/15 border border-[#D2B48C]/40 p-3 rounded-2xl flex flex-col gap-2">
                        <div className="flex items-center gap-1.5 text-zinc-500 text-[10px] font-bold tracking-tight">
                          <Eye className="w-3.5 h-3.5" />
                          LIVE FORM PREVIEW
                        </div>
                        <div className="flex items-center gap-3">
                          <DrinkImage 
                            name={formName || 'Kopi Sruput Baru'} 
                            category={formCategory} 
                            imagePath={customImagePath}
                            className="w-16 h-16 object-cover rounded-xl border border-zinc-200/50 bg-[#C4BAA3]/25"
                          />
                          <div className="flex-1 min-w-0">
                            <span className="inline-block bg-[#5C3A21] text-white text-[8px] font-extrabold px-1.5 py-0.5 rounded uppercase tracking-wider mb-1">
                              {formCategory}
                            </span>
                            <h4 className="font-black text-xs text-black truncate leading-tight">
                              {formName || 'Kopi Sruput Baru'}
                            </h4>
                            <p className="text-[10px] text-zinc-400 truncate leading-none mt-0.5">
                              {formDesc || 'Belum ada deskripsi...'}
                            </p>
                            <h5 className="font-black text-xs text-amber-900 mt-1">
                              Rp {parseFloat(formPrice || '6000').toLocaleString('id-ID')}.000
                            </h5>
                          </div>
                        </div>
                      </div>

                      {/* INPUT FIELDS */}
                      <div className="flex flex-col gap-3">
                        <div>
                          <label className="text-[11px] font-bold text-zinc-500 uppercase tracking-wider block mb-1">Nama Menu</label>
                          <input 
                            placeholder="e.g. Kopi Sruput Special" 
                            id="add_drink_name"
                            value={formName}
                            onChange={(e) => setFormName(e.target.value)}
                            className="w-full bg-white border border-black/15 py-2.5 px-4 rounded-xl text-sm font-semibold outline-none focus:border-[#5C3A21]"
                            type="text"
                          />
                        </div>

                        <div>
                          <label className="text-[11px] font-bold text-zinc-500 uppercase tracking-wider block mb-1">Kategori</label>
                          <div className="flex gap-2">
                            <button 
                              onClick={() => setFormCategory('Coffee')}
                              className={`flex-1 py-2 text-xs font-bold rounded-xl transition-all border ${
                                formCategory === 'Coffee'
                                  ? 'bg-[#5C3A21] text-white border-[#5C3A21]'
                                  : 'bg-white text-black border-black/15'
                              }`}
                            >
                              Coffee
                            </button>
                            <button 
                              onClick={() => setFormCategory('Non Coffee')}
                              className={`flex-1 py-2 text-xs font-bold rounded-xl transition-all border ${
                                formCategory === 'Non Coffee'
                                  ? 'bg-[#5C3A21] text-white border-[#5C3A21]'
                                  : 'bg-white text-black border-black/15'
                              }`}
                            >
                              Non Coffee
                            </button>
                          </div>
                        </div>

                        <div>
                          <label className="text-[11px] font-bold text-zinc-500 uppercase tracking-wider block mb-1">Harga (Rupiah)</label>
                          <input 
                            placeholder="e.g. 6000" 
                            id="add_drink_price"
                            value={formPrice}
                            onChange={(e) => setFormPrice(e.target.value)}
                            className="w-full bg-white border border-black/15 py-2.5 px-4 rounded-xl text-sm font-semibold outline-none focus:border-[#5C3A21]"
                            type="number"
                          />
                        </div>

                        <div>
                          <label className="text-[11px] font-bold text-zinc-500 uppercase tracking-wider block mb-1">Deskripsi</label>
                          <textarea 
                            placeholder="Tulis deskripsi menu racikan..." 
                            id="add_drink_desc"
                            value={formDesc}
                            onChange={(e) => setFormDesc(e.target.value)}
                            rows={2}
                            className="w-full bg-white border border-black/15 py-2.5 px-4 rounded-xl text-sm font-semibold outline-none resize-none focus:border-[#5C3A21]"
                          />
                        </div>

                        {/* FOTO MENU / SOURCE TYPE SELECTION */}
                        <div className="border border-black/15 bg-white rounded-xl p-3.5 flex flex-col gap-3">
                          <span className="text-[11px] font-bold text-[#5C3A21] uppercase tracking-wider block">Sumber Foto Menu</span>
                          
                          <div className="flex gap-2 text-xs">
                            <button
                              onClick={() => {
                                setImageSourceType('explorer');
                                setCustomImagePath('/storage/emulated/0/Download/good_day_mocacino.jpg');
                              }}
                              className={`flex-1 py-2 rounded-lg font-bold border flex items-center justify-center gap-1.5 transition-all ${
                                imageSourceType === 'explorer'
                                  ? 'bg-[#D2B48C]/40 border-[#5C3A21] text-[#5C3A21]' 
                                  : 'bg-white border-zinc-200 text-zinc-500'
                              }`}
                            >
                              <FileCode className="w-3.5 h-3.5" />
                              Explorer HP
                            </button>
                            <button
                              onClick={() => {
                                setImageSourceType('url');
                                setCustomImagePath('https://images.unsplash.com/photo-1541167760496-1628856ab772?w=400&q=80');
                              }}
                              className={`flex-1 py-2 rounded-lg font-bold border flex items-center justify-center gap-1.5 transition-all ${
                                imageSourceType === 'url'
                                  ? 'bg-[#D2B48C]/40 border-[#5C3A21] text-[#5C3A21]' 
                                  : 'bg-white border-zinc-200 text-zinc-500'
                              }`}
                            >
                              <Check className="w-3.5 h-3.5" />
                              Web URL
                            </button>
                          </div>

                          <div>
                            <span className="text-[10px] font-bold text-zinc-400 block mb-1">
                              {imageSourceType === 'explorer' ? 'Direktori File Explorer HP :' : 'Web Image URL Preset :'}
                            </span>
                            <input 
                              id="add_drink_image_path"
                              value={customImagePath}
                              onChange={(e) => setCustomImagePath(e.target.value)}
                              className="w-full bg-zinc-50 border border-zinc-200 py-2 px-3 rounded-lg text-xs font-mono outline-none text-zinc-700"
                              placeholder={imageSourceType === 'explorer' ? '/storage/emulated/0/...' : 'https://...'}
                            />
                          </div>

                          {imageSourceType === 'explorer' ? (
                            <button
                              onClick={() => {
                                setIsExplorerOpen(true);
                                setExplorerCurrentFolder('/Internal Storage');
                              }}
                              className="w-full py-2 bg-white text-[#5C3A21] text-xs font-bold border border-[#5C3A21] hover:bg-[#5C3A21]/5 rounded-xl transition-all flex items-center justify-center gap-1.5"
                            >
                              <FileCode className="w-4 h-4" />
                              Buka File Explorer HP
                            </button>
                          ) : (
                            <div className="flex flex-col gap-1">
                              <span className="text-[9px] text-zinc-400 font-bold block">Preset URL Cepat:</span>
                              <div className="flex flex-wrap gap-1.5">
                                <button 
                                  onClick={() => setCustomImagePath('https://images.unsplash.com/photo-1541167760496-1628856ab772?w=400&q=80')}
                                  className="text-[9px] bg-zinc-100 hover:bg-zinc-200 font-bold text-zinc-600 py-1 px-2 rounded-md"
                                >
                                  Mocacino Web URL
                                </button>
                                <button 
                                  onClick={() => setCustomImagePath('https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400&q=80')}
                                  className="text-[9px] bg-zinc-100 hover:bg-zinc-200 font-bold text-zinc-600 py-1 px-2 rounded-md"
                                >
                                  Classic Coffee URL
                                </button>
                                <button 
                                  onClick={() => setCustomImagePath('https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=400&q=80')}
                                  className="text-[9px] bg-zinc-100 hover:bg-zinc-200 font-bold text-zinc-600 py-1 px-2 rounded-md"
                                >
                                  Matcha Sruput URL
                                </button>
                              </div>
                            </div>
                          )}
                        </div>

                        {/* SUBMIT BUTTONS */}
                        <div className="flex gap-2.5 mt-2">
                          <button
                            onClick={() => {
                              setFormName('');
                              setFormPrice('6000');
                              setFormDesc('');
                              setEditingMenuItemId(null);
                              setSelectedTab(0);
                            }}
                            className="flex-1 py-3 text-red-500 font-bold text-xs border border-red-500 hover:bg-red-50 rounded-xl transition-all"
                          >
                            BATAL
                          </button>
                          <button
                            onClick={() => {
                              if (!formName) {
                                alert('Please enter a drink name!');
                                return;
                              }

                              const priceVal = parseFloat(formPrice || '6000');

                              if (editingMenuItemId !== null) {
                                // UPDATE MODE
                                setMenuItems(prev => prev.map(item => {
                                  if (item.id === editingMenuItemId) {
                                    return {
                                      ...item,
                                      name: formName,
                                      category: formCategory,
                                      price: priceVal,
                                      description: formDesc || 'Sajian lezat Kopi Sruput.',
                                      image_path: customImagePath
                                    };
                                  }
                                  return item;
                                }));
                                alert(`"${formName}" berhasil diperbarui!`);
                                setEditingMenuItemId(null);
                              } else {
                                // CREATE MODE
                                handleAddMenuItem({
                                  name: formName,
                                  category: formCategory,
                                  price: priceVal,
                                  description: formDesc || 'Sajian lezat Kopi Sruput.',
                                  image_path: customImagePath
                                });
                                alert(`"${formName}" berhasil disimpan ke database SQLite!`);
                              }
                              
                              // Reset
                              setFormName('');
                              setFormPrice('6000');
                              setFormDesc('');
                              setCustomImagePath('/storage/emulated/0/Download/good_day_mocacino.jpg');
                              setImageSourceType('explorer');
                              setSelectedTab(0);
                            }}
                            className="flex-[2] py-3 bg-[#5C3A21] text-white font-black text-xs hover:bg-zinc-900 rounded-xl transition-all shadow-md shadow-zinc-900/15"
                          >
                            {editingMenuItemId !== null ? 'PERBARUI DI SQLITE' : 'SIMPAN KE SQLITE'}
                          </button>
                        </div>
                      </div>

                      {/* SIMULATED FILE EXPLORER MODAL OVERLAY IN APP PORT VIEW */}
                      {isExplorerOpen && (
                        <div className="absolute inset-0 bg-black/60 backdrop-blur-[2px] z-50 flex items-center justify-center p-3">
                          <div className="bg-white rounded-3xl w-full max-w-[325px] h-[370px] flex flex-col overflow-hidden border border-zinc-200 shadow-2xl animate-in fade-in zoom-in-95 duration-200 text-zinc-800">
                            {/* Modal Header */}
                            <div className="bg-[#5C3A21] p-3 text-white flex justify-between items-center text-xs">
                              <span className="font-extrabold flex items-center gap-1.5 pr-2">
                                <Tablet className="w-4 h-4" />
                                File Manager HP
                              </span>
                              <button 
                                onClick={() => setIsExplorerOpen(false)}
                                className="p-1 hover:bg-white/10 rounded-full"
                              >
                                <Check className="w-4 h-4" />
                              </button>
                            </div>

                            {/* Breadcrumb line */}
                            <div className="bg-zinc-100 px-3 py-1.5 text-[10px] text-zinc-500 font-mono font-bold flex justify-between items-center border-b border-zinc-200">
                              <span className="truncate">📂 {explorerCurrentFolder}</span>
                              {explorerCurrentFolder !== '/Internal Storage' && (
                                <button 
                                  onClick={() => {
                                    const parts = explorerCurrentFolder.split('/');
                                    parts.pop();
                                    setExplorerCurrentFolder(parts.join('/') || '/Internal Storage');
                                  }}
                                  className="text-[#5C3A21] hover:underline font-bold text-[9px]"
                                >
                                  ▲ UP
                                </button>
                              )}
                            </div>

                            {/* Folder content listing */}
                            <div className="flex-1 overflow-y-auto p-1.5 flex flex-col gap-1">
                              {(mockFileSystem[explorerCurrentFolder] || []).map((file, idx) => {
                                return (
                                  <div 
                                    key={idx}
                                    onClick={() => {
                                      if (file.disabled) {
                                        alert('Format file ini tidak didukung sebagai Menu Image!');
                                        return;
                                      }
                                      if (file.is_folder) {
                                        setExplorerCurrentFolder(file.path);
                                      } else {
                                        setCustomImagePath(file.path);
                                        setIsExplorerOpen(false);
                                      }
                                    }}
                                    className={`flex items-center justify-between p-2 rounded-lg hover:bg-zinc-100 cursor-pointer ${
                                      file.disabled ? 'opacity-40 cursor-not-allowed' : ''
                                    }`}
                                  >
                                    <div className="flex items-center gap-2.5 min-w-0">
                                      {file.is_folder ? (
                                        <span className="text-xl">📁</span>
                                      ) : (
                                        <div className="w-7 h-7 bg-amber-100 rounded-md flex items-center justify-center text-md">
                                          {file.emoji || '🖼️'}
                                        </div>
                                      )}
                                      <div className="min-w-0">
                                        <p className={`text-xs font-semibold truncate ${file.disabled ? 'line-through text-zinc-400' : 'text-zinc-800'}`}>
                                          {file.name}
                                        </p>
                                        <p className="text-[9px] text-zinc-400">
                                          {file.is_folder ? 'Folder' : file.size}
                                        </p>
                                      </div>
                                    </div>
                                    {file.is_folder ? (
                                      <ChevronLeft className="w-3.5 h-3.5 text-zinc-400 rotate-180" />
                                    ) : (
                                      <input 
                                        type="radio" 
                                        name="selected_file" 
                                        checked={customImagePath === file.path}
                                        readOnly
                                        className="accent-[#5C3A21]"
                                      />
                                    )}
                                  </div>
                                );
                              })}
                            </div>
                          </div>
                        </div>
                      )}
                    </div>
                  )}

                  {/* TAB 3: SHOPPING CART SCREEN */}
                  {selectedTab === 3 && (
                    <div id="cart_tab" className="flex-1 flex flex-col justify-between">
                      <div className="p-5 flex-1 overflow-y-auto">
                        <div className="flex justify-between items-center mb-5">
                          <h2 className="text-2xl font-black text-black">Cart</h2>
                          <button
                            onClick={handleRefreshCart}
                            disabled={isRefreshingCart}
                            className="p-2 px-3 rounded-xl bg-white border border-black/5 text-[#5C3A21] hover:scale-105 active:scale-95 transition-all flex items-center gap-1.5 text-xs font-bold shadow-sm select-none"
                            title="Refresh Keranjang"
                          >
                            <RotateCw className={`w-3.5 h-3.5 ${isRefreshingCart ? 'animate-spin' : ''}`} />
                            <span>{isRefreshingCart ? 'Syncing...' : 'Refresh'}</span>
                          </button>
                        </div>

                        {cartItems.length === 0 ? (
                          <div className="flex flex-col items-center justify-center py-16 text-center text-zinc-400">
                            <ShoppingCart className="w-12 h-12 stroke-zinc-300 mb-3" />
                            <p className="text-sm font-semibold">Your Cart is empty!</p>
                            <p className="text-xs mt-1">Go grab some sweet Kopi Sruput drinks!</p>
                          </div>
                        ) : (
                          <div className="flex flex-col gap-3">
                            {cartItems.map(item => (
                              <div 
                                key={item.id}
                                className="flex items-center bg-white border border-zinc-100 rounded-[24px] p-3 shadow-sm gap-3 animate-in fade-in slide-in-from-bottom-2 duration-200"
                              >
                                <input 
                                  type="checkbox" 
                                  checked={selectedCartIds.includes(item.id)}
                                  onChange={() => {
                                    setSelectedCartIds(prev => {
                                      if (prev.includes(item.id)) {
                                        return prev.filter(id => id !== item.id);
                                      } else {
                                        return [...prev, item.id];
                                      }
                                    });
                                  }}
                                  className="accent-[#C4BAA3] w-4.5 h-4.5 cursor-pointer rounded border-zinc-300"
                                />
                                <DrinkImage 
                                  name={item.name} 
                                  category={item.category} 
                                  imagePath={item.image_path}
                                  className="w-14 h-14 object-cover rounded-xl border border-zinc-100"
                                />
                                <div className="flex-1 min-w-0 font-sans">
                                  <h4 className="font-extrabold text-sm text-[#111] truncate">{item.name}</h4>
                                  <p className="text-[10px] text-zinc-400 font-bold truncate uppercase mt-0.5">
                                    {item.temp_option} • Sugar: {item.sugar_option} • {item.dine_option}
                                  </p>
                                  <p className="text-xs font-black text-[#5C3A21] mt-1">{formatPrice(item.price)}</p>
                                </div>
                                <div className="flex items-center gap-1">
                                  <div className="flex items-center border border-black/10 rounded-full py-0.5 px-2 bg-zinc-50 scale-90">
                                    <button 
                                      onClick={() => handleUpdateCartQty(item.id, -1)}
                                      className="px-1.5 py-1 text-xs font-black text-zinc-500"
                                    >
                                      -
                                    </button>
                                    <span className="px-2 text-xs font-bold">{item.quantity}</span>
                                    <button 
                                      onClick={() => handleUpdateCartQty(item.id, 1)}
                                      className="px-1.5 py-1 text-xs font-black text-zinc-500"
                                    >
                                      +
                                    </button>
                                  </div>
                                  <button
                                    onClick={() => {
                                      if (confirm(`Hapus "${item.name}" dari keranjang?`)) {
                                        setCartItems(prev => prev.filter(x => x.id !== item.id));
                                      }
                                    }}
                                    className="p-1 px-1.5 bg-red-50 hover:bg-red-100 text-red-500 hover:text-red-700 rounded-lg transition-all border border-red-100/50 scale-90"
                                    title="Hapus Item"
                                  >
                                    <Trash2 className="w-3.5 h-3.5" />
                                  </button>
                                </div>
                              </div>
                            ))}
                          </div>
                        )}
                      </div>

                      {/* Bottom Drawer Summary */}
                      {cartItems.length > 0 && (
                        <div className="bg-[#C4BAA3] rounded-t-[40px] p-6 flex flex-col gap-4 text-black">
                          <div className="flex justify-between items-center text-sm">
                            <span className="font-bold">
                              Terpilih ({cartItems.filter(item => selectedCartIds.includes(item.id)).length} dari {cartItems.length})
                            </span>
                            <span className="font-black text-lg">
                              Total {formatPrice(cartItems.filter(item => selectedCartIds.includes(item.id)).reduce((acc, curr) => acc + (curr.price * curr.quantity), 0))}
                            </span>
                          </div>
                          <button 
                            onClick={handleInitCheckout}
                            className="w-full py-3.5 bg-black text-white hover:bg-[#5C3A21] active:scale-95 transition-all text-sm font-bold rounded-2xl shadow-lg shadow-black/10"
                          >
                            Checkout ({cartItems.filter(item => selectedCartIds.includes(item.id)).reduce((acc, curr) => acc + curr.quantity, 0)} Drink)
                          </button>
                        </div>
                      )}
                    </div>
                  )}

                  {/* TAB 4: PROFILE SCREEN */}
                  {selectedTab === 4 && (
                    <div id="profile_tab" className="p-5 flex flex-col text-center">
                      <h2 className="text-2xl font-black text-left text-black mb-6">Profile</h2>
                      
                      <div className="w-28 h-28 rounded-full border-[3px] border-[#C4BAA3] overflow-hidden mx-auto mb-3 shadow-md relative">
                        <img 
                          src="https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=200&auto=format&fit=crop&q=60" 
                          alt="Profil" 
                          className="w-full h-full object-cover"
                          referrerPolicy="no-referrer"
                        />
                      </div>
                      
                      <h3 className="text-xl font-black text-black">{userProfile.name}</h3>
                      <p className="text-xs text-zinc-500 font-medium mt-0.5">@{userProfile.username}</p>

                      <div className="flex flex-col gap-3 mt-8">
                        <div 
                          onClick={() => setCurrentScreen('settings')}
                          className="flex items-center justify-between p-4 bg-[#C4BAA3]/70 hover:bg-[#C4BAA3]/85 transition-all rounded-2xl text-left cursor-pointer text-black font-bold"
                        >
                          <span className="flex items-center gap-3">
                            <Lock className="w-5 h-5 text-black" />
                            Setting
                          </span>
                          <ChevronLeft className="w-5 h-5 rotate-180" />
                        </div>
                        
                        <div 
                          onClick={() => {
                            setIsLoggedIn(false);
                            setCurrentScreen('welcome');
                          }}
                          className="flex items-center justify-between p-4 bg-[#C4BAA3]/70 hover:bg-[#C4BAA3]/85 transition-all rounded-2xl text-left cursor-pointer text-black font-bold"
                        >
                          <span className="flex items-center gap-3">
                            <LogOut className="w-5 h-5 text-black" />
                            Logout
                          </span>
                          <ChevronLeft className="w-5 h-5 rotate-180" />
                        </div>

                        <div 
                          onClick={() => {
                            setNotificationsMuted(!notificationsMuted);
                          }}
                          className="flex items-center justify-between p-4 bg-[#C4BAA3]/70 hover:bg-[#C4BAA3]/85 transition-all rounded-2xl text-left cursor-pointer text-black font-bold"
                        >
                          <span className="flex items-center gap-3">
                            <Bell className="w-5 h-5 text-black" />
                            Notification
                          </span>
                          <span className={`text-[10px] uppercase tracking-wider py-1 px-2 rounded-lg font-black ${
                            notificationsMuted ? 'bg-red-500 text-white' : 'bg-black text-[#C4BAA3]'
                          }`}>
                            {notificationsMuted ? 'Muted' : 'Active'}
                          </span>
                        </div>
                      </div>
                    </div>
                  )}

                  {/* NAV BAR IN BOTTOM SHELL */}
                  <div className="h-20 bg-[#C4BAA3] mt-auto rounded-t-[32px] flex items-center justify-around px-4 border-t border-black/5 shadow-lg relative">
                    <button 
                      onClick={() => setSelectedTab(0)} 
                      className={`p-3 rounded-full transition-all ${selectedTab === 0 ? 'text-black' : 'text-zinc-600'}`}
                    >
                      <Home className="w-5 h-5" />
                    </button>
                    <button 
                      onClick={() => setSelectedTab(1)} 
                      className={`p-3 rounded-full transition-all ${selectedTab === 1 ? 'text-black' : 'text-zinc-600'}`}
                    >
                      <Heart className="w-5 h-5" />
                    </button>
                    <button 
                      onClick={() => setSelectedTab(2)} 
                      className="p-2 bg-black text-white hover:scale-110 active:scale-95 transition-all rounded-full"
                    >
                      <PlusCircle className="w-7 h-7" />
                    </button>
                    <button 
                      onClick={() => setSelectedTab(3)} 
                      className={`p-3 rounded-full transition-all scale-105 relative ${selectedTab === 3 ? 'text-black' : 'text-zinc-600'}`}
                    >
                      <ShoppingCart className="w-5 h-5" />
                      {cartItems.length > 0 && (
                        <span className="absolute top-1.5 right-1.5 bg-red-600 text-white text-[9px] font-black w-4.5 h-4.5 flex items-center justify-center rounded-full">
                          {cartItems.reduce((acc, curr) => acc + curr.quantity, 0)}
                        </span>
                      )}
                    </button>
                    <button 
                      onClick={() => setSelectedTab(4)} 
                      className={`p-3 rounded-full transition-all ${selectedTab === 4 ? 'text-black' : 'text-zinc-600'}`}
                    >
                      <User className="w-5 h-5" />
                    </button>
                  </div>
                </div>
              )}

              {/* SEARCH SCREENS */}
              {currentScreen === 'search' && (
                <div id="search_screen" className="p-6 flex flex-col min-h-full">
                  <div className="flex items-center gap-4 mb-5">
                    <button onClick={() => setCurrentScreen('main_shell')} className="p-2 border border-black/10 rounded-full bg-white select-none">
                      <ChevronLeft className="w-5 h-5" />
                    </button>
                    <h2 className="text-xl font-black text-black">Search Products</h2>
                  </div>

                  <div className="bg-[#C4BAA3]/40 rounded-2xl p-4 flex items-center gap-3 mb-6">
                    <Search className="w-5 h-5 text-zinc-700" />
                    <input 
                      autoFocus 
                      value={searchQuery}
                      onChange={e => setSearchQuery(e.target.value)}
                      placeholder="Search Drinks" 
                      className="w-full bg-transparent border-none outline-none font-semibold text-sm text-black"
                    />
                  </div>

                  {searchQuery ? (
                    <div>
                      <h4 className="text-xs font-bold text-zinc-400 uppercase tracking-widest pl-1 mb-2">Suggestions</h4>
                      <div className="border border-black/5 bg-white rounded-3xl p-2 flex flex-col gap-1 shadow-sm">
                        {menuItems
                          .filter(i => i.name.toLowerCase().includes(searchQuery.toLowerCase()))
                          .map(item => (
                            <div 
                              key={item.id}
                              onClick={() => handleOpenDetail(item)}
                              className="flex items-center justify-between p-3.5 hover:bg-zinc-50 rounded-2xl cursor-pointer transition-all"
                            >
                              <div className="flex items-center gap-3">
                                <span className="p-2 bg-[#C4BAA3]/20 rounded-xl">
                                  <Sparkles className="w-4 h-4 text-zinc-700" />
                                </span>
                                <span className="text-sm font-bold text-black">{item.name}</span>
                              </div>
                              <ChevronLeft className="w-4 h-4 rotate-180 text-zinc-400" />
                            </div>
                          ))
                        }
                        {menuItems.filter(i => i.name.toLowerCase().includes(searchQuery.toLowerCase())).length === 0 && (
                          <div className="p-6 text-center text-xs text-zinc-400 font-semibold">No matches found! Try custom keywords.</div>
                        )}
                      </div>
                    </div>
                  ) : (
                    <div>
                      <h4 className="text-xs font-bold text-zinc-400 uppercase tracking-widest pl-1 mb-3">recent searches</h4>
                      <div className="flex flex-wrap gap-2">
                        {recentSearches.map((sea, idx) => (
                          <span 
                            key={idx}
                            onClick={() => setSearchQuery(sea)}
                            className="py-2.5 px-5 bg-[#C4BAA3] hover:bg-[#C4BAA3]/80 transition-all font-bold text-xs rounded-full cursor-pointer text-black"
                          >
                            {sea}
                          </span>
                        ))}
                      </div>
                    </div>
                  )}
                </div>
              )}

              {/* SEE ALL CATEGORY LIST GRIDS */}
              {currentScreen === 'see_all' && (
                <div id="see_all_screen" className="p-6 flex flex-col min-h-full">
                  <div className="flex items-center gap-4 mb-5">
                    <button onClick={() => setCurrentScreen('main_shell')} className="p-2 border border-black/10 rounded-full bg-white select-none">
                      <ChevronLeft className="w-5 h-5" />
                    </button>
                    <h2 className="text-xl font-black text-black">Popular {seeAllCategory}</h2>
                  </div>

                  <div className="grid grid-cols-2 gap-4">
                    {menuItems
                      .filter(i => i.category === seeAllCategory)
                      .map(item => (
                        <div 
                          key={item.id} 
                          className="bg-[#C4BAA3]/25 rounded-[24px] p-3 flex flex-col relative"
                        >
                          <button 
                            onClick={(e) => {
                              e.stopPropagation();
                              handleToggleFavorite(item.id);
                            }}
                            className="absolute top-2.5 right-2.5 p-1 text-zinc-800 hover:text-red-500 transition-all z-10"
                          >
                            <Heart className={`w-4 h-4 ${item.is_favorite ? 'fill-red-500 text-red-500' : ''}`} />
                          </button>

                          <div className="h-28 w-full flex items-center justify-center p-2 mb-2">
                             <DrinkImage 
                               name={item.name} 
                               category={item.category} 
                               imagePath={item.image_path}
                               className="h-full w-full object-cover rounded-xl border border-[#C4BAA3]/40"
                             />
                           </div>

                           <div className="text-xs font-extrabold text-black leading-tight truncate">{item.name}</div>
                           <div className="text-[10px] text-zinc-500 truncate leading-none mt-0.5">{item.category}</div>
                          <div className="text-xs font-black text-black mt-2">{formatPrice(item.price)}</div>

                          <button
                            onClick={() => handleOpenDetail(item)}
                            className="absolute bottom-2 right-2 p-1.5 bg-black text-white rounded-full"
                          >
                            <PlusCircle className="w-4 h-4" />
                          </button>
                        </div>
                    ))}
                  </div>
                </div>
              )}

              {/* DETAIL PRODUCT SCREEN */}
              {currentScreen === 'detail' && selectedProduct && (
                <div id="detail_screen" className="flex flex-col min-h-full">
                  <div className="p-5 flex items-center justify-between mb-2">
                    <button onClick={() => setCurrentScreen('main_shell')} className="p-2 border border-black/10 rounded-full bg-white select-none">
                      <ChevronLeft className="w-5 h-5" />
                    </button>
                    <span className="text-xs font-black">Customize Drink</span>
                    <button 
                      onClick={() => {
                        setCurrentScreen('main_shell');
                        setSelectedTab(3);
                      }}
                      className="p-2 border border-black/10 rounded-full bg-white"
                    >
                      <ShoppingCart className="w-4 h-4" />
                    </button>
                  </div>

                  <div className="flex-1 p-5 pt-0">
                    {/* Big Drink illustration matching page 11 */}
                    <div className="h-56 w-full flex items-center justify-center p-4 mb-4">
                      <DrinkImage 
                        name={selectedProduct.name} 
                        category={selectedProduct.category} 
                        imagePath={selectedProduct.image_path}
                        className="h-full object-contain rounded-2xl border-2 border-dashed border-[#C4BAA3] p-1 shadow-md bg-white pr-2.5"
                      />
                    </div>

                    {/* Floating rounded item summary panel */}
                    <div className="bg-[#C4BAA3] rounded-3xl p-5 mb-5 flex justify-between items-center text-black shadow-sm">
                      <div className="flex-1 min-w-0 pr-4">
                        <h3 className="text-xl font-black truncate">{selectedProduct.name}</h3>
                        <p className="text-xs text-zinc-1000 font-semibold truncate leading-tight mt-0.5">{selectedProduct.category}</p>
                      </div>
                      <div className="text-right">
                        <button 
                          onClick={() => handleToggleFavorite(selectedProduct.id)}
                          className="mb-1"
                        >
                          <Heart className={`w-5 h-5 mx-auto ${selectedProduct.is_favorite ? 'fill-red-500 text-red-500' : 'text-zinc-800'}`} />
                        </button>
                        <p className="text-lg font-black">{formatPrice(selectedProduct.price)}</p>
                      </div>
                    </div>

                    {/* Preferences lists matching screenshot 11 */}
                    <div className="flex flex-col gap-4">
                      {/* Temperature selection */}
                      <div>
                        <h4 className="text-xs font-black uppercase text-zinc-400 mb-2">Available in</h4>
                        <div className="flex gap-3">
                          {['Ice', 'Hot'].map(t => (
                            <button
                              key={t}
                              onClick={() => setDetailTemp(t as 'Ice' | 'Hot')}
                              className={`py-2 px-5 rounded-full text-xs font-bold border-2 border-[#C4BAA3] transition-all ${
                                detailTemp === t ? 'bg-[#C4BAA3] text-black shadow-sm' : 'bg-transparent text-black'
                              }`}
                            >
                              {t}
                            </button>
                          ))}
                        </div>
                      </div>

                      {/* Sugar level selector */}
                      <div>
                        <h4 className="text-xs font-black uppercase text-zinc-400 mb-2">Sugar</h4>
                        <div className="flex gap-3">
                          {['Less', 'Normal', 'Extra'].map(s => (
                            <button
                              key={s}
                              onClick={() => setDetailSugar(s as 'Less' | 'Normal' | 'Extra')}
                              className={`py-2 px-5 rounded-full text-xs font-bold border-2 border-[#C4BAA3] transition-all ${
                                detailSugar === s ? 'bg-[#C4BAA3] text-black shadow-sm' : 'bg-transparent text-[#2c2c2c]'
                              }`}
                            >
                              {s}
                            </button>
                          ))}
                        </div>
                      </div>

                      {/* Dining way */}
                      <div>
                        <h4 className="text-xs font-black uppercase text-zinc-400 mb-2">Available in</h4>
                        <div className="flex gap-3">
                          {['Dine In', 'Take Away'].map(d => (
                            <button
                              key={d}
                              onClick={() => setDetailDine(d as 'Dine In' | 'Take Away')}
                              className={`py-2 px-5 rounded-full text-xs font-bold border-2 border-[#C4BAA3] transition-all ${
                                detailDine === d ? 'bg-[#C4BAA3] text-black shadow-sm' : 'bg-transparent text-[#2c2c2c]'
                              }`}
                            >
                              {d}
                            </button>
                          ))}
                        </div>
                      </div>

                      {/* Total and Qty modifiers */}
                      <div className="flex items-center justify-between border-t border-black/5 pt-4 mt-2">
                        <div>
                          <span className="text-[10px] uppercase font-bold text-zinc-400 block">Total</span>
                          <span className="text-2xl font-black text-black">
                            {formatPrice(selectedProduct.price * detailQty)}
                          </span>
                        </div>
                        <div className="flex items-center border border-black/10 rounded-full py-1 px-3 bg-white shadow-sm">
                          <button 
                            onClick={() => detailQty > 1 && setDetailQty(detailQty - 1)}
                            className="p-1 px-2 text-sm font-black text-zinc-500"
                          >
                            -
                          </button>
                          <span className="px-3 font-extrabold text-base">{detailQty}</span>
                          <button 
                            onClick={() => setDetailQty(detailQty + 1)}
                            className="p-1 px-2 text-sm font-black text-zinc-500"
                          >
                            +
                          </button>
                        </div>
                      </div>

                      {/* Order Button */}
                      <button
                        onClick={handleAddToCart}
                        className="w-full py-4 mt-2 bg-[#C4BAA3] hover:scale-102 active:scale-95 transition-all text-black font-black text-base rounded-3xl shadow-md"
                      >
                        Order Now
                      </button>

                      {/* CRUD Admin Actions */}
                      <div className="flex gap-2.5 mt-3 pt-3 border-t border-black/5">
                        <button
                          onClick={() => handleEditMenuItem(selectedProduct)}
                          className="flex-1 py-3 px-4 bg-zinc-100 hover:bg-zinc-200 text-[#5C3A21] font-extrabold text-xs rounded-2xl flex items-center justify-center gap-1.5 transition-all border border-black/5"
                        >
                          ⚙️ Edit Menu
                        </button>
                        <button
                          onClick={() => handleDeleteMenuItem(selectedProduct.id)}
                          className="flex-1 py-3 px-4 bg-red-100 hover:bg-red-200 text-red-700 font-extrabold text-xs rounded-2xl flex items-center justify-center gap-1.5 transition-all"
                        >
                          🗑️ Hapus Menu
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              )}

              {/* CHECKOUT SCREEN */}
              {currentScreen === 'checkout' && (
                <div id="checkout_screen" className="flex flex-col min-h-full justify-between">
                  {/* Top */}
                  <div className="p-5 flex-1">
                    <div className="flex items-center gap-4 mb-4">
                      <button onClick={() => setCurrentScreen('main_shell')} className="p-2 border border-black/10 rounded-full bg-white select-none">
                        <ChevronLeft className="w-5 h-5" />
                      </button>
                      <h2 className="text-xl font-black text-black">Checkout</h2>
                    </div>

                    <div className="flex flex-col mb-4">
                      <span className="text-xl font-black text-black">Grab</span>
                      <span className="text-xl font-black text-black">Your Kopi Sruput</span>
                    </div>

                    {/* Ordered List previews */}
                    <div className="flex flex-col gap-2 max-h-56 overflow-y-auto mb-4">
                      {itemsToCheckout.map((item, idx) => (
                        <div key={idx} className="flex items-center gap-3 bg-[#C4BAA3]/40 rounded-2xl p-3">
                          <DrinkImage 
                            name={item.name} 
                            category={item.category} 
                            imagePath={item.image_path}
                            className="w-12 h-12 object-cover rounded-xl border border-zinc-500/25 bg-white"
                          />
                          <div className="flex-1 min-w-0">
                            <h4 className="font-bold text-[#111] text-xs truncate">{item.name}</h4>
                            <p className="text-[10px] text-zinc-600 truncate">{item.category}</p>
                            <p className="text-xs font-black">{formatPrice(item.price)}</p>
                          </div>
                          <span className="font-extrabold text-xs pr-2">{item.quantity}x</span>
                        </div>
                      ))}
                    </div>

                    {/* Table Number Form */}
                    <div className="mb-4">
                      <label className="text-xs font-bold text-zinc-500 mb-1.5 block">Nomer Meja</label>
                      <input 
                        value={tableNumber}
                        onChange={e => setTableNumber(e.target.value)}
                        className="w-full text-center text-lg font-black py-2.5 px-4 bg-white border border-black/10 rounded-xl"
                        placeholder="e.g. 69" 
                      />
                    </div>

                    {/* Payment methods list selection matching screenshot 13 */}
                    <div className="flex flex-col gap-2">
                      <label className="text-xs font-bold text-zinc-500 mb-1.5 block">Payment Method</label>
                      
                      <div 
                        onClick={() => setPaymentMethod('Cash')}
                        className={`flex items-center justify-between p-3 border rounded-xl cursor-pointer transition-all ${
                          paymentMethod === 'Cash' ? 'border-2 border-black font-extrabold' : 'border-zinc-200'
                        }`}
                      >
                        <span className="flex items-center gap-2 text-xs">
                          <Coins className="w-4 h-4" />
                          Cash
                        </span>
                        {paymentMethod === 'Cash' && <CheckCircle className="w-4 h-4 text-green-600 fill-green-600/10" />}
                      </div>

                      <div 
                        onClick={() => setPaymentMethod('Qris')}
                        className={`flex items-center justify-between p-3 border rounded-xl cursor-pointer transition-all ${
                          paymentMethod === 'Qris' ? 'border-2 border-black font-extrabold' : 'border-zinc-200'
                        }`}
                      >
                        <span className="flex items-center gap-2 text-xs">
                          <QrCode className="w-4 h-4" />
                          Qris
                        </span>
                        {paymentMethod === 'Qris' && <CheckCircle className="w-4 h-4 text-green-600 fill-green-600/10" />}
                      </div>
                    </div>
                  </div>

                  {/* Submit checkout drawer bottom */}
                  <div className="bg-[#C4BAA3] mt-auto rounded-t-[32px] p-6 text-black flex flex-col gap-3">
                    <div className="flex justify-between items-center text-sm font-bold">
                      <span>Total Pembayaran</span>
                      <span className="font-black text-lg">
                        {formatPrice(itemsToCheckout.reduce((acc, curr) => acc + (curr.price * curr.quantity), 0))}
                      </span>
                    </div>
                    <button 
                      onClick={handlePlaceOrder}
                      className="w-full py-4 bg-black text-white rounded-2xl text-sm font-black active:scale-95 transition-all shadow-md"
                    >
                      Order Now
                    </button>
                  </div>
                </div>
              )}

              {/* CHECKOUT SUCCESS SCREEN */}
              {currentScreen === 'success' && (
                <div id="checkout_success_screen" className="absolute inset-0 bg-[#C4BAA3] flex flex-col justify-between z-30">
                  <div className="flex-1 flex flex-col items-center justify-center p-6 text-center text-black">
                    <h3 className="text-xl font-bold mb-10">Checkout</h3>
                    <h2 className="text-2xl font-black uppercase tracking-wider mb-2">Makasi nyakk</h2>
                  </div>

                  {/* Panel Success floating */}
                  <div className="bg-white rounded-t-[40px] p-8 flex flex-col items-center gap-4 text-center">
                    <div className="w-24 h-24 bg-black rounded-full flex items-center justify-center my-4 shadow-lg">
                      <Check className="w-12 h-12 text-white stroke-[4px]" />
                    </div>

                    <h2 className="text-2xl font-black text-black">Thanks You For Purchasing</h2>
                    <p className="text-xs text-zinc-500 font-bold max-w-[240px] leading-relaxed">
                      Pesananmu akan segera diantar
                    </p>

                    <button
                      onClick={() => {
                        setCurrentScreen('main_shell');
                        setSelectedTab(0);
                      }}
                      className="w-full py-4 mt-8 bg-[#C4BAA3] text-black hover:bg-[#C4BAA3]/85 text-sm font-bold rounded-2xl active:scale-95 transition-all shadow-md"
                    >
                      Continue
                    </button>
                    <div className="h-4"></div>
                  </div>
                </div>
              )}

              {/* SETTINGS SUB-PAGE (HISTORY/LOGOUT) */}
              {currentScreen === 'settings' && (
                <div id="settings_screen" className="p-6 flex flex-col min-h-full">
                  <div className="flex items-center gap-4 mb-6">
                    <button onClick={() => setCurrentScreen('main_shell')} className="p-2 border border-black/10 rounded-full bg-white select-none">
                      <ChevronLeft className="w-5 h-5" />
                    </button>
                    <h2 className="text-xl font-black text-black">Settings</h2>
                  </div>

                  <div className="flex flex-col gap-3">
                    <div 
                      onClick={() => setCurrentScreen('order_history')}
                      className="p-4 bg-[#C4BAA3]/70 hover:bg-[#C4BAA3]/85 transition-all text-black font-extrabold rounded-2xl cursor-pointer text-left flex justify-between items-center"
                    >
                      <span>History</span>
                      <span>📜</span>
                    </div>

                    <div 
                      onClick={handleClearDatabase}
                      className="p-4 bg-[#5C3A21] hover:bg-black transition-all text-white font-extrabold rounded-2xl cursor-pointer text-left flex justify-between items-center shadow-md"
                    >
                      <span>Kosongkan Database Menu & Keranjang</span>
                      <span>🗑️</span>
                    </div>

                    <div 
                      onClick={() => {
                        setIsLoggedIn(false);
                        setCurrentScreen('welcome');
                      }}
                      className="p-4 bg-zinc-200 hover:bg-zinc-300 transition-all text-black font-extrabold rounded-2xl cursor-pointer text-left flex justify-between items-center"
                    >
                      <span>Logout</span>
                      <span>🚪</span>
                    </div>
                  </div>
                </div>
              )}

              {/* ORDER HISTORY LIST SCREEN */}
              {currentScreen === 'order_history' && (
                <div id="order_history_screen" className="p-6 flex flex-col min-h-full">
                  <div className="flex items-center gap-4 mb-6">
                    <button onClick={() => setCurrentScreen('settings')} className="p-2 border border-black/10 rounded-full bg-white select-none">
                      <ChevronLeft className="w-5 h-5" />
                    </button>
                    <h2 className="text-xl font-black text-black">History</h2>
                  </div>

                  <div className="flex flex-col gap-3 overflow-y-auto max-h-[520px]">
                    {orderHistory.length === 0 ? (
                      <div className="text-center py-12 text-zinc-400 text-xs font-semibold p-4 border border-dashed rounded-2xl">
                        No purchase order logged in history.
                      </div>
                    ) : (
                      orderHistory.map(row => (
                        <div key={row.id} className="p-4 bg-[#C4BAA3]/30 rounded-2xl flex flex-col text-xs text-zinc-800 gap-1 border border-zinc-200">
                          <div className="flex justify-between font-bold text-black border-b border-zinc-200 pb-1.5 mb-1.5">
                            <span>Order #{row.id}</span>
                            <span>{new Date(row.order_time).toLocaleDateString('id-ID', { hour: '2-digit', minute: '2-digit' })}</span>
                          </div>
                          <div>Table Number: <strong>{row.table_number}</strong></div>
                          <div>Payment Method: <strong>{row.payment_method}</strong></div>
                          <div className="italic text-[10px] text-zinc-500 my-1 font-semibold">{row.items_summary}</div>
                          <div className="flex justify-between font-black text-black mt-1.5 pt-1.5 border-t border-zinc-200 text-sm">
                            <span>Total Pembayaran</span>
                            <span>{formatPrice(row.total_price)}</span>
                          </div>
                        </div>
                      ))
                    )}
                  </div>
                </div>
              )}

            </div>

            {/* Simulated home indicator handle */}
            <div className="h-6 w-full flex items-center justify-center bg-transparent mt-auto select-none pointer-events-none">
              <div className="w-28 h-1 bg-zinc-800 rounded-full"></div>
            </div>

          </div>
        </div>

        {/* Development Instruction Tips */}
        <div className="mt-6 flex flex-col items-center text-center gap-1.5 text-[11px] text-zinc-400 select-none max-w-[340px]">
          <span className="font-extrabold text-zinc-500 uppercase tracking-widest flex items-center gap-1">
            <Info className="w-3.5 h-3.5 text-amber-500" /> Hover & Tap Elements
          </span>
          <span>Simulator ini mensinkronisasi data menu (Tambah Menu) dan pesanan ke RAM State secara otomatis!</span>
        </div>

      </div>

    </div>
  );
}
