#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint video_watermark.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'video_watermark'
  s.version          = '0.0.1'
  s.summary          = 'A pure Dart/WASM flutter plugin for applying watermarks to videos across multiple platforms.'
  s.description      = <<-DESC
A pure Dart/WASM flutter plugin for applying watermarks to videos across multiple platforms.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files = '../darwin/video_watermark/Sources/video_watermark/**/*.swift'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.14'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
