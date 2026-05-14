import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'video_watermark_platform_interface.dart';
import 'watermark_position.dart';

class VideoWatermarkWeb extends VideoWatermarkPlatform {
  VideoWatermarkWeb();

  static void registerWith(Registrar registrar) {
    VideoWatermarkPlatform.instance = VideoWatermarkWeb();
  }

  @override
  Future<String?> addWatermark(String videoPath, String watermarkText, {WatermarkPosition? position}) async {
    final posStr = position != null ? position.toMap().toString() : "default";
    return "WASM watermarked version of $videoPath with text $watermarkText at $posStr";
  }
}
