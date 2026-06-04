Pod::Spec.new do |s|
  s.name             = 'CodelyticalLivenessSDK'
  s.version          = '1.0.0'
  s.summary          = 'Face liveness / anti-spoofing SDK for iOS (SwiftUI).'
  s.description      = <<-DESC
    CodelyticalLivenessSDK provides a drop-in SwiftUI face liveness screen
    backed by MTCNN face detection and a TFLite anti-spoofing model.
    Online API-key validation, no capture button — fully automatic.
  DESC

  s.homepage         = 'https://www.codelyticalhub.com'
  s.license          = { :type => 'Commercial', :text => 'Copyright CodeLytical. All rights reserved.' }
  s.author           = { 'CodeLytical' => 'codelyticalhub@gmail.com' }
  s.platform         = :ios, '15.0'
  s.swift_version    = '5.9'

  s.source = {
    :http => 'https://github.com/CodeLytialHub/liveness-ios/releases/download/1.0.0/CodelyticalLivenessSDK.xcframework.zip'
  }

  s.vendored_frameworks = 'CodelyticalLivenessSDK.xcframework'
  s.frameworks = 'AVFoundation', 'UIKit', 'CoreImage', 'CoreMedia', 'CoreVideo'
end