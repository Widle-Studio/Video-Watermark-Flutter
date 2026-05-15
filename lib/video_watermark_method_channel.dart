import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'video_watermark_platform_interface.dart';
import 'watermark_position.dart';
import 'watermark_source.dart';

class MethodChannelVideoWatermark extends VideoWatermarkPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('video_watermark');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> addWatermark(
    String videoPath,
    WatermarkSource watermark, {
    WatermarkPosition? position,
  }) async {
    final version = await methodChannel.invokeMethod<String>('addWatermark', {
      'videoPath': videoPath,
      'watermark': watermark.toMap(),
      'position': position?.toMap(),
    });
    return version;
  }
}
