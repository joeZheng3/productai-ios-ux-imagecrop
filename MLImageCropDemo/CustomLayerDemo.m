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

    self.frame = superViewFrame;
    // superViewFrame is the bounds of current crop controller
    CGRect btnFrame = CGRectMake(superViewFrame.origin.x + superViewFrame.size.width / 2 - 100,
                                 superViewFrame.origin.y + superViewFrame.size.height / 2 - 25, 200, 50);
    _btn.frame = btnFrame;
    _controller = controller;
}

- (void)changeColor:(UIButton *)sender {

    // Customize the crop box
    _controller.shadeView.cropBorderColor = [UIColor colorWithRed:(arc4random() % 10) / 10.0f
                                                            green:(arc4random() % 10) / 10.0f
                                                             blue:(arc4random() % 10) / 10.0f
                                                            alpha:1];
    [_controller.shadeView setNeedsDisplay];
}
@end

@interface CustomLayerDemo () <MLImageCropControllerDelegate>

@end
@implementation CustomLayerDemo
- (void)run:(UIImage *)image {
    MLImageCropController *cropController = [[MLImageCropController alloc] init];
    cropController.delegate = self;
    cropController.image = image;

    cropController.customView = [[CustomView alloc] init];

    UIViewController *currentController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [currentController presentViewController:cropController animated:YES completion:nil];
}

#pragma mark - ImageCropViewControllerDelegate
- (void)MLImageCropDone:(MLImageCropController *)controller
           croppedImage:(UIImage *)croppedImage
            croppedRect:(CGRect)croppedRect {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)MLImageCropCancel:(MLImageCropController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)MLImageCropAreaChanged:(MLImageCropController *)controller croppedRect:(CGRect)croppedRect {
}
@end
