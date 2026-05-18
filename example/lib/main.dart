import 'package:flutter/material.dart';
import 'package:video_watermark/video_watermark.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Video Watermark Example')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ElevatableButtonWithWatermark(
                title: 'Add Text Watermark (Default)',
                watermark: TextWatermark('Hello World'),
              ),
              const SizedBox(height: 16),
              const ElevatableButtonWithWatermark(
                title: 'Add Custom Text Watermark (50% Opacity)',
                watermark: TextWatermark(
                  'Custom Font & Color',
                  color: Colors.red,
                  fontSize: 32.0,
                  fontFamily: 'Arial',
                  opacity: 0.5,
                ),
                position: WatermarkPosition.alignment(WatermarkAlignment.bottomRight),
              ),
              const SizedBox(height: 16),
              const ElevatableButtonWithWatermark(
                title: 'Add Image Watermark (Trimmed & Resized)',
                watermark: ImageWatermark(imagePath: '/path/to/logo.png', opacity: 0.8),
                position: WatermarkPosition.coordinates(100, 100),
                watermarkStartTime: Duration(seconds: 2),
                watermarkEndTime: Duration(seconds: 10),
                resizeWidth: 1280,
                resizeHeight: 720,
                trimStart: Duration(seconds: 0),
                trimEnd: Duration(seconds: 15),
                compressionQuality: 0.8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ElevatableButtonWithWatermark extends StatelessWidget {
  final String title;
  final WatermarkSource watermark;
  final WatermarkPosition? position;
  final Duration? watermarkStartTime;
  final Duration? watermarkEndTime;
  final int? resizeWidth;
  final int? resizeHeight;
  final Duration? trimStart;
  final Duration? trimEnd;
  final double? compressionQuality;

  const ElevatableButtonWithWatermark({
    Key? key,
    required this.title,
    required this.watermark,
    this.position,
    this.watermarkStartTime,
    this.watermarkEndTime,
    this.resizeWidth,
    this.resizeHeight,
    this.trimStart,
    this.trimEnd,
    this.compressionQuality,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final plugin = VideoWatermark();
        String? result = await plugin.addWatermark(
          'test.mp4',
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result ?? 'Failed')));
      },
      child: Text(title, textAlign: TextAlign.center),
    );
  }
}
