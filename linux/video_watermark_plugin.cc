#include "include/video_watermark/video_watermark_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>
#include <string>

#include "video_watermark_plugin_private.h"

#define VIDEO_WATERMARK_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), video_watermark_plugin_get_type(), \
                              VideoWatermarkPlugin))

struct _VideoWatermarkPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(VideoWatermarkPlugin, video_watermark_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void video_watermark_plugin_handle_method_call(
    VideoWatermarkPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformVersion") == 0) {
    struct utsname uname_data = {};
    uname(&uname_data);
    g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
    g_autoptr(FlValue) result = fl_value_new_string(version);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else if (strcmp(method, "addWatermark") == 0) {
    FlValue* args = fl_method_call_get_args(method_call);
    FlValue* video_path_value = fl_value_lookup_string(args, "videoPath");
    FlValue* position_value = fl_value_lookup_string(args, "position");
    const gchar* video_path = "Unknown";
    std::string pos_str = "default";

    if (video_path_value != nullptr && fl_value_get_type(video_path_value) == FL_VALUE_TYPE_STRING) {
      video_path = fl_value_get_string(video_path_value);
    }

    if (position_value != nullptr && fl_value_get_type(position_value) == FL_VALUE_TYPE_MAP) {
      pos_str = "custom"; // Placeholder for map parsing
    }

    g_autofree gchar *result_str = g_strdup_printf("Linux watermarked %s at %s", video_path, pos_str.c_str());
    g_autoptr(FlValue) result = fl_value_new_string(result_str);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void video_watermark_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(video_watermark_plugin_parent_class)->dispose(object);
}

static void video_watermark_plugin_class_init(VideoWatermarkPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = video_watermark_plugin_dispose;
}

static void video_watermark_plugin_init(VideoWatermarkPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  VideoWatermarkPlugin* plugin = VIDEO_WATERMARK_PLUGIN(user_data);
  video_watermark_plugin_handle_method_call(plugin, method_call);
}

void video_watermark_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  VideoWatermarkPlugin* plugin = VIDEO_WATERMARK_PLUGIN(
      g_object_new(video_watermark_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "video_watermark",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
