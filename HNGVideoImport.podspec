#
# Be sure to run `pod lib lint HNGVideoImport.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "HNGVideoImport"
  s.version          = "0.1.0"
  s.summary          = "This libaray import videos from photo app"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  


  s.description      = "This libaray import videos from photo app. Working on it"

  s.homepage         = "https://github.com/sohail-khan/HNGVideoImport"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "sohail" => "sohail0059@gmail.com" }
  s.source           = { :git => "https://github.com/sohail-khan/HNGVideoImport.git", :branch => "master",:tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/sohail059'

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.source_files = 'Pod/Classes/*.*'
  s.resources = ["Pod/Assets/*.png","Pod/Classes/*.xib"]
  s.resource_bundles = {
    'HNGVideoImport' => ['Pod/Assets/*.png']
  }
    s.frameworks = 'UIKit', 'Photos'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
