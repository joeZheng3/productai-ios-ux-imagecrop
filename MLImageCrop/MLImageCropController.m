//
//  MLImageCropControllerViewController.m
//  MLImageCrop
//
//  Created by Haihan Wang on 16/2/3.
//  Copyright © 2016年 Malong Tech. All rights reserved.
//

#import "MLImageCropController.h"
#import "MLRectModifier.h"
#import "MLShadeView.h"

const CGFloat BUTTON_HEIGHT = 54;

#pragma mark ImageCropViewController implementation
typedef CGRect (^ChangeReckBlock)(CGRect rect, CGPoint translation);
@interface MLImageCropController ()
@property (nonatomic) CGRect initCropAreaInImage;
@property (nonatomic, strong) MLRectModifier *currentModifier;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property BOOL isInNavContorller;
@end

@implementation MLImageCropController
- (instancetype)init {
    self = [super init];
    if (self) {
        _buttonTitleColor = [UIColor blackColor];
        _buttonBackgroundColor = [UIColor colorWithRed:0.98 green:0.87 blue:0.2 alpha:1];
        _buttonText = @"确定";
        _imageView = [[UIImageView alloc] init];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    self = [self init];
    if (self) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad_imageView {
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.view addSubview:_imageView];
}

- (void)viewDidLoad_shadeView {
    // shade should not hide the button
    _shadeView = [[MLShadeView alloc] init];
    _shadeView.cropArea = _cropAreaInView;
    [self.view addSubview:_shadeView];
}
- (void)viewDidLoad_recognizer {
    UIPanGestureRecognizer *panRecognizer =
        [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:panRecognizer];
}

- (void)viewDidLoad_doneButton {
    _doneBtn = [[UIButton alloc] init];
    [_doneBtn setBackgroundColor:_buttonBackgroundColor];
    [_doneBtn setTitle:_buttonText forState:UIControlStateNormal];
    [_doneBtn setTitleColor:_buttonTitleColor forState:UIControlStateNormal];

    [_doneBtn setBackgroundImage:[MLImageCropController lighterImageByColor:_buttonBackgroundColor]
                        forState:UIControlStateHighlighted];
    [_doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_doneBtn];
}

- (void)viewDidLoad_backButton {
    _backBtn = [[UIButton alloc] init];
    _backBtn.frame = CGRectMake(0, 0, 44, 44);
    [_backBtn setTitle:@"<" forState:UIControlStateNormal];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self viewDidLoad_imageView];
    [self viewDidLoad_shadeView];
    [self viewDidLoad_recognizer];
    [self viewDidLoad_doneButton];
    [self viewDidLoad_backButton];
    if (_customView) {
        [self.view addSubview:_customView];
    }
}
- (void)viewWillAppear_views {

    _isInNavContorller = [self navigationController] != nil;
    CGRect viewFrame;
    if (_isInNavContorller) {
        viewFrame =
            CGRectMake(0, 0, self.view.bounds.size.width,
                       self.view.bounds.size.height - [[self navigationController] navigationBar].bounds.size.height -
                           [[UIApplication sharedApplication] statusBarFrame].size.height);
        _backBtn.hidden = YES;
        self.navigationItem.leftBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                          target:self
                                                          action:@selector(cancel)];
        [self.navigationItem setRightBarButtonItem:nil];
    } else {
        viewFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }

    self.view.frame = viewFrame;
    _shadeView.frame =
        CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height - BUTTON_HEIGHT);
    _doneBtn.frame =
        CGRectMake(0, viewFrame.origin.y + viewFrame.size.height - BUTTON_HEIGHT, viewFrame.size.width, BUTTON_HEIGHT);
    if (_customView) {
        [_customView setSuperViewFrame:viewFrame controller:self];
    }
    _imageView.frame = [self calculateImageFrameAndSetScale];
}

- (void)viewWillAppear_cropAreaInView {
    if (!CGRectIsEmpty(_initCropAreaInImage)) {
        self.cropArea = _initCropAreaInImage;
        _initCropAreaInImage = CGRectZero;
    }
    // default crop area
    if (CGRectIsEmpty(_cropAreaInView)) {
        CGRect imageFrame = self.imageView.frame;
        // set a default crop
        CGFloat width = imageFrame.size.width;
        CGFloat height = imageFrame.size.height;
        self.cropAreaInView =
            CGRectMake(imageFrame.origin.x + width / 4, imageFrame.origin.y + height / 4, width / 2, height / 2);
    }
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    // views
    [self viewWillAppear_views];
    // crop area
    [self viewWillAppear_cropAreaInView];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    // todo : current only support one touche
    // CGPoint translation = [recognizer translationInView:self.view];
    // NSLog(@"count:%lu translation x:%f y: %f", (unsigned long) count, translation.x, translation.y);
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point0 = [recognizer locationOfTouch:0 inView:self.view];
        // NSLog(@"point %d: x:%f y: %f", 0, point0.x, point0.y);
        CGRect imageFrame = _imageView.frame;
        if ([MLRectModifier_LeftTop isHit:_cropAreaInView byTouchLocation:point0]) {
            _currentModifier = [[MLRectModifier_LeftTop alloc] initWithAvailableArea:imageFrame];
            return;
        }
        if ([MLRectModifier_RightTop isHit:_cropAreaInView byTouchLocation:point0]) {
            _currentModifier = [[MLRectModifier_RightTop alloc] initWithAvailableArea:imageFrame];
            return;
        }
        if ([MLRectModifier_RightBottom isHit:_cropAreaInView byTouchLocation:point0]) {
            _currentModifier = [[MLRectModifier_RightBottom alloc] initWithAvailableArea:imageFrame];
            return;
        }
        if ([MLRectModifier_LeftBottom isHit:_cropAreaInView byTouchLocation:point0]) {
            _currentModifier = [[MLRectModifier_LeftBottom alloc] initWithAvailableArea:imageFrame];
            return;
        }
        if ([MLRectModifier_LeftEdge isHit:_cropAreaInView byTouchLocation:point0]) {
            _currentModifier = [[MLRectModifier_LeftEdge alloc] initWithAvailableArea:imageFrame];
            return;
        }
        if ([MLRectModifier_TopEdge isHit:_cropAreaInView byTouchLocation:point0]) {
            _currentModifier = [[MLRectModifier_TopEdge alloc] initWithAvailableArea:imageFrame];
            return;
        }
        if ([MLRectModifier_RightEdge isHit:_cropAreaInView byTouchLocation:point0]) {
            _currentModifier = [[MLRectModifier_RightEdge alloc] initWithAvailableArea:imageFrame];
            return;
        }
        if ([MLRectModifier_BottomEdge isHit:_cropAreaInView byTouchLocation:point0]) {
            _currentModifier = [[MLRectModifier_BottomEdge alloc] initWithAvailableArea:imageFrame];
            return;
        }
        if ([MLRectModifier_Body isHit:_cropAreaInView byTouchLocation:point0]) {
            _currentModifier = [[MLRectModifier_Body alloc] initWithAvailableArea:imageFrame];
            return;
        }
        _currentModifier = nil;
        return;

    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (_currentModifier) {
            // CGPoint point0 = [recognizer locationOfTouch:0 inView:self.view];
            // NSLog(@"point %d: x:%f y: %f", 0, point0.x, point0.y);

            CGPoint translation = [recognizer translationInView:self.view];
            //_cropAreaInView = self.currentChangeRectBlock(_cropAreaInView, translation);

            self.cropAreaInView = [self.currentModifier modifyRect:_cropAreaInView byTranslation:translation];
            [recognizer setTranslation:self.currentModifier.restTranslation inView:self.view];
        }
    } else {
        if (_currentModifier) {
            _currentModifier = nil;
            [self cropAreaChanged];
        }
        return;
    }
}

- (void)cropAreaChanged {
    if ([self.delegate respondsToSelector:@selector(MLImageCropAreaChanged:croppedRect:)]) {
        [self.delegate MLImageCropAreaChanged:self croppedRect:self.cropArea];
    }
}

- (void)cancel {
    if ([self.delegate respondsToSelector:@selector(MLImageCropCancel:)]) {
        [self.delegate MLImageCropCancel:self];
    }
}

- (void)done {
    UIImage *croppedImage;
    if ([self.delegate respondsToSelector:@selector(MLImageCropDone:croppedRect:)]) {
        [self.delegate MLImageCropDone:self croppedRect:self.cropArea];
    }
    if ([self.delegate respondsToSelector:@selector(MLImageCropDone:croppedImage:)]) {
        croppedImage = [MLImageCropController cropIamge:_image ByRect:self.cropArea];
        [self.delegate MLImageCropDone:self croppedImage:croppedImage];
    }

    if ([self.delegate respondsToSelector:@selector(MLImageCropDone:croppedImage:croppedRect:)]) {
        if (croppedImage == nil) {
            croppedImage = [MLImageCropController cropIamge:_image ByRect:self.cropArea];
        }
        [self.delegate MLImageCropDone:self croppedImage:croppedImage croppedRect:self.cropArea];
    }
}

- (UIImage *)croppedIamge {
    return [MLImageCropController cropIamge:_image ByRect:self.cropArea];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = _image;
    if (self.isViewLoaded) {
        _imageView.frame = [self calculateImageFrameAndSetScale];
    }
}

- (void)setCropArea:(CGRect)area {
    CGRect imageFrameInView = _imageView.frame;
    // if the image frame is enmpty just save it and let the view appear event to trigger it again
    if (CGRectIsEmpty(imageFrameInView)) {
        _initCropAreaInImage = area;
        return;
    }
    CGRect r = CGRectMake(area.origin.x / self.imageScale + imageFrameInView.origin.x,
                          area.origin.y / self.imageScale + imageFrameInView.origin.y,
                          area.size.width / self.imageScale, area.size.height / self.imageScale);
    self.cropAreaInView = r;
}

- (CGRect)cropArea {
    CGRect imageFrameInView = _imageView.frame;
    CGRect r =
        CGRectMake(((_cropAreaInView.origin.x - imageFrameInView.origin.x) * _imageScale),
                   ((_cropAreaInView.origin.y - imageFrameInView.origin.y) * _imageScale),
                   (_cropAreaInView.size.width * self.imageScale), (_cropAreaInView.size.height * self.imageScale));
    return r;
}

- (void)setCropAreaInView:(CGRect)cropAreaInView {
    _cropAreaInView = cropAreaInView;
    _shadeView.cropArea = _cropAreaInView;
}
- (void)setCustomView:(UIView<MLCustomViewDelegate> *)customView {
    if (self.isViewLoaded) {
        if (_customView) {
            [_customView removeFromSuperview];
        }
        _customView = customView;
        [_customView setSuperViewFrame:self.view.frame controller:self];
        [self.view addSubview:customView];
        [self.view setNeedsDisplay];
    } else {
        _customView = customView;
    }
}
- (CGRect)calculateImageFrameAndSetScale {
    CGFloat frameWidth = self.view.frame.size.width - _imageMargin.left - _imageMargin.right;
    CGFloat frameHeight = self.view.frame.size.height - BUTTON_HEIGHT - _imageMargin.top - _imageMargin.bottom;
    CGFloat imageWidth = _image.size.width;
    CGFloat imageHeight = _image.size.height;
    BOOL isPortrait = imageHeight / frameHeight > imageWidth / frameWidth;
    int x, y;
    int scaledImageWidth, scaledImageHeight;
    if (isPortrait) {
        _imageScale = imageHeight / frameHeight;
        scaledImageWidth = imageWidth / _imageScale;
        scaledImageHeight = frameHeight;
        x = (frameWidth - scaledImageWidth) / 2;
        y = 0;
    } else {
        _imageScale = imageWidth / frameWidth;
        scaledImageWidth = frameWidth;
        scaledImageHeight = imageHeight / _imageScale;
        x = 0;
        y = (frameHeight - scaledImageHeight) / 2;
    }
    return CGRectMake(x + _imageMargin.left, y + _imageMargin.top, scaledImageWidth, scaledImageHeight);
}

- (void)setImageMargin:(UIEdgeInsets)imageMargin {
    _imageMargin = imageMargin;
    if (!CGRectIsEmpty(_imageView.frame)) {
        CGRect imageCropArea = self.cropArea;
        _imageView.frame = [self calculateImageFrameAndSetScale];
        // should recalculate crop area due to image is moved.
        self.cropArea = imageCropArea;
    }
}

+ (UIImage *)lighterImageByColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetFillColorWithColor(context, [[[UIColor alloc] initWithWhite:1 alpha:0.3] CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)cropIamge:(UIImage *)image ByRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

@end
