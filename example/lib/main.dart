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
          child: ElevatedButton(
            onPressed: () async {
              final watermark = VideoWatermark();
              String? result =
                  await watermark.addWatermark('test.mp4', 'Watermark text');
              print(result);
            },
            child: const Text('Add Watermark'),
          ),
        ),
      ),
    );
  }
}
