#if os(macOS)
import Cocoa
import FlutterMacOS
#else
import Flutter
import UIKit
#endif

public class VideoWatermarkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    #if os(macOS)
    let messenger = registrar.messenger
    #else
    let messenger = registrar.messenger()
    #endif
    let channel = FlutterMethodChannel(name: "video_watermark", binaryMessenger: messenger)
    let instance = VideoWatermarkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      #if os(macOS)
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
      #else
      result("iOS " + UIDevice.current.systemVersion)
      #endif
    case "addWatermark":
      let args = call.arguments as? [String: Any]
      let videoPath = args?["videoPath"] as? String ?? "Unknown"
      let watermark = args?["watermark"] as? [String: Any]
      let position = args?["position"] as? [String: Any]

      let watermarkStr = watermark != nil ? String(describing: watermark!) : "unknown watermark"
      let posStr = position != nil ? String(describing: position!) : "default"

      #if os(macOS)
      result("macOS watermarked " + videoPath + " with " + watermarkStr + " at " + posStr)
      #else
      result("iOS watermarked " + videoPath + " with " + watermarkStr + " at " + posStr)
      #endif
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
