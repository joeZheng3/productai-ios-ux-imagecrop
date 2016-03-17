# MLImageCrop
A Objective-C library for iOS. It provide a customizable UI for user to select or crop a rect in image. 

![image](https://github.com/MalongTech/MLImageCroper/blob/master/Screenshot/MLImageCroperDemo1.gif)

## Requirements
* Xcode 6 or higher
* Apple LLVM compiler
* iOS 6.0 or higher
* ARC

## Feature

## Demo

Build and run the `MLImageCropDemo` project in Xcode to see `MLImageCrop` in action.

## Installation

### CocoaPods

The recommended approach for installating `MLImageCrop` is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.
For best results, it is recommended that you install via CocoaPods >= **0.28.0** using Git >= **1.8.0** installed via Homebrew.

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Change to the directory of your Xcode project:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
```

Edit your Podfile and add RESideMenu:

``` bash
platform :ios, '6.0'
pod 'MLImageCrop'
```

Install into your Xcode project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

Please note that if your installation fails, it may be because you are installing with a version of Git lower than CocoaPods is expecting. Please ensure that you are running Git >= **1.8.0** by executing `git --version`. You can get a full picture of the installation details by executing `pod install --verbose`.

### Manual Install

All you need to do is drop `MLImageCrop` files into your project, and add `#include "MLImageCropDemo.h"` to the top of classes that will use it.

## Contact

- https://github.com/MLImageCrop
- wanghaihan@live.com

## License

MLImageCrop is available under the MIT license.

Copyright © 2016 MalongTech.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
