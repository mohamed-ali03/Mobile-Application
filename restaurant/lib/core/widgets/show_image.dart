import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String imageUrl;
  const ShowImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, size: 50, color: Colors.grey),
            )
          : Container(
              color: Colors.grey.shade200,
              child: Icon(Icons.image, size: 50, color: Colors.grey),
            ),
    );
  }
}
