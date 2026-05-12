#include "include/video_watermark/video_watermark_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "video_watermark_plugin.h"

void VideoWatermarkTempPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  video_watermark::VideoWatermarkTempPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
