//
//  CustomLayerDemo.m
//  MLImageCropDemo
//
//  Created by Haihan Wang on 16/3/2.
//  Copyright © 2016年 Malong Tech. All rights reserved.
//

#import "CustomLayerDemo.h"
#import "MLImageCropController.h"
#import "MLShadeView.h"
#import "ViewController.h"

/**
 *  custom view to be added
 */
@interface CustomView : UIView <MLCustomViewDelegate>
@property (nonatomic, strong) MLImageCropController *controller;
@property (nonatomic, strong) UIButton *btn;
@end
@implementation CustomView
- (instancetype)init {
    self = [super init];
    if (self) {
        _btn = [ViewController buttonCreator:@"Change Color"
                                      target:self
                                      action:@selector(changeColor:)
                                       frame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:_btn];
    }
    return self;
}
- (void)setSuperViewFrame:(CGRect)superViewFrame controller:(MLImageCropController *)controller {

    // superViewFrame is the bounds of current crop controller
    self.frame = CGRectMake(superViewFrame.origin.x + superViewFrame.size.width / 2 - 100,
                            superViewFrame.origin.y + superViewFrame.size.height / 2 - 50 - 25, 200, 50);
    _btn.frame = self.bounds;
    _controller = controller;
}
- (void)changeColor:(UIButton *)sender {

    // you can customize the crop box by set the property of shadeView
    _controller.shadeView.cropBorderColor = [CustomView getRandomColor];
    _controller.shadeView.pointColor = [CustomView getRandomColor];
    _controller.shadeView.cropAreaColor = [CustomView getRandomColor];
    _controller.shadeView.cropMaskColor = [CustomView getRandomColor];
    _controller.shadeView.cropBorderColor = [CustomView getRandomColor];

    _controller.shadeView.cropBorderWidth = arc4random() % 10;
    _controller.shadeView.pointRadius = arc4random() % 10;

    [_controller.shadeView setNeedsDisplay];
}
+ (UIColor *)getRandomColor {
    return [UIColor colorWithRed:(arc4random() % 10) / 10.0f
                           green:(arc4random() % 10) / 10.0f
                            blue:(arc4random() % 10) / 10.0f
                           alpha:(arc4random() % 10) / 10.0f];
}
@end

// demo:
@interface CustomLayerDemo () <MLImageCropControllerDelegate>

@end
@implementation CustomLayerDemo
- (void)run:(UIImage *)image {

    // step 1: init controller with image and set delegate
    MLImageCropController *cropController = [[MLImageCropController alloc] initWithImage:image];
    cropController.delegate = self;
    cropController.buttonBackgroundColor = [UIColor whiteColor];
    cropController.buttonTitleColor = [UIColor blackColor];
    cropController.buttonText = @"Go!";
    cropController.shadeView.cropAreaColor = [UIColor clearColor];
    cropController.shadeView.cropMaskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

    // step 2: set the custom view
    cropController.customView = [[CustomView alloc] init];

    // step 3: show it by present or push into navigation controller
    // push controller into new or your main navigation controller
    UINavigationController *navController = [[UINavigationController alloc] init];
    [navController pushViewController:cropController animated:YES];
    [[UIApplication sharedApplication]
            .keyWindow.rootViewController presentViewController:navController
                                                       animated:YES
                                                     completion:nil];
}

// step 4: handle the delegate of done,cancle and crop box changed(option).
#pragma mark - ImageCropViewControllerDelegate
- (void)MLImageCropDone:(MLImageCropController *)controller
           croppedImage:(UIImage *)croppedImage
            croppedRect:(CGRect)croppedRect {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)MLImageCropCancel:(MLImageCropController *)controller {
    UINavigationController *navController = [controller navigationController];
    [navController dismissViewControllerAnimated:YES completion:nil];
    [navController popViewControllerAnimated:YES];
}

- (void)MLImageCropAreaChanged:(MLImageCropController *)controller croppedRect:(CGRect)croppedRect {
}
@end
