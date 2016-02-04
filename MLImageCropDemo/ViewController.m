//
//  ViewController.m
//  MLImageCropDemo
//
//  Created by Haihan Wang on 16/2/3.
//  Copyright © 2016年 Malong Tech. All rights reserved.
//
#import "MLImageCropController.h"
#import "ViewController.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,
                              MLImageCropControllerDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // cameral btn
    UIButton *cameraButton = [self buttonCreator:@"Camera" action:@selector(cameral:) frame:CGRectMake(20, 50, 0, 0)];
    [self.view addSubview:cameraButton];

    // library
    UIButton *librayButton = [self buttonCreator:@"Library" action:@selector(library:) frame:CGRectMake(20, 150, 0, 0)];
    [self.view addSubview:librayButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)buttonCreator:(NSString *)title action:(SEL)action frame:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 4;
    btn.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    btn.frame = frame;
    [btn sizeToFit];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark button target
- (void)cameral:(UIButton *)sender {
    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
}
- (void)library:(UIButton *)sender {
    [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        // no permission
    } else {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = sourceType;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 MLImageCropController *cropController = [[MLImageCropController alloc] init];
                                 cropController.delegate = self;
                                 cropController.image = image;
                                 // cropController.cropMaskColor = [UIColor clearColor];
                                 [self presentViewController:cropController animated:YES completion:nil];
                             }];
}

#pragma mark - ImageCropViewControllerDelegate
// you can choise one them to get the crop result.
- (void)MLImageCropDone:(MLImageCropController *)controller croppedRect:(CGRect)croppedRect {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)MLImageCropDone:(MLImageCropController *)controller
           croppedImage:(UIImage *)croppedImage
            croppedRect:(CGRect)croppedRect {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)MLImageCropDone:(MLImageCropController *)controller croppedImage:(UIImage *)croppedImage {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)MLImageCropCancel:(MLImageCropController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)MLImageCropAreaChanged:(MLImageCropController *)controller croppedRect:(CGRect)croppedRect {
}

@end
