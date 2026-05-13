# Video Watermark Plugin

A Flutter plugin to apply watermarks to videos across all platforms (Android, iOS, Web, macOS, Windows, Linux) natively and purely via Dart/WASM.

## Setup

See example.

## Usage

```dart
final watermark = VideoWatermark();
String? result = await watermark.addWatermark('test.mp4', 'Watermark text');
```
