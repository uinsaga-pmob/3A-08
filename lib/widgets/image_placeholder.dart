import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final double borderRadius;

  const ImagePlaceholder({
    super.key,
    required this.imagePath,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath!.isEmpty) {
      return _buildFallback('Kopi Sruput');
    }

    // Determine if it is a Network URL
    if (imagePath!.startsWith('http://') || imagePath!.startsWith('https://')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          imagePath!,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallback(imagePath!),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
      );
    }

    // Solve asset path dynamically
    String assetPath = imagePath!;
    
    // If it is a simulated mobile file explorer path, extract the actual file name to search in assets
    if (assetPath.startsWith('/')) {
      // e.g. /storage/emulated/0/Download/good_day_mocacino.jpg -> assets/good_day_mocacino.jpg
      final lastPart = assetPath.split('/').last.replaceAll('.jpg', '').replaceAll('.png', '');
      assetPath = 'assets/$lastPart.png';
    } else if (!assetPath.startsWith('assets/')) {
      // raw keyword like 'good_day_mocacino' -> assets/good_day_mocacino.png
      assetPath = 'assets/$assetPath.png';
    }

    // Try to load as Flutter Asset
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, assetError, stackTrace) {
          // If the .png asset fails, try .jpg extension
          final jpgPath = assetPath.replaceAll('.png', '.jpg');
          return Image.asset(
            jpgPath,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, jpgError, stackTrace) {
              // Final gorgeous modern vector/text card matching the exact theme colors
              return _buildFallback(imagePath!);
            },
          );
        },
      ),
    );
  }

  Widget _buildFallback(String labelText) {
    // Extract a nice readable short name
    String cleanName = labelText;
    if (cleanName.contains('/')) {
      cleanName = cleanName.split('/').last;
    }
    cleanName = cleanName
        .replaceAll('.png', '')
        .replaceAll('.jpg', '')
        .replaceAll('_', ' ')
        .toUpperCase();
    
    if (cleanName.length > 18) {
      cleanName = cleanName.substring(0, 15) + '...';
    }

    // Determine beautiful warm color based on the label hash
    final hash = cleanName.hashCode;
    final List<Color> niceColors = [
      const Color(0xFF8B5A2B), // Classic Coffee
      const Color(0xFF5C3A21), // Dark Espresso
      const Color(0xFFD2B48C), // Creamy Cream
      const Color(0xFFCD853F), // Peru
      const Color(0xFFA0522D), // Sienna
    ];
    final selectedColor = niceColors[hash.abs() % niceColors.length];

    return Container(
      width: width,
      height: height,
      color: selectedColor.withOpacity(0.9),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_cafe,
                color: Colors.white70,
                size: 26,
              ),
              const SizedBox(height: 6),
              Text(
                cleanName.isEmpty ? 'KOPI SRUPUT' : cleanName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
