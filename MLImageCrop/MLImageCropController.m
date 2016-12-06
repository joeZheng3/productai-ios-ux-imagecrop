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
#import <objc/runtime.h>

const CGFloat BUTTON_HEIGHT = 54;

#pragma mark ImageCropViewController implementation
typedef CGRect (^ChangeReckBlock)(CGRect rect, CGPoint translation);
@interface MLImageCropController ()
@property (nonatomic) CGRect initCropAreaInImage;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) NSMutableDictionary *modifiers;

@property BOOL isInNavContorller;
@end

@implementation MLImageCropController
- (instancetype)init {
    self = [super init];
    if (self) {
        _buttonTitleColor = [UIColor blackColor];
        _buttonBackgroundColor = [UIColor colorWithRed:0.98 green:0.87 blue:0.2 alpha:1];
        _buttonText = @"OK";
        _imageView = [[UIImageView alloc] init];
        _modifiers = [[NSMutableDictionary alloc] init];
        _shadeView = [[MLShadeView alloc] init];
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
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
    _shadeView.cropArea = _cropAreaInView;
    [self.view addSubview:_shadeView];
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
    
    _doneBtn.hidden = _hideDoneButton;
}

- (void)viewDidLoad_backButton {
    _backBtn = [[UIButton alloc] init];
    _backBtn.frame = CGRectMake(10, 18, 38, 38);
    [_backBtn setTitle:@"◃" forState:UIControlStateNormal];
    _backBtn.contentEdgeInsets = UIEdgeInsetsMake(1, 0, 0, 6);
    [_backBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    [_backBtn.layer setCornerRadius:19];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:26];
    [_backBtn setTitleColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.7] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    _backBtn.hidden = _hideBackButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)initSubviews {
    self.view.multipleTouchEnabled = YES;
    self.view.backgroundColor = [UIColor blackColor];
    [self viewDidLoad_imageView];
    [self viewDidLoad_shadeView];
    [self viewDidLoad_doneButton];
    [self viewDidLoad_backButton];
    if (_customView) {
        [self.view addSubview:_customView];
    }
}
- (void)viewWillAppear_views {
    UINavigationController *navController = [self navigationController];
    CGRect viewFrame;
    if (navController != nil) {
        float viewHeight = navController.view.frame.size.height - [navController navigationBar].bounds.size.height -
                           [[UIApplication sharedApplication] statusBarFrame].size.height;
        viewFrame = CGRectMake(0, 0, self.view.bounds.size.width, viewHeight);
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
    if (_hideDoneButton) {
        _shadeView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height);
    }
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
    [self setupSubviews];
}

- (void)setupSubviews {
    // views
    [self viewWillAppear_views];
    // crop area
    [self viewWillAppear_cropAreaInView];
}

- (MLRectModifier *)getModifier:(CGRect)imageFrame byPoint:(CGPoint)point {
    if ([MLRectModifier_LeftTop isHit:_cropAreaInView byTouchLocation:point]) {
        return [[MLRectModifier_LeftTop alloc] initWithAvailableArea:imageFrame startPoint:point];
    }
    if ([MLRectModifier_RightTop isHit:_cropAreaInView byTouchLocation:point]) {
        return [[MLRectModifier_RightTop alloc] initWithAvailableArea:imageFrame startPoint:point];
    }
    if ([MLRectModifier_RightBottom isHit:_cropAreaInView byTouchLocation:point]) {
        return [[MLRectModifier_RightBottom alloc] initWithAvailableArea:imageFrame startPoint:point];
    }
    if ([MLRectModifier_LeftBottom isHit:_cropAreaInView byTouchLocation:point]) {
        return [[MLRectModifier_LeftBottom alloc] initWithAvailableArea:imageFrame startPoint:point];
    }
    if ([MLRectModifier_LeftEdge isHit:_cropAreaInView byTouchLocation:point]) {
        return [[MLRectModifier_LeftEdge alloc] initWithAvailableArea:imageFrame startPoint:point];
    }
    if ([MLRectModifier_TopEdge isHit:_cropAreaInView byTouchLocation:point]) {
        return [[MLRectModifier_TopEdge alloc] initWithAvailableArea:imageFrame startPoint:point];
    }
    if ([MLRectModifier_RightEdge isHit:_cropAreaInView byTouchLocation:point]) {
        return [[MLRectModifier_RightEdge alloc] initWithAvailableArea:imageFrame startPoint:point];
    }
    if ([MLRectModifier_BottomEdge isHit:_cropAreaInView byTouchLocation:point]) {
        return [[MLRectModifier_BottomEdge alloc] initWithAvailableArea:imageFrame startPoint:point];
    }
    if ([MLRectModifier_Body isHit:_cropAreaInView byTouchLocation:point]) {
        return [[MLRectModifier_Body alloc] initWithAvailableArea:imageFrame startPoint:point];
    }
    return nil;
}

- (void)startMoving:(NSSet<UITouch *> *)touches {
    // [_modifiers removeAllObjects];
    CGRect imageFrame = _imageView.frame;
    for (UITouch *touch in touches) {
        CGPoint touchPoint = [self getLocation:touch InView:self.view];
        MLRectModifier *modifier = [self getModifier:imageFrame byPoint:touchPoint];
        NSValue *key = [NSValue valueWithNonretainedObject:touches];
        _modifiers[key] = modifier;
    }
}
- (void)stopMoving {
    [_modifiers removeAllObjects];
    [self cropAreaChanged];
    // NSLog(@"end");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startMoving:event.allTouches];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    @synchronized(self) {
        for (UITouch *touch in event.allTouches) {
            CGPoint touchPoint = [self getLocation:touch InView:self.view];
            NSValue *key = [NSValue valueWithNonretainedObject:touch];
            MLRectModifier *modifier = [_modifiers objectForKey:key];
            if (!modifier) {
                modifier = [self getModifier:_imageView.frame byPoint:touchPoint];
                _modifiers[key] = modifier;
            } else {
                CGPoint translation =
                    CGPointMake(touchPoint.x - modifier.lastPoint.x, touchPoint.y - modifier.lastPoint.y);
                static int stepLen = 10;
                static int loopThreshold = 40;
                if (fabs(translation.x) > loopThreshold || fabs(translation.y) > loopThreshold) {
                    // reduce the block when only move the second finger
                    float x = translation.x;
                    float y = translation.y;
                    int loopTime = MAX(fabsf(x / stepLen), fabsf(y / stepLen));
                    float stepX = x / loopTime;
                    float stepY = y / loopTime;
                    CGPoint stepTranslation = CGPointMake(stepX, stepY);
                    for (int i = 0; i < loopTime; i++) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                            // NSLog(@"%f,%f  %d", x, y, loopTime);
                            self.cropAreaInView = [modifier modifyRect:_cropAreaInView byTranslation:stepTranslation];
                        });
                    }
                } else {
                    self.cropAreaInView = [modifier modifyRect:_cropAreaInView byTranslation:translation];
                }
            }
        }
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stopMoving];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stopMoving];
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
    if (_hideDoneButton) {
        frameHeight = self.view.frame.size.height - _imageMargin.top - _imageMargin.bottom;
    }
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

- (CGPoint)getLocation:(UITouch *)touch InView:(nullable UIView *)view {
    return [touch preciseLocationInView:self.view];
}

// due to preciseLocationInView is only works after 9.1, so make locationInview instead
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_1
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([UIDevice currentDevice].systemVersion.floatValue < 9.1f) {
            Method oriMethod = class_getInstanceMethod(self, @selector(getLocation:InView:));
            Method newMethod = class_getInstanceMethod(self, @selector(getLocation_8:InView:));
            method_exchangeImplementations(oriMethod, newMethod);
        }
    });
}

- (CGPoint)getLocation_8:(UITouch *)touch InView:(nullable UIView *)view {
    return [touch locationInView:self.view];
}
#endif
@end
