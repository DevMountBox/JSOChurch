import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  final String placeholderImage;

  const BlurredImageWidget({
    Key? key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.fit = BoxFit.cover,
    this.placeholderImage = "assets/images/father_place_holder.png",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Stack(
      children: [
        // Blurred Background Image (only if the image exists)
        if (hasImage)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover, // Cover full container
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 0), // Blur effect
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Optional dark overlay
                ),
              ),
            ),
          ),

        // Foreground Image
        Center(
          child: Container(
            height: height,
            width: width,
            child: hasImage
                ? Image.network(
              imageUrl!,
              fit: BoxFit.fitHeight,
              alignment: Alignment.topCenter,
            )
                : Image.asset(
              placeholderImage,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    );
  }
}
