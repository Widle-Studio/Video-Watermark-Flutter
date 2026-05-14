/// Represents standard preset alignments for a watermark.
enum WatermarkAlignment {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// Represents the position of a watermark on a video.
///
/// You can specify either exact [x] and [y] coordinates (in pixels),
/// or a preset [alignment].
class WatermarkPosition {
  final double? x;
  final double? y;
  final WatermarkAlignment? alignment;

  const WatermarkPosition.coordinates(this.x, this.y) : alignment = null;

  const WatermarkPosition.alignment(this.alignment)
      : x = null,
        y = null;

  Map<String, dynamic> toMap() {
    return {
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (alignment != null) 'alignment': alignment!.name,
    };
  }
}
