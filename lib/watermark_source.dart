import 'package:flutter/material.dart';

/// Base class for different types of watermarks (Text, Image).
abstract class WatermarkSource {
  /// Opacity of the watermark. Ranges from 0.0 (fully transparent) to 1.0 (fully opaque).
  final double opacity;

  const WatermarkSource({this.opacity = 1.0});

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
    double opacity = 1.0,
  }) : super(opacity: opacity);

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'text',
      'text': text,
      'color': color.value, // ignore: deprecated_member_use
      'fontSize': fontSize,
      'opacity': opacity,
      if (fontFamily != null) 'fontFamily': fontFamily,
    };
  }
}

/// Represents an image-based watermark.
class ImageWatermark extends WatermarkSource {
  /// The local file path to the image to be used as a watermark.
  final String imagePath;

  const ImageWatermark({
    required this.imagePath,
    double opacity = 1.0,
  }) : super(opacity: opacity);

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'image',
      'imagePath': imagePath,
      'opacity': opacity,
    };
  }
}
