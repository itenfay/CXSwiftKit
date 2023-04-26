#
# Be sure to run `pod lib lint CXSwiftKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CXSwiftKit'
  s.version          = '1.0.12'
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
  #s.osx.deployment_target = '10.9'
  #s.tvos.deployment_target = '9.0'
  
  s.requires_arc = true
  
  s.source_files = 'CXSwiftKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CXSwiftKit' => ['CXSwiftKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
#  s.subspec "Core" do |core|
#      core.source_files = 'CXSwiftKit/Classes/Core/*.{swift}'
#      core.dependency 'DYFSwiftKeychain'
#
#      core.subspec "Base" do |base|
#          base.source_files = 'CXSwiftKit/Classes/Core/Base/*.{swift}'
#      end
#
#      core.subspec "AVToolbox" do |avtb|
#          avtb.source_files = 'CXSwiftKit/Classes/Core/AVToolbox/*.{swift}'
#      end
#
#  end
#
#  s.subspec "Extension" do |ext|
#      ext.source_files = 'CXSwiftKit/Classes/Extension/*.{swift}'
#
#      ext.subspec "Rx" do |rx|
#          rx.source_files = 'CXSwiftKit/Classes/Extension/Rx/*.{swift}'
#      end
#  end
  
end
