import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int current;

  const BottomNav({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      color: const Color(0xFFE2D7C4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          navItem(Icons.home, 0, current, () => Navigator.pushNamed(context, "/home")),
          navItem(Icons.favorite_border, 1, current, () {}),
          navItem(Icons.shopping_cart_outlined, 2, current, () {}),
          navItem(Icons.person, 3, current, () => Navigator.pushNamed(context, "/profile")),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, int index, int selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: index == selected ? Colors.black : Colors.black54,
        size: 28,
      ),
    );
  }
}

