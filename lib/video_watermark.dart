import 'video_watermark_platform_interface.dart';
import 'watermark_position.dart';
import 'watermark_source.dart';

export 'watermark_position.dart';
export 'watermark_source.dart';

class VideoWatermark {
  Future<String?> getPlatformVersion() {
    return VideoWatermarkPlatform.instance.getPlatformVersion();
  }

  /// Adds a watermark to the video at the given [videoPath].
  /// [watermark] is the source of the watermark (either a TextWatermark or ImageWatermark).
  /// [position] determines where the watermark will be placed. If null, a default position is used.
  Future<String?> addWatermark(
    String videoPath,
    WatermarkSource watermark, {
    WatermarkPosition? position,
  }) {
    return VideoWatermarkPlatform.instance.addWatermark(
      videoPath,
      watermark,
      position: position,
    );
  }
}
