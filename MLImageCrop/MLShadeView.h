//
//  MLShadeView.h
//  MLImageCrop
//
//  Created by Haihan Wang on 16/2/3.
//  Copyright © 2016年 Malong Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLShadeView : UIView
@property (nonatomic, strong) UIColor *cropBorderColor;
@property (nonatomic) CGFloat cropBorderWidth;

@property (nonatomic, strong) UIColor *pointColor;
@property (nonatomic) CGFloat pointRadius;

@property (nonatomic, strong) UIColor *cropAreaColor;
@property (nonatomic, strong) UIColor *cropMaskColor;

@property (nonatomic) CGRect cropArea;
@end
