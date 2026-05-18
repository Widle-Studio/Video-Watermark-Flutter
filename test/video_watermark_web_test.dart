import 'package:flutter_test/flutter_test.dart';
import 'package:video_watermark/video_watermark_platform_interface.dart';
import 'package:video_watermark/video_watermark_web.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VideoWatermarkWeb', () {
    test('addWatermark() should return expected string', () async {
      final webPlugin = VideoWatermarkWeb();
      const videoPath = 'test_video.mp4';
      const watermarkText = 'Hello World';

      final result = await webPlugin.addWatermark(videoPath, watermarkText);

      expect(
          result,
          equals(
              'WASM watermarked version of $videoPath with text $watermarkText'));
    });
  });
}
