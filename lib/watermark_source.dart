import 'package:flutter/material.dart';

/// Base class for different types of watermarks (Text, Image).
abstract class WatermarkSource {
  const WatermarkSource();

  Map<String, dynamic> toMap();
}

/// Represents a text-based watermark.
class TextWatermark extends WatermarkSource {
  final String text;
  final Color color;
  final double fontSize;
  final String? fontFamily;

  const TextWatermark(
    this.text, {
    this.color = Colors.white,
    this.fontSize = 24.0,
    this.fontFamily,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'text',
      'text': text,
      'color': color.value, // ignore: deprecated_member_use
      'fontSize': fontSize,
      if (fontFamily != null) 'fontFamily': fontFamily,
    };
  }
}

/// Represents an image-based watermark.
class ImageWatermark extends WatermarkSource {
  /// The local file path to the image to be used as a watermark.
  final String imagePath;

  const ImageWatermark({required this.imagePath});

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'image',
      'imagePath': imagePath,
    };
  }
}
