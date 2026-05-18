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
            val watermarkStartTime = call.argument<Int>("watermarkStartTime")
            val watermarkEndTime = call.argument<Int>("watermarkEndTime")
            val resizeWidth = call.argument<Int>("resizeWidth")
            val resizeHeight = call.argument<Int>("resizeHeight")
            val trimStart = call.argument<Int>("trimStart")
            val trimEnd = call.argument<Int>("trimEnd")
            val compressionQuality = call.argument<Double>("compressionQuality")

            val watermarkStr = if (watermark != null) watermark.toString() else "unknown watermark"
            val posStr = if (position != null) position.toString() else "default"

            var extras = ""
            if (watermarkStartTime != null) extras += "wm_start: $watermarkStartTime "
            if (watermarkEndTime != null) extras += "wm_end: $watermarkEndTime "
            if (resizeWidth != null) extras += "resizeW: $resizeWidth "
            if (resizeHeight != null) extras += "resizeH: $resizeHeight "
            if (trimStart != null) extras += "trim_start: $trimStart "
            if (trimEnd != null) extras += "trim_end: $trimEnd "
            if (compressionQuality != null) extras += "quality: $compressionQuality"

            result.success("Android watermarked $videoPath with $watermarkStr at $posStr ($extras)")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
