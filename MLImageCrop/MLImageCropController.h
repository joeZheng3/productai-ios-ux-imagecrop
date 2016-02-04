//
//  MLImageCropControllerViewController.h
//  MLImageCrop
//
//  Created by Haihan Wang on 16/2/3.
//  Copyright © 2016年 Malong Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLShadeView;
@class MLImageCropController;

@protocol MLImageCropControllerDelegate <NSObject>
- (void)MLImageCropCancel:(MLImageCropController *)controller;
@optional
- (void)MLImageCropDone:(MLImageCropController *)controller
           croppedImage:(UIImage *)croppedImage
            croppedRect:(CGRect)croppedRect;
- (void)MLImageCropDone:(MLImageCropController *)controller croppedImage:(UIImage *)croppedImage;
- (void)MLImageCropDone:(MLImageCropController *)controller croppedRect:(CGRect)croppedRect;
- (void)MLImageCropAreaChanged:(MLImageCropController *)controller croppedRect:(CGRect)croppedRect;
@end

@protocol MLCustomViewDelegate <NSObject>
- (void)setSuperViewFrame:(CGRect)superViewFrame controller:(MLImageCropController *)controller;
@end

@interface MLImageCropController : UIViewController
@property (nonatomic, weak) id<MLImageCropControllerDelegate> delegate;

@property (nonatomic, strong) UIColor *cropBorderColor;
@property (nonatomic) CGFloat cropBorderWidth;

@property (nonatomic, strong) UIColor *pointColor;
@property (nonatomic) CGFloat pointRadius;

@property (nonatomic, strong) UIColor *cropAreaColor;
@property (nonatomic, strong) UIColor *cropMaskColor;

@property (nonatomic, strong) UIColor *buttonTitleColor;
@property (nonatomic, strong) UIColor *buttonBackgroundColor;
@property (nonatomic, strong) NSString *buttonText;

@property (nonatomic, strong) UIView<MLCustomViewDelegate> *customView;

@property (nonatomic) CGRect cropArea;
@property (nonatomic) UIEdgeInsets imageMargin;
@property (nonatomic, strong, readonly) UIImage *croppedIamge;
@property (nonatomic, readonly) CGRect cropAreaInView;
@property (nonatomic, readonly) CGFloat imageScale;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) MLShadeView *shadeView;

- (id)initWithImage:(UIImage *)image;
@end
