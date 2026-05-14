#include "include/video_watermark/video_watermark_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "video_watermark_plugin.h"

void VideoWatermarkPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  video_watermark::VideoWatermarkPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
