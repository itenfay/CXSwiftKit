#
# Be sure to run `pod lib lint CXSwiftKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CXSwiftKit'
  s.version          = '2.0.0'
  s.summary          = 'CXSwiftKit provides the utilities and rich extensions of Swift language, and most of them supported Objective-C.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       CXSwiftKit provides the utilities and rich extensions of Swift language, and most of them supported Objective-C.
                       DESC

  s.homepage         = 'https://github.com/chenxing640/CXSwiftKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chenxing' => 'chenxing640@foxmail.com' }
  s.source           = { :git => 'https://github.com/chenxing640/CXSwiftKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.swift_versions = ['4.2', '5.0']
  
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '11.0'
  s.tvos.deployment_target = '12.0'
  s.watchos.deployment_target = "5.0"
  
  s.requires_arc = true
  s.default_subspecs = 'Base', 'Core'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  
  #s.source_files = 'CXSwiftKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CXSwiftKit' => ['CXSwiftKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.subspec "Base" do |base|
    base.source_files = 'CXSwiftKit/Classes/Base/*.{swift}'
  end
  
  s.subspec "Core" do |core|
    core.subspec "Atomic" do |atom|
      atom.source_files = 'CXSwiftKit/Classes/Core/Atomic/*.{swift}'
    end
    
    core.subspec "Extension" do |ext|
      ext.source_files = 'CXSwiftKit/Classes/Core/Extension/*.{swift}'
      ext.dependency 'CXSwiftKit/Base'
    end
    
    core.subspec "FileOperation" do |fo|
      fo.source_files = 'CXSwiftKit/Classes/Core/FileOperation/*.{swift}'
      fo.dependency 'CXSwiftKit/Core/Extension'
    end
    
    core.subspec "AVToolbox" do |avtb|
      avtb.source_files = 'CXSwiftKit/Classes/Core/AVToolbox/*.{swift}'
      avtb.dependency 'CXSwiftKit/Core/FileOperation'
    end
    
    core.subspec "Camera" do |cam|
      cam.source_files = 'CXSwiftKit/Classes/Core/Camera/*.{swift}'
      cam.dependency 'CXSwiftKit/Base'
      cam.dependency 'CXSwiftKit/Core/Atomic'
    end
    
    core.subspec "CustomOverlayView" do |cov|
      cov.source_files = 'CXSwiftKit/Classes/Core/CustomOverlayView/*.{swift}'
      cov.dependency 'CXSwiftKit/Core/Extension'
    end
    
    core.subspec "DocumentPicker" do |dp|
      dp.source_files = 'CXSwiftKit/Classes/Core/DocumentPicker/*.{swift}'
    end
    
    core.subspec "ImageBuffer" do |imgbuffer|
      imgbuffer.source_files = 'CXSwiftKit/Classes/Core/ImageBuffer/*.{swift}'
    end
    
    core.subspec "LiveGift" do |livegift|
      livegift.source_files = 'CXSwiftKit/Classes/Core/LiveGift/*.{swift}'
    end
    
    core.subspec "Permissions" do |pm|
      pm.source_files = 'CXSwiftKit/Classes/Core/Permissions/*.{swift}'
      pm.dependency 'CXSwiftKit/Base'
    end
    
    core.subspec "Timer" do |timer|
      timer.source_files = 'CXSwiftKit/Classes/Core/Timer/*.{swift}'
      timer.dependency 'CXSwiftKit/Core/Extension'
    end
    
    core.subspec "Transition" do |transition|
      transition.source_files = 'CXSwiftKit/Classes/Core/Transition/*.{swift}'
      transition.dependency 'CXSwiftKit/Core/Extension'
    end
    
    core.subspec "Utils" do |uts|
      uts.source_files = 'CXSwiftKit/Classes/Core/Transition/*.{swift}'
      uts.dependency 'CXSwiftKit/Core/FileOperation'
      uts.dependency 'DYFSwiftKeychain'
    end
    
    core.subspec "Widget" do |wd|
      wd.source_files = 'CXSwiftKit/Classes/Core/Widget/*.{swift}'
      wd.dependency 'CXSwiftKit/Base'
    end
  end
  
  s.subspec "ApplePay" do |applepay|
    applepay.source_files = 'CXSwiftKit/Classes/ApplePay/*.{swift}'
    applepay.resource = 'CXSwiftKit/Assets/ApplePay/*.png'
    applepay.dependency 'CXSwiftKit/Base'
  end
  
  s.subspec "AR" do |ar|
    ar.source_files = 'CXSwiftKit/Classes/AR/*.{swift}'
    ar.dependency 'CXSwiftKit/Base'
    ar.dependency 'SCNLine'
  end
  
  s.subspec "EmptyDataSet" do |eds|
    eds.source_files = 'CXSwiftKit/Classes/EmptyDataSet/*.{swift}'
    eds.dependency 'CXSwiftKit/Core/Extension'
    eds.dependency 'DZNEmptyDataSet'
  end
  
  s.subspec "HandyJSONHelper" do |hjson|
    hjson.source_files = 'CXSwiftKit/Classes/HandyJSONHelper/*.{swift}'
    hjson.dependency 'CXSwiftKit/Base'
    hjson.dependency 'HandyJSON'
  end
  
  s.subspec "KingfisherWrapper" do |kfw|
    kfw.source_files = 'CXSwiftKit/Classes/KingfisherWrapper/*.{swift}'
    kfw.dependency 'CXSwiftKit/Base'
    kfw.dependency 'Kingfisher'
  end
  
  s.subspec "NetWork" do |network|
    network.source_files = 'CXSwiftKit/Classes/NetWork/*.{swift}'
    network.dependency 'CXSwiftKit/Base'
    network.dependency 'Moya'
    network.dependency 'HandyJSON', '~> 5.0.4-beta'
    # Ignored
    #network.vendored_frameworks = 'Framwork1.xcframwork', 'Framwork2.xcframwork'
  end
  
  s.subspec "OverlayView" do |ov|
    ov.source_files = 'CXSwiftKit/Classes/OverlayView/*.{swift}'
    ov.dependency 'CXSwiftKit/Base'
    ov.dependency 'OverlayController'
  end
  
  s.subspec "RxButton" do |rxb|
    rxb.source_files = 'CXSwiftKit/Classes/RxButton/*.{swift}'
    rxb.dependency 'CXSwiftKit/Core/Extension'
    rxb.dependency 'RxSwift'
    rxb.dependency 'RxCocoa'
  end
  
  s.subspec "RxEmptyDataSet" do |rxeds|
    rxeds.source_files = 'CXSwiftKit/Classes/RxEmptyDataSet/*.{swift}'
    rxeds.dependency 'CXSwiftKit/EmptyDataSet'
    rxeds.dependency 'RxSwift'
    rxeds.dependency 'RxCocoa'
  end
  
  s.subspec "RxKafkaRefresh" do |rxkafkar|
    rxkafkar.source_files = 'CXSwiftKit/Classes/RxKafkaRefresh/*.{swift}'
    rxkafkar.dependency 'KafkaRefresh'
    rxkafkar.dependency 'RxSwift'
    rxkafkar.dependency 'RxCocoa'
  end
  
  s.subspec "RxKingfisher" do |rxkf|
    rxkf.source_files = 'CXSwiftKit/Classes/RxKingfisher/*.{swift}'
    rxkf.dependency 'CXSwiftKit/Core/Extension'
    rxkf.dependency 'Kingfisher'
    rxkf.dependency 'RxSwift'
    rxkf.dependency 'RxCocoa'
  end
  
  s.subspec "RxListDataSource" do |rxlds|
    rxlds.source_files = 'CXSwiftKit/Classes/RxListDataSource/*.{swift}'
    rxlds.dependency 'RxSwift'
    rxlds.dependency 'RxCocoa'
    rxlds.dependency 'RxDataSources'
  end
  
  s.subspec "RxMJRefresh" do |rxmj|
    rxmj.source_files = 'CXSwiftKit/Classes/RxMJRefresh/*.{swift}'
    rxmj.dependency 'MJRefresh'
    rxmj.dependency 'RxSwift'
    rxmj.dependency 'RxCocoa'
  end
  
  s.subspec "SDWebImageWrapper" do |sdwebw|
    sdwebw.source_files = 'CXSwiftKit/Classes/SDWebImageWrapper/*.{swift}'
    sdwebw.dependency 'SDWebImage'
  end
  
  s.subspec "SvgaPlay" do |svgap|
    svgap.source_files = 'CXSwiftKit/Classes/SvgaPlay/*.{swift}'
    svgap.vendored_frameworks = 'CXSwiftKit/Assets/SVGAPlayerXFWK/SVGAPlayer.xcframwork'
  end
  
  s.subspec "SVProgressHUDEx" do |svph|
    svph.source_files = 'CXSwiftKit/Classes/SVProgressHUDEx/*.{swift}'
    svph.dependency 'SVProgressHUD'
  end
  
  s.subspec "SwiftMessagesEx" do |smsg|
    smsg.source_files = 'CXSwiftKit/Classes/SwiftMessagesEx/*.{swift}'
    smsg.dependency 'CXSwiftKit/Core/Extension'
    smsg.dependency 'SwiftMessages'
  end
  
  s.subspec "ToasterEx" do |toast|
    toast.source_files = 'CXSwiftKit/Classes/ToasterEx/*.{swift}'
    toast.dependency 'Toaster'
  end
  
  s.subspec "ToastSwiftEx" do |toastsw|
    toastsw.source_files = 'CXSwiftKit/Classes/ToastSwiftEx/*.{swift}'
    toastsw.dependency 'Toast_Swift', '~> 5.0.1'
  end
  
  s.subspec "WebSocket" do |ws|
    ws.source_files = 'CXSwiftKit/Classes/WebSocket/*.{swift}'
    ws.dependency 'CXSwiftKit/Base'
    ws.dependency 'Starscream'
  end
  
end
