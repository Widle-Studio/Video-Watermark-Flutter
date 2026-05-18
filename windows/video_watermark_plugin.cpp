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
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
  } else if (method_call.method_name() == "addWatermark") {
    std::string video_path = "Unknown";
    std::string watermark_str = "unknown watermark";
    std::string pos_str = "default";
    std::string extras = "";

    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      auto video_path_it = arguments->find(flutter::EncodableValue("videoPath"));
      if (video_path_it != arguments->end()) {
        if (std::holds_alternative<std::string>(video_path_it->second)) {
             video_path = std::get<std::string>(video_path_it->second);
        }
      }

      auto watermark_it = arguments->find(flutter::EncodableValue("watermark"));
      if (watermark_it != arguments->end() && !watermark_it->second.IsNull()) {
        watermark_str = "custom watermark";
      }

      auto position_it = arguments->find(flutter::EncodableValue("position"));
      if (position_it != arguments->end() && !position_it->second.IsNull()) {
        pos_str = "custom";
      }

      auto wm_start_it = arguments->find(flutter::EncodableValue("watermarkStartTime"));
      if (wm_start_it != arguments->end() && !wm_start_it->second.IsNull()) {
        extras = "wm_start parsed";
      }
    }
    std::ostringstream result_stream;
    result_stream << "Windows watermarked " << video_path << " with " << watermark_str << " at " << pos_str << " (" << extras << ")";
    result->Success(flutter::EncodableValue(result_stream.str()));
  } else {
    result->NotImplemented();
  }
}
}
