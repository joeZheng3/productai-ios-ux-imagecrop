//
//  ViewController.h
//  MLImageCropDemo
//
//  Created by Haihan Wang on 16/2/3.
//  Copyright © 2016年 Malong Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cropDemo <NSObject>
- (void)run:(nonnull UIImage *)image;
@end

@interface ViewController : UIViewController
+ (nonnull UIButton *)buttonCreator:(nonnull NSString *)title
                             target:(nullable id)target
                             action:(nonnull SEL)action
                              frame:(CGRect)frame;
@end
