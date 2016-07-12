Pod::Spec.new do |s|

  s.name         = "MLImageCrop"
  s.version      = "0.12"
  s.summary      = "A Objective-C library for iOS used to crop or select rect of image"
  s.description  = <<-DESC
                   A Objective-C library for iOS. It provide a customizable UI for user to select or crop a rect in image.
                   DESC

  s.homepage     = "https://github.com/malongtech/MLImageCrop"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"

  s.author             = { "Haihan Wang" => "wanghaihan@live.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/malongtech/MLImageCrop.git", :tag => "0.12" }

  s.source_files  = "MLImageCrop/*"
  s.public_header_files = "MLImageCrop/*.h"

  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end
