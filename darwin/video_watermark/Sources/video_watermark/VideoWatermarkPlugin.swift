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

      var extras = ""
      if let wmStart = args?["watermarkStartTime"] as? Int { extras += "wm_start: \(wmStart) " }
      if let wmEnd = args?["watermarkEndTime"] as? Int { extras += "wm_end: \(wmEnd) " }
      if let rw = args?["resizeWidth"] as? Int { extras += "resizeW: \(rw) " }
      if let rh = args?["resizeHeight"] as? Int { extras += "resizeH: \(rh) " }
      if let trimStart = args?["trimStart"] as? Int { extras += "trim_start: \(trimStart) " }
      if let trimEnd = args?["trimEnd"] as? Int { extras += "trim_end: \(trimEnd) " }
      if let quality = args?["compressionQuality"] as? Double { extras += "quality: \(quality)" }

      #if os(macOS)
      result("macOS watermarked " + videoPath + " with " + watermarkStr + " at " + posStr + " (" + extras + ")")
      #else
      result("iOS watermarked " + videoPath + " with " + watermarkStr + " at " + posStr + " (" + extras + ")")
      #endif
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
