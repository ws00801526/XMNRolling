#
#  Be sure to run `pod spec lint XMNRolling.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "XMNRolling"
  s.version      = "0.0.1"
  s.summary      = "XMNRolling 无限滚动banner"
  s.homepage     = "https://github.com/ws00801526/XMNRolling"
  s.license      = "MIT"
  s.author       = { "XMFraker" => "3057600441@qq.com" }
  s.source       = { :git => "https://github.com/ws00801526/XMNRolling.git", :tag => "#{s.version}" }
  s.source_files  = "Classes/**/*.{h,m}"
  s.resource = 'Classes/**/*.png'
  s.ios.frameworks = 'UIKit'
  s.dependency 'YYWebImage'
  s.requires_arc = true
  s.platform = :ios, 8.0
end
