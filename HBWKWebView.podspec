#
# Be sure to run `pod lib lint HBWKWebView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HBWKWebView'
  s.version          = '0.1.0'
  s.summary          = 'HBWKWebView Base for WKWebView To H5.'
  s.homepage         = 'https://github.com/loveAct/HBWKWebView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'loveAct' => '413441478@qq.com' }
  s.source           = { :git => 'https://github.com/loveAct/HBWKWebView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HBWKWebView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HBWKWebView' => ['HBWKWebView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'WebViewJavascriptBridge', '~> 6.0'
  s.dependency 'Masonry',                 '1.1.0'
#  s.dependency 'KVOController',           '1.1.0'
  s.prefix_header_file = 'HBWKWebView/Classes/HBWKWebViewHeader.h'

end
