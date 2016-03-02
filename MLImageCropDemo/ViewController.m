//
//  ViewController.m
//  MLImageCropDemo
//
//  Created by Haihan Wang on 16/2/3.
//  Copyright © 2016年 Malong Tech. All rights reserved.
//
#import "BasicDemo.h"
#import "CustomLayerDemo.h"
#import "ViewController.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSObject<cropDemo> *currentDomeRunner;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[ViewController buttonCreator:@"Basic Demo"
                                                 target:self
                                                 action:@selector(basic:)
                                                  frame:CGRectMake(20, 50, 0, 0)]];
    [self.view addSubview:[ViewController buttonCreator:@"Custom Layer Demo"
                                                 target:self
                                                 action:@selector(custom:)
                                                  frame:CGRectMake(20, 100, 0, 0)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (UIButton *)buttonCreator:(NSString *)title target:(nullable id)target action:(SEL)action frame:(CGRect)frame {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 4;
    btn.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    btn.frame = frame;
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark deoms
- (void)basic:(UIButton *)sender {
    _currentDomeRunner = [[BasicDemo alloc] init];
    [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (void)custom:(UIButton *)sender {
    _currentDomeRunner = [[CustomLayerDemo alloc] init];
    [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark Image Picker
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
                                 // run the demo by image
                                 [_currentDomeRunner run:image];
                             }];
}

@end
