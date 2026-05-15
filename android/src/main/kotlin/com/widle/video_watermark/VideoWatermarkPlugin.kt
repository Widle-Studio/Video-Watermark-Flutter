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
            val watermark = call.argument<Map<String, Any>>("watermark")
            val position = call.argument<Map<String, Any>>("position")

            val watermarkStr = if (watermark != null) watermark.toString() else "unknown watermark"
            val posStr = if (position != null) position.toString() else "default"

            result.success("Android watermarked $videoPath with $watermarkStr at $posStr")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
