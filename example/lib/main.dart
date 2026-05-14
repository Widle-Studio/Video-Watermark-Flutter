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
                title: 'Add Watermark (Default)',
              ),
              const SizedBox(height: 16),
              ElevatableButtonWithWatermark(
                title: 'Add Watermark (Bottom Right)',
                position: const WatermarkPosition.alignment(WatermarkAlignment.bottomRight),
              ),
              const SizedBox(height: 16),
              ElevatableButtonWithWatermark(
                title: 'Add Watermark (x: 100, y: 100)',
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
  final WatermarkPosition? position;

  const ElevatableButtonWithWatermark({
    Key? key,
    required this.title,
    this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final watermark = VideoWatermark();
        String? result = await watermark.addWatermark(
          'test.mp4',
          'Watermark text',
          position: position,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result ?? 'Failed')));
      },
      child: Text(title),
    );
  }
}
