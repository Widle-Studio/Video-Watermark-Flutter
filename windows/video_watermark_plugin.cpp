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
