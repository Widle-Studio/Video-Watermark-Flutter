import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'video_watermark_platform_interface.dart';
import 'watermark_position.dart';
import 'watermark_source.dart';

class VideoWatermarkWeb extends VideoWatermarkPlatform {
  VideoWatermarkWeb();

  static void registerWith(Registrar registrar) {
    VideoWatermarkPlatform.instance = VideoWatermarkWeb();
  }

  @override
  Future<String?> addWatermark(
    String videoPath,
    WatermarkSource watermark, {
    WatermarkPosition? position,
    Duration? watermarkStartTime,
    Duration? watermarkEndTime,
    int? resizeWidth,
    int? resizeHeight,
    Duration? trimStart,
    Duration? trimEnd,
    double? compressionQuality,
  }) async {
    final posStr = position != null ? position.toMap().toString() : "default";
    final watermarkStr = watermark.toMap().toString();
    final parts = [
      if (watermarkStartTime != null) 'wm_start: ${watermarkStartTime.inMilliseconds}ms',
      if (watermarkEndTime != null) 'wm_end: ${watermarkEndTime.inMilliseconds}ms',
      if (resizeWidth != null && resizeHeight != null) 'resize: ${resizeWidth}x$resizeHeight',
      if (trimStart != null) 'trim_start: ${trimStart.inMilliseconds}ms',
      if (trimEnd != null) 'trim_end: ${trimEnd.inMilliseconds}ms',
      if (compressionQuality != null) 'quality: $compressionQuality',
    ];
    final extras = parts.isEmpty ? "no extra props" : parts.join(", ");

    return "WASM watermarked version of $videoPath with watermark $watermarkStr at $posStr ($extras)";
  }
}
