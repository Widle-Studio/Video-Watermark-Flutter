#ifndef FLUTTER_PLUGIN_VIDEO_WATERMARK_TEMP_PLUGIN_H_
#define FLUTTER_PLUGIN_VIDEO_WATERMARK_TEMP_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace video_watermark_temp {

class VideoWatermarkTempPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  VideoWatermarkTempPlugin();

  virtual ~VideoWatermarkTempPlugin();

  // Disallow copy and assign.
  VideoWatermarkTempPlugin(const VideoWatermarkTempPlugin&) = delete;
  VideoWatermarkTempPlugin& operator=(const VideoWatermarkTempPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace video_watermark_temp

#endif  // FLUTTER_PLUGIN_VIDEO_WATERMARK_TEMP_PLUGIN_H_
