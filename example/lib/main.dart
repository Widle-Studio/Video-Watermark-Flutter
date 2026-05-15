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
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatableButtonWithWatermark(
                title: 'Add Text Watermark (Default)',
                watermark: const TextWatermark('Hello World'),
              ),
              const SizedBox(height: 16),
              ElevatableButtonWithWatermark(
                title: 'Add Custom Text Watermark',
                watermark: const TextWatermark(
                  'Custom Font & Color',
                  color: Colors.red,
                  fontSize: 32.0,
                  fontFamily: 'Arial',
                ),
                position: const WatermarkPosition.alignment(WatermarkAlignment.bottomRight),
              ),
              const SizedBox(height: 16),
              ElevatableButtonWithWatermark(
                title: 'Add Image Watermark',
                watermark: const ImageWatermark(imagePath: '/path/to/logo.png'),
                position: const WatermarkPosition.coordinates(100, 100),
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

  const ElevatableButtonWithWatermark({
    Key? key,
    required this.title,
    required this.watermark,
    this.position,
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
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result ?? 'Failed')));
      },
      child: Text(title),
    );
  }
}
