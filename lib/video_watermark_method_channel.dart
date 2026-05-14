import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'video_watermark_platform_interface.dart';

class MethodChannelVideoWatermark extends VideoWatermarkPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('video_watermark');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> addWatermark(String videoPath, String watermarkText) async {
    final version = await methodChannel.invokeMethod<String>('addWatermark', {
      'videoPath': videoPath,
      'watermarkText': watermarkText,
    });
    return version;
  }
}
