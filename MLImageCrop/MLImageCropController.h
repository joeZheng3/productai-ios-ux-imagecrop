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
/**
 *  trigger when user click back
 *
 *  @param controller MLImageCropController
 */
- (void)MLImageCropCancel:(MLImageCropController *)controller;
@optional

// you can choice any MLImageCropDone: you need to handle Done button click event.
/**
 *  trigger with image and rect when user click Done.
 *
 *  @param controller   MLImageCropController
 *  @param croppedImage cropped image
 *  @param croppedRect  cropped rect
 */
- (void)MLImageCropDone:(MLImageCropController *)controller
           croppedImage:(UIImage *)croppedImage
            croppedRect:(CGRect)croppedRect;
/**
 *  trigger with image when user click Done.
 *
 *  @param controller   MLImageCropController
 *  @param croppedImage cropped image
 */
- (void)MLImageCropDone:(MLImageCropController *)controller croppedImage:(UIImage *)croppedImage;
/**
 *  trigger with rect when user click Done.
 *
 *  @param controller   MLImageCropController
 *  @param croppedRect  cropped rect
 */
- (void)MLImageCropDone:(MLImageCropController *)controller croppedRect:(CGRect)croppedRect;

/**
 *  trigger when cropped rect changed
 *
 *  @param controller  MLImageCropController
 *  @param croppedRect new cropped rect
 */
- (void)MLImageCropAreaChanged:(MLImageCropController *)controller croppedRect:(CGRect)croppedRect;
@end

/**
 *  if you want to add a custom view to the crop controller, you could follow this delegate to handle the event that
 * crop view frame have changed.
 */
@protocol MLCustomViewDelegate <NSObject>
/**
 *  trigger when the view of controller have changed the frame.
 *
 *  @param superViewFrame frame of MLImageCropController
 *  @param controller     MLImageCropController
 */
- (void)setSuperViewFrame:(CGRect)superViewFrame controller:(MLImageCropController *)controller;
@end

@interface MLImageCropController : UIViewController

@property (nonatomic, strong) id<MLImageCropControllerDelegate> delegate;

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

@property (assign, nonatomic) BOOL hideBackButton;
@property (assign, nonatomic) BOOL hideDoneButton;

/**
 *  init
 *
 *  @param image image to crop
 *
 *  @return
 */
- (id)initWithImage:(UIImage *)image;

// support when only use MLImageCropController.view
- (void)initSubviews;
- (void)setupSubviews;

@end
