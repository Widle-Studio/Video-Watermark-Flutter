import 'video_watermark_platform_interface.dart';

class VideoWatermark {
  Future<String?> getPlatformVersion() {
    return VideoWatermarkPlatform.instance.getPlatformVersion();
  }

  Future<String?> addWatermark(String videoPath, String watermarkText) {
    return VideoWatermarkPlatform.instance
        .addWatermark(videoPath, watermarkText);
  }
}
