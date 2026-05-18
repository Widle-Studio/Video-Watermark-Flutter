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
  /// [watermarkStartTime] and [watermarkEndTime] allow the watermark to only show during a specific segment.
  /// [resizeWidth] and [resizeHeight] resize the video.
  /// [trimStart] and [trimEnd] trim the overall length of the output video.
  /// [compressionQuality] applies compression (e.g. 0.0 to 1.0).
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
  }) {
    return VideoWatermarkPlatform.instance.addWatermark(
      videoPath,
      watermark,
      position: position,
      watermarkStartTime: watermarkStartTime,
      watermarkEndTime: watermarkEndTime,
      resizeWidth: resizeWidth,
      resizeHeight: resizeHeight,
      trimStart: trimStart,
      trimEnd: trimEnd,
      compressionQuality: compressionQuality,
    );
  }
}
