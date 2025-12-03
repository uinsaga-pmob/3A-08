import 'package:coffeshop/WelcomePage.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'LoginPage.dart';
import 'SignUp2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kopi Sruput',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFFF8E6)),
      home: const WelcomePage(),
      routes: {
        "/login": (context) => const LoginPage(),
        "/signup": (context) => const SignUpStep2(),
        "/home": (context) => const HomePage(),
      },
    );
  }
}
