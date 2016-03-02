//
//  BasicDemo.m
//  MLImageCropDemo
//
//  Created by Haihan Wang on 16/3/2.
//  Copyright © 2016年 Malong Tech. All rights reserved.
//

#import "BasicDemo.h"
#import "MLImageCropController.h"

@interface BasicDemo () <MLImageCropControllerDelegate>

@end

@implementation BasicDemo
- (void)run:(UIImage *)image {
    MLImageCropController *cropController = [[MLImageCropController alloc] init];
    cropController.delegate = self;
    cropController.image = image;
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
