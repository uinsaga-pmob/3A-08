import 'package:flutter/material.dart';

class CupLogo extends StatelessWidget {
  final double size;
  final Color? color;
  const CupLogo({super.key, this.size = 80, this.color});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // High contrast beautiful material fallback circle
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF5C3A21), // Dark Espresso
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.local_cafe,
            size: size * 0.5,
            color: color ?? const Color(0xFFD2B48C),
          ),
        );
      },
    );
  }
}

