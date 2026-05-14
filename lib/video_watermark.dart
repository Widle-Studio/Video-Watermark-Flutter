import 'video_watermark_platform_interface.dart';
import 'watermark_position.dart';

export 'watermark_position.dart';

class VideoWatermark {
  Future<String?> getPlatformVersion() {
    return VideoWatermarkPlatform.instance.getPlatformVersion();
  }

  /// Adds a watermark to the video at the given [videoPath].
  /// [watermarkText] is the text to be overlaid on the video.
  /// [position] determines where the watermark will be placed. If null, a default position is used.
  /// This is currently a stub implementation.
  Future<String?> addWatermark(String videoPath, String watermarkText, {WatermarkPosition? position}) {
    return VideoWatermarkPlatform.instance.addWatermark(videoPath, watermarkText, position: position);
  }
}
