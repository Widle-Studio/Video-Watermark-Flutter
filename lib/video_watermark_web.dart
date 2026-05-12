import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'video_watermark_platform_interface.dart';

class VideoWatermarkWeb extends VideoWatermarkPlatform {
  VideoWatermarkWeb();

  static void registerWith(Registrar registrar) {
    VideoWatermarkPlatform.instance = VideoWatermarkWeb();
  }

  @override
  Future<String?> addWatermark(String videoPath, String watermarkText) async {
    return "WASM watermarked version of $videoPath with text $watermarkText";
  }
}
