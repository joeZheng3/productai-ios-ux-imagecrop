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
    // step 1: init controller with image and set delegate
    MLImageCropController *cropController = [[MLImageCropController alloc] initWithImage:image];
    cropController.delegate = self;

    // step 2: show it by present or push into navigation controller
    UIViewController *currentController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [currentController presentViewController:cropController animated:YES completion:nil];
}

// step 3: handle the delegate of done,cancle and crop box changed(option).
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
