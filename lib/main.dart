import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KopiSruputApp());
}

class KopiSruputApp extends StatelessWidget {
  const KopiSruputApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kopi Sruput - Coffee Ordering App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFDFBF2), // Elegant Warm Beige
        primaryColor: const Color(0xFF8B5A2B), // Classic Coffee Brown
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5A2B),
          primary: const Color(0xFF5C3A21), // Dark Espresso
          secondary: const Color(0xFFD2B48C), // Creamy Latte
          background: const Color(0xFFFDFBF2),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.brown.shade800,
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
