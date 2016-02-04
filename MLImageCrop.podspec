Pod::Spec.new do |s|

  s.name         = "MLImageCrop"
  s.version      = "0.0.1"
  s.summary      = "A Objective-C library for iOS. It provide a customizable UI for user to select or crop a rect in image."
  s.description  = <<-DESC
                   A Objective-C library for iOS used to crop or select rect of image
                   DESC

  s.homepage     = "https://github.com/malongtech/MLImageCrop"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"

  s.author             = { "Haihan Wang" => "wanghaihan@live.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/malongtech/MLImageCrop.git", :tag => "0.0.1" }

  s.source_files  = "MLImageCrop/*"
  # s.exclude_files = "Classes/Exclude"
  s.public_header_files = "MLImageCrop/MLImageCropController.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'
  # s.libraries = "iconv", "xml2"

  # s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
