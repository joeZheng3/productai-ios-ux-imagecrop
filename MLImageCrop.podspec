Pod::Spec.new do |s|

  s.name         = "MLImageCrop"
  s.version      = "1.1"
  s.summary      = "A Objective-C library for iOS used to crop or select rect of image"
  s.description  = <<-DESC
                   A Objective-C library for iOS. It provide a customizable UI for user to select or crop a rect in image.
                   DESC

  s.homepage     = "https://github.com/MalongTech/productai-ios-ux-imagecrop"
  s.screenshots  = "https://github.com/MalongTech/MLImageCroper/raw/master/Screenshot/MLImageCroperDemo1.gif"

  s.license      = "MIT"

  s.author             = { "davidear" => "wanghaihan@live.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/MalongTech/productai-ios-ux-imagecrop.git", :tag => "1.1" }

  s.source_files  = "MLImageCrop/*"
  s.public_header_files = "MLImageCrop/*.h"

  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end
