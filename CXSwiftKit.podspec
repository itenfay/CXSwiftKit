#
# Be sure to run `pod lib lint CXSwiftKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CXSwiftKit'
  s.version          = '2.0.5'
  s.summary          = 'CXSwiftKit provides the utilities and rich extensions of Swift language.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = <<-DESC
  TODU: CXSwiftKit provides the utilities and rich extensions of Swift language.
  DESC
  
  s.homepage         = 'https://github.com/chenxing640/CXSwiftKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Teng Fei' => 'hansen981@126.com' }
  s.source           = { :git => 'https://github.com/chenxing640/CXSwiftKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.swift_versions = ['4.2', '5.0']
  
  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'
  s.osx.deployment_target = '10.13'
  s.watchos.deployment_target = "5.0"
  
  s.requires_arc = true
  #s.default_subspec = 'Core'
  #s.default_subspecs = 'Base', 'ApplePay', 'Core'
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
  
  s.subspec "Extension" do |ext|
    ext.source_files = 'CXSwiftKit/Classes/Extension/*.{swift}'
    ext.dependency 'CXSwiftKit/Base'
  end
  
  s.subspec "FileOperation" do |fp|
    fp.source_files = 'CXSwiftKit/Classes/FileOperation/*.{swift}'
    fp.dependency 'CXSwiftKit/Extension'
  end
  
  s.subspec "Core" do |core|
    core.source_files = 'CXSwiftKit/Classes/Core/*.{swift}'
    core.dependency 'CXSwiftKit/FileOperation'
    core.dependency 'DYFSwiftKeychain'
    
    core.subspec "Permissions" do |pm|
      pm.source_files = 'CXSwiftKit/Classes/Core/Permissions/*.{swift}'
      pm.dependency 'CXSwiftKit/Base'
    end
    
    core.subspec "Camera" do |cam|
      cam.source_files = 'CXSwiftKit/Classes/Core/Camera/*.{swift}'
      cam.dependency 'CXSwiftKit/Base'
    end
    
    core.subspec "DocumentPicker" do |dp|
      dp.source_files = 'CXSwiftKit/Classes/Core/DocumentPicker/*.{swift}'
    end
    
    core.subspec "Widget" do |wd|
      wd.source_files = 'CXSwiftKit/Classes/Core/Widget/*.{swift}'
      wd.dependency 'CXSwiftKit/Base'
    end
    
    core.subspec "AVToolbox" do |avtb|
      avtb.source_files = 'CXSwiftKit/Classes/Core/AVToolbox/*.{swift}'
      avtb.dependency 'CXSwiftKit/FileOperation'
    end
    
    core.subspec "CustomOverlayView" do |cov|
      cov.source_files = 'CXSwiftKit/Classes/Core/CustomOverlayView/*.{swift}'
      cov.dependency 'CXSwiftKit/Extension'
    end
    
    core.subspec "LiveGift" do |livegift|
      livegift.source_files = 'CXSwiftKit/Classes/Core/LiveGift/*.{swift}'
      livegift.dependency 'CXSwiftKit/Extension'
    end
    
    core.subspec "Timer" do |timer|
      timer.source_files = 'CXSwiftKit/Classes/Core/Timer/*.{swift}'
      timer.dependency 'CXSwiftKit/Extension'
    end
    
    core.subspec "Transition" do |transition|
      transition.source_files = 'CXSwiftKit/Classes/Core/Transition/*.{swift}'
      transition.dependency 'CXSwiftKit/Extension'
    end
  end
  
  s.subspec "ApplePay" do |applepay|
    applepay.source_files = 'CXSwiftKit/Classes/ApplePay/*.{swift}'
    applepay.resource = 'CXSwiftKit/Assets/ApplePay/*.png'
    applepay.ios.deployment_target = '11.0'
    applepay.osx.deployment_target = '11.0'
    applepay.dependency 'CXSwiftKit/Base'
  end
  
  s.subspec "HandyJSONHelper" do |hjson|
    hjson.source_files = 'CXSwiftKit/Classes/HandyJSONHelper/*.{swift}'
    hjson.ios.deployment_target = '11.0'
    hjson.tvos.deployment_target = '11.0'
    hjson.watchos.deployment_target = "5.0"
    hjson.dependency 'HandyJSON', '~> 5.0.4-beta'
  end
  
  s.subspec "KingfisherWrapper" do |kfw|
    kfw.source_files = 'CXSwiftKit/Classes/KingfisherWrapper/*.{swift}'
    kfw.ios.deployment_target = '11.0'
    kfw.tvos.deployment_target = '11.0'
    kfw.dependency 'CXSwiftKit/Extension'
    kfw.dependency 'Kingfisher', '~> 6.3.1' #supports iOS 10+
  end
  
  s.subspec "SDWebImageWrapper" do |sdww|
    sdww.source_files = 'CXSwiftKit/Classes/SDWebImageWrapper/*.{swift}'
    sdww.dependency 'CXSwiftKit/Base'
    sdww.dependency 'SDWebImage', '~> 5.19.1'
  end
  
end
