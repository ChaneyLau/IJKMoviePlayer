
Pod::Spec.new do |s|
  s.name             = 'IJKMoviePlayer'
  s.version          = '0.8.8'
  s.summary          = 'IJKMediaFramework(works on both vod and live). '
  s.homepage         = "https://github.com/ChaneyLau/IJKMoviePlayer"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Chaney Lau" => "1625977078@qq.com" }
  s.source           = { :git => 'https://github.com/ChaneyLau/IJKMoviePlayer.git', :tag => s.version.to_s }
  s.platform         = :ios, '9.0'
  s.requires_arc     = true
  s.static_framework = true

  # 依赖库
  s.frameworks       = "AudioToolbox", "AVFoundation", "CoreGraphics", "CoreMedia", "CoreVideo", "MobileCoreServices", "OpenGLES", "QuartzCore", "VideoToolbox", "Foundation", "UIKit", "MediaPlayer"
  s.libraries        = "bz2", "z", "c++"

  # 本框架
  s.vendored_frameworks    = "IJKMoviePlayer/IJKMediaFramework.framework"

end
