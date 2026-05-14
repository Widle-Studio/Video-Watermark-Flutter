#ifndef FLUTTER_PLUGIN_VIDEO_WATERMARK_TEMP_PLUGIN_H_
#define FLUTTER_PLUGIN_VIDEO_WATERMARK_TEMP_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace video_watermark {

class VideoWatermarkPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  VideoWatermarkPlugin();

  virtual ~VideoWatermarkPlugin();

  // Disallow copy and assign.
  VideoWatermarkPlugin(const VideoWatermarkPlugin&) = delete;
  VideoWatermarkPlugin& operator=(const VideoWatermarkPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace video_watermark

#endif  // FLUTTER_PLUGIN_VIDEO_WATERMARK_TEMP_PLUGIN_H_
