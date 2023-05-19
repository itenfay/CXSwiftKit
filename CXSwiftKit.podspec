#
# Be sure to run `pod lib lint CXSwiftKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CXSwiftKit'
  s.version          = '1.2.0'
  s.summary          = 'CXSwiftKit provides rich extensions of swift language, also supports Objective-C.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  CXSwiftKit provides rich extensions of swift language, also supports Objective-C.
                       DESC

  s.homepage         = 'https://github.com/chenxing640/CXSwiftKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chenxing' => 'chenxing640@foxmail.com' }
  s.source           = { :git => 'https://github.com/chenxing640/CXSwiftKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.swift_versions = ['4.2', '5.0']
  
  s.ios.deployment_target = '10.0'
  #s.osx.deployment_target = '10.10'
  #s.tvos.deployment_target = '10.0'
  #s.watchos.deployment_target = "3.0"
  
  s.requires_arc = true
  
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
  
  s.subspec "ApplePay" do |applepay|
    applepay.source_files = 'CXSwiftKit/Classes/ApplePay/*.{swift}'
    applepay.resource = 'CXSwiftKit/Assets/ApplePay/*.png'
    applepay.dependency 'CXSwiftKit/Base'
  end
  
  s.subspec "Protocol" do |pt|
    pt.source_files = 'CXSwiftKit/Classes/Protocol/*.{swift}'
  end
  
  s.subspec "Extension" do |ext|
    ext.source_files = 'CXSwiftKit/Classes/Extension/*.{swift}'
    ext.dependency 'CXSwiftKit/Base'
    ext.dependency 'CXSwiftKit/Protocol'
  end
  
  s.subspec "FileOperation" do |fo|
    fo.source_files = 'CXSwiftKit/Classes/FileOperation/*.{swift}'
    fo.dependency 'CXSwiftKit/Extension'
  end
  
  s.subspec "LiveGift" do |livegift|
    livegift.source_files = 'CXSwiftKit/Classes/LiveGift/*.{swift}'
    livegift.dependency 'CXSwiftKit/Extension'
  end
  
  s.subspec "NetWork" do |network|
    network.source_files = 'CXSwiftKit/Classes/NetWork/*.{swift}'
    network.dependency 'CXSwiftKit/Base'
  end
  
  s.subspec "Core" do |core|
    core.source_files = 'CXSwiftKit/Classes/Core/*.{swift}'
    #core.dependency 'DYFSwiftKeychain'
    core.dependency 'CXSwiftKit/Extension'
    core.dependency 'CXSwiftKit/FileOperation'
    
    core.subspec "AVToolbox" do |avtb|
      avtb.source_files = 'CXSwiftKit/Classes/Core/AVToolbox/*.{swift}'
      avtb.dependency 'CXSwiftKit/FileOperation'
    end
    
    core.subspec "DocumentPicker" do |dp|
      dp.source_files = 'CXSwiftKit/Classes/Core/DocumentPicker/*.{swift}'
    end
    
    core.subspec "EmptyDataSet" do |eds|
      eds.source_files = 'CXSwiftKit/Classes/Core/EmptyDataSet/*.{swift}'
      eds.dependency 'CXSwiftKit/Extension'
    end
    
    core.subspec "Permissions" do |pm|
      pm.source_files = 'CXSwiftKit/Classes/Core/Permissions/*.{swift}'
      pm.dependency 'CXSwiftKit/Base'
    end
    
    core.subspec "svga" do |svga|
      svga.source_files = 'CXSwiftKit/Classes/Core/svga/*.{swift}'
      svga.dependency 'CXSwiftKit/Base'
    end
    
    core.subspec "Timer" do |timer|
      timer.source_files = 'CXSwiftKit/Classes/Core/Timer/*.{swift}'
    end
    
    core.subspec "Transition" do |transition|
      transition.source_files = 'CXSwiftKit/Classes/Core/Transition/*.{swift}'
      transition.dependency 'CXSwiftKit/Extension'
    end
    
    core.subspec "WebSocket" do |ws|
      ws.source_files = 'CXSwiftKit/Classes/Core/WebSocket/*.{swift}'
      ws.dependency 'CXSwiftKit/Base'
    end
    
    core.subspec "Widget" do |wd|
      wd.source_files = 'CXSwiftKit/Classes/Core/Widget/*.{swift}'
      wd.dependency 'CXSwiftKit/Base'
    end
    
  end
  
  s.subspec "Rx" do |rx|
    rx.source_files = 'CXSwiftKit/Classes/Rx/*.{swift}'
    rx.dependency 'CXSwiftKit/Core/EmptyDataSet'
  end
  
end
