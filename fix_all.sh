#!/bin/bash
# Move original logic correctly into example folder
mkdir -p example
mv android ios lib test assets screenshot pubspec.yaml pubspec.lock example/
flutter create --template=plugin --platforms=android,ios,web,linux,macos,windows --org com.widle video_watermark_temp
mv video_watermark_temp/* .
mv video_watermark_temp/.metadata .
mv video_watermark_temp/.gitignore .
rm -rf video_watermark_temp

cat > pubspec.yaml << 'PUBSPEC_EOF'
name: video_watermark
description: A pure Dart/WASM flutter plugin for applying watermarks to videos across multiple platforms.
version: 0.0.1
homepage: https://github.com/Widle-Studio/Video-Watermark-Flutter

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.3.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_web_plugins:
    sdk: flutter
  plugin_platform_interface: ^2.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  plugin:
    platforms:
      android:
        package: com.widle.video_watermark
        pluginClass: VideoWatermarkPlugin
      ios:
        pluginClass: VideoWatermarkPlugin
      linux:
        pluginClass: VideoWatermarkPlugin
      macos:
        pluginClass: VideoWatermarkPlugin
      windows:
        pluginClass: VideoWatermarkPluginCApi
      web:
        pluginClass: VideoWatermarkWeb
        fileName: video_watermark_web.dart
PUBSPEC_EOF

mv lib/video_watermark_temp.dart lib/video_watermark.dart || true
mv lib/video_watermark_temp_method_channel.dart lib/video_watermark_method_channel.dart || true
mv lib/video_watermark_temp_platform_interface.dart lib/video_watermark_platform_interface.dart || true
mv lib/video_watermark_temp_web.dart lib/video_watermark_web.dart || true

cat > lib/video_watermark.dart << 'VW_EOF'
import 'video_watermark_platform_interface.dart';

class VideoWatermark {
  Future<String?> getPlatformVersion() {
    return VideoWatermarkPlatform.instance.getPlatformVersion();
  }

  Future<String?> addWatermark(String videoPath, String watermarkText) {
    return VideoWatermarkPlatform.instance.addWatermark(videoPath, watermarkText);
  }
}
VW_EOF

cat > lib/video_watermark_platform_interface.dart << 'VW_PI_EOF'
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
VW_PI_EOF

cat > lib/video_watermark_method_channel.dart << 'VW_MC_EOF'
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'video_watermark_platform_interface.dart';

class MethodChannelVideoWatermark extends VideoWatermarkPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('video_watermark');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
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
VW_MC_EOF

cat > lib/video_watermark_web.dart << 'VW_WEB_EOF'
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'video_watermark_platform_interface.dart';

class VideoWatermarkWeb extends VideoWatermarkPlatform {
  VideoWatermarkWeb();

  static void registerWith(Registrar registrar) {
    VideoWatermarkPlatform.instance = VideoWatermarkWeb();
  }

  @override
  Future<String?> addWatermark(String videoPath, String watermarkText) async {
    return "WASM watermarked version of $videoPath with text $watermarkText";
  }
}
VW_WEB_EOF

cat > example/pubspec.yaml << 'EX_PUB_EOF'
name: ib
description: A new Flutter project.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  video_watermark:
    path: ../

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
EX_PUB_EOF

rm -rf example/lib/*
cat > example/lib/main.dart << 'EX_MAIN_EOF'
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
              String? result = await watermark.addWatermark('test.mp4', 'Watermark text');
              print(result);
            },
            child: const Text('Add Watermark'),
          ),
        ),
      ),
    );
  }
}
EX_MAIN_EOF

cat > example/test/widget_test.dart << 'EX_TEST_EOF'
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ib/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Video Watermark Example'), findsOneWidget);
    expect(find.text('Add Watermark'), findsOneWidget);
  });
}
EX_TEST_EOF

cat > .pubignore << 'PUBIGNORE_EOF'
example/
.dart_tool/
android/
ios/
windows/
macos/
linux/
fix_all.sh
.DS_Store
ib.iml
video_watermark_temp.iml
PUBIGNORE_EOF

echo "## 0.0.1" > CHANGELOG.md
echo "* Initial release." >> CHANGELOG.md
echo "MIT License" > LICENSE

mkdir -p android/src/main/kotlin/com/widle/video_watermark
mv android/src/main/kotlin/com/widle/video_watermark_temp/VideoWatermarkTempPlugin.kt android/src/main/kotlin/com/widle/video_watermark/VideoWatermarkPlugin.kt || true
rm -rf android/src/main/kotlin/com/widle/video_watermark_temp || true
sed -i 's/video_watermark_temp/video_watermark/g' android/src/main/kotlin/com/widle/video_watermark/VideoWatermarkPlugin.kt
sed -i 's/VideoWatermarkTempPlugin/VideoWatermarkPlugin/g' android/src/main/kotlin/com/widle/video_watermark/VideoWatermarkPlugin.kt

cat > android/src/main/kotlin/com/widle/video_watermark/VideoWatermarkPlugin.kt << 'KT_EOF'
package com.widle.video_watermark

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class VideoWatermarkPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "video_watermark")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "addWatermark") {
            val videoPath = call.argument<String>("videoPath")
            result.success("Android watermarked $videoPath")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
KT_EOF

mv ios/Classes/VideoWatermarkTempPlugin.swift ios/Classes/VideoWatermarkPlugin.swift || true
sed -i 's/video_watermark_temp/video_watermark/g' ios/Classes/VideoWatermarkPlugin.swift
sed -i 's/VideoWatermarkTempPlugin/VideoWatermarkPlugin/g' ios/Classes/VideoWatermarkPlugin.swift

mv macos/Classes/VideoWatermarkTempPlugin.swift macos/Classes/VideoWatermarkPlugin.swift || true
sed -i 's/video_watermark_temp/video_watermark/g' macos/Classes/VideoWatermarkPlugin.swift
sed -i 's/VideoWatermarkTempPlugin/VideoWatermarkPlugin/g' macos/Classes/VideoWatermarkPlugin.swift

mv linux/video_watermark_temp_plugin.cc linux/video_watermark_plugin.cc || true
mv linux/include/video_watermark_temp linux/include/video_watermark || true
mv linux/include/video_watermark/video_watermark_temp_plugin.h linux/include/video_watermark/video_watermark_plugin.h || true
mv linux/video_watermark_temp_plugin_private.h linux/video_watermark_plugin_private.h || true
sed -i 's/video_watermark_temp/video_watermark/g' linux/video_watermark_plugin.cc
sed -i 's/video_watermark_temp/video_watermark/g' linux/CMakeLists.txt
sed -i 's/VideoWatermarkTempPlugin/VideoWatermarkPlugin/g' linux/video_watermark_plugin.cc

mv windows/video_watermark_temp_plugin.cpp windows/video_watermark_plugin.cpp || true
mv windows/include/video_watermark_temp windows/include/video_watermark || true
mv windows/include/video_watermark/video_watermark_temp_plugin_c_api.h windows/include/video_watermark/video_watermark_plugin_c_api.h || true
mv windows/video_watermark_temp_plugin.h windows/video_watermark_plugin.h || true
mv windows/video_watermark_temp_plugin_c_api.cpp windows/video_watermark_plugin_c_api.cpp || true
sed -i 's/video_watermark_temp/video_watermark/g' windows/CMakeLists.txt
sed -i 's/video_watermark_temp/video_watermark/g' windows/video_watermark_plugin_c_api.cpp
sed -i 's/VideoWatermarkTempPlugin/VideoWatermarkPlugin/g' windows/video_watermark_plugin.cpp

# Make sure windows and linux paths don't conflict, fixing their addWatermark impls too
cat > windows/video_watermark_plugin.cpp << 'WIN_EOF'
#include "video_watermark_plugin.h"
#include <windows.h>
#include <VersionHelpers.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <memory>
#include <sstream>

namespace video_watermark {

void VideoWatermarkPlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar) {
  auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(registrar->messenger(), "video_watermark", &flutter::StandardMethodCodec::GetInstance());
  auto plugin = std::make_unique<VideoWatermarkPlugin>();
  channel->SetMethodCallHandler([plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
  });
  registrar->AddPlugin(std::move(plugin));
}

VideoWatermarkPlugin::VideoWatermarkPlugin() {}
VideoWatermarkPlugin::~VideoWatermarkPlugin() {}

void VideoWatermarkPlugin::HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue> &method_call, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name() == "getPlatformVersion") {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    result->Success(flutter::EncodableValue(version_stream.str()));
  } else if (method_call.method_name() == "addWatermark") {
    result->Success(flutter::EncodableValue("Windows watermarked Unknown"));
  } else {
    result->NotImplemented();
  }
}
}
WIN_EOF

rm -rf IB-App.apk example/example/ example/android/app/google-services.json
git rm -r --cached IB-App.apk example/android/app/google-services.json
git rm -r --cached test/
rm -rf test/
git add .
git commit -am "finally properly rebase and restructure the package successfully"
