import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'video_watermark_method_channel.dart';

abstract class VideoWatermarkPlatform extends PlatformInterface {
  VideoWatermarkPlatform() : super(token: _token);

  static final Object _token = Object();
  static VideoWatermarkPlatform _instance = MethodChannelVideoWatermark();
  static VideoWatermarkPlatform get instance => _instance;
  static set instance(VideoWatermarkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> addWatermark(String videoPath, String watermarkText) {
    throw UnimplementedError('addWatermark() has not been implemented.');
  }
}
