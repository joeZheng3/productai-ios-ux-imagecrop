//
//  MLRectModifier.m
//  MLImageCrop
//
//  Created by Haihan Wang on 16/2/3.
//  Copyright © 2016年 Malong Tech. All rights reserved.
//

#import "MLRectModifier.h"

float TOUCH_SIZE_IN = 15;
float TOUCH_SIZE_OUT = 35;
@interface MLRectModifier ()
@property (nonatomic) CGFloat minX;
@property (nonatomic) CGFloat minY;
@property (nonatomic) CGFloat maxX;
@property (nonatomic) CGFloat maxY;
@end

@implementation MLRectModifier
- (instancetype)initWithAvailableArea:(CGRect)availableArea startPoint:(CGPoint)startPoint {
    self = [super init];
    if (self) {
        self.availableArea = availableArea;
        self.lastPoint = startPoint;
    }
    return self;
}

- (void)setAvailableArea:(CGRect)availableArea {
    _availableArea = availableArea;
    _minX = CGRectGetMinX(availableArea);
    _minY = CGRectGetMinY(availableArea);
    _maxX = CGRectGetMaxX(availableArea);
    _maxY = CGRectGetMaxY(availableArea);
}

+ (BOOL)isHit:(CGRect)rect byTouchLocation:(CGPoint)TouchLocation {
    @throw [NSException exceptionWithName:@"Method not be implement" reason:@"must be override here" userInfo:nil];
}
- (CGRect)modifyRect:(CGRect)rect byTranslation:(CGPoint)translation {
    @throw [NSException exceptionWithName:@"Method not be implement" reason:@"must be override here" userInfo:nil];
}

- (CGPoint)getSafeTranslation:(CGPoint)translation byNewRect:(CGRect)newRect {
    CGFloat restX = CGRectGetMinX(newRect) - _minX;
    if (restX > 0) {
        restX = CGRectGetMaxX(newRect) - _maxX;
        if (restX < 0) {
            // if in the area, needn't rest distance
            restX = 0;
        }
    }
    CGFloat restY = CGRectGetMinY(newRect) - _minY;
    if (restY > 0) {
        restY = CGRectGetMaxY(newRect) - _maxY;
        if (restY < 0) {
            restY = 0;
        }
    }
    // self.restTranslation = CGPointMake(restX, restY);
    return CGPointMake(translation.x - restX, translation.y - restY);
}

- (CGPoint)getSafeTranslation:(CGPoint)translation byNewPoint:(CGPoint)newPoint {
    CGFloat restX = newPoint.x - _minX;
    if (restX > 0) {
        restX = newPoint.x - _maxX;
        if (restX < 0) {
            // if in the area, needn't rest distance
            restX = 0;
        }
    }
    CGFloat restY = newPoint.y - _minY;
    if (restY > 0) {
        restY = newPoint.y - _maxY;
        if (restY < 0) {
            restY = 0;
        }
    }
    // self.restTranslation = CGPointMake(restX, restY);
    return CGPointMake(translation.x - restX, translation.y - restY);
}

- (CGPoint)getSafeTranslation:(CGPoint)translation byNewX:(CGFloat)newX {
    CGFloat restX = newX - _minX;
    if (restX > 0) {
        restX = newX - _maxX;
        if (restX < 0) {
            restX = 0;
        }
    }
    // self.restTranslation = CGPointMake(restX, 0);
    return CGPointMake(translation.x - restX, translation.y);
}

- (CGPoint)getSafeTranslation:(CGPoint)translation byNewY:(CGFloat)newY {
    CGFloat restY = newY - _minY;
    if (restY > 0) {
        restY = newY - _maxY;
        if (restY < 0) {
            restY = 0;
        }
    }
    // self.restTranslation = CGPointMake(0, restY);
    return CGPointMake(translation.x, translation.y - restY);
}
- (void)refreshLastPoint:(CGPoint)safeTranslation {
    _lastPoint = CGPointMake(_lastPoint.x + safeTranslation.x, _lastPoint.y + safeTranslation.y);
}

@end

@implementation MLRectModifier_LeftTop
+ (BOOL)isHit:(CGRect)rect byTouchLocation:(CGPoint)TouchLocation {
    CGPoint toCheckPoint = rect.origin;
    if (TouchLocation.x > toCheckPoint.x - TOUCH_SIZE_OUT && TouchLocation.x < toCheckPoint.x + TOUCH_SIZE_IN &&
        TouchLocation.y > toCheckPoint.y - TOUCH_SIZE_OUT && TouchLocation.y < toCheckPoint.y + TOUCH_SIZE_IN) {
        return YES;
    }
    return NO;
}
- (CGRect)modifyRect:(CGRect)rect byTranslation:(CGPoint)translation {
    CGPoint newPoint = CGPointMake(rect.origin.x + translation.x, rect.origin.y + translation.y);
    translation = [self getSafeTranslation:translation byNewPoint:newPoint];
    [self refreshLastPoint:translation];
    return CGRectMake(rect.origin.x + translation.x, rect.origin.y + translation.y, rect.size.width - translation.x,
                      rect.size.height - translation.y);
}
@end

@implementation MLRectModifier_RightTop
+ (BOOL)isHit:(CGRect)rect byTouchLocation:(CGPoint)TouchLocation {
    CGPoint toCheckPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    if (TouchLocation.x > toCheckPoint.x - TOUCH_SIZE_IN && TouchLocation.x < toCheckPoint.x + TOUCH_SIZE_OUT &&
        TouchLocation.y > toCheckPoint.y - TOUCH_SIZE_OUT && TouchLocation.y < toCheckPoint.y + TOUCH_SIZE_IN) {
        return YES;
    }
    return NO;
}
- (CGRect)modifyRect:(CGRect)rect byTranslation:(CGPoint)translation {
    CGPoint newPoint = CGPointMake(rect.origin.x + rect.size.width + translation.x, rect.origin.y + translation.y);
    translation = [self getSafeTranslation:translation byNewPoint:newPoint];
    [self refreshLastPoint:translation];
    return CGRectMake(rect.origin.x, rect.origin.y + translation.y, rect.size.width + translation.x,
                      rect.size.height - translation.y);
}
@end

@implementation MLRectModifier_RightBottom
+ (BOOL)isHit:(CGRect)rect byTouchLocation:(CGPoint)TouchLocation {
    CGPoint toCheckPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    if (TouchLocation.x > toCheckPoint.x - TOUCH_SIZE_IN && TouchLocation.x < toCheckPoint.x + TOUCH_SIZE_OUT &&
        TouchLocation.y > toCheckPoint.y - TOUCH_SIZE_IN && TouchLocation.y < toCheckPoint.y + TOUCH_SIZE_OUT) {
        return YES;
    }
    return NO;
}
- (CGRect)modifyRect:(CGRect)rect byTranslation:(CGPoint)translation {
    CGPoint newPoint =
        CGPointMake(rect.origin.x + rect.size.width + translation.x, rect.origin.y + rect.size.height + translation.y);
    translation = [self getSafeTranslation:translation byNewPoint:newPoint];
    [self refreshLastPoint:translation];
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + translation.x, rect.size.height + translation.y);
}
@end

@implementation MLRectModifier_LeftBottom
+ (BOOL)isHit:(CGRect)rect byTouchLocation:(CGPoint)TouchLocation {
    CGPoint toCheckPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    if (TouchLocation.x > toCheckPoint.x - TOUCH_SIZE_OUT && TouchLocation.x < toCheckPoint.x + TOUCH_SIZE_IN &&
        TouchLocation.y > toCheckPoint.y - TOUCH_SIZE_IN && TouchLocation.y < toCheckPoint.y + TOUCH_SIZE_OUT) {
        return YES;
    }
    return NO;
}
- (CGRect)modifyRect:(CGRect)rect byTranslation:(CGPoint)translation {
    CGPoint newPoint = CGPointMake(rect.origin.x + translation.x, rect.origin.y + rect.size.height + translation.y);
    translation = [self getSafeTranslation:translation byNewPoint:newPoint];
    [self refreshLastPoint:translation];
    return CGRectMake(rect.origin.x + translation.x, rect.origin.y, rect.size.width - translation.x,
                      rect.size.height + translation.y);
}
@end

@implementation MLRectModifier_LeftEdge
+ (BOOL)isHit:(CGRect)rect byTouchLocation:(CGPoint)TouchLocation {
    if (TouchLocation.x > rect.origin.x - TOUCH_SIZE_OUT && TouchLocation.x < rect.origin.x + TOUCH_SIZE_IN &&
        TouchLocation.y < rect.origin.y + rect.size.height - TOUCH_SIZE_IN &&
        TouchLocation.y > rect.origin.y + TOUCH_SIZE_IN) {
        return YES;
    }
    return NO;
}
- (CGRect)modifyRect:(CGRect)rect byTranslation:(CGPoint)translation {
    translation = [self getSafeTranslation:translation byNewX:rect.origin.x + translation.x];
    [self refreshLastPoint:translation];
    return CGRectMake(rect.origin.x + translation.x, rect.origin.y, rect.size.width - translation.x, rect.size.height);
}
@end

@implementation MLRectModifier_TopEdge
+ (BOOL)isHit:(CGRect)rect byTouchLocation:(CGPoint)TouchLocation {
    if (TouchLocation.x > rect.origin.x + TOUCH_SIZE_IN &&
        TouchLocation.x < rect.origin.x + rect.size.width - TOUCH_SIZE_IN &&
        TouchLocation.y < rect.origin.y + TOUCH_SIZE_IN && TouchLocation.y > rect.origin.y - TOUCH_SIZE_OUT) {
        return YES;
    }
    return NO;
}
- (CGRect)modifyRect:(CGRect)rect byTranslation:(CGPoint)translation {
    translation = [self getSafeTranslation:translation byNewY:rect.origin.y + translation.y];
    [self refreshLastPoint:translation];
    return CGRectMake(rect.origin.x, rect.origin.y + translation.y, rect.size.width, rect.size.height - translation.y);
}
@end

@implementation MLRectModifier_RightEdge
+ (BOOL)isHit:(CGRect)rect byTouchLocation:(CGPoint)TouchLocation {
    if (TouchLocation.x > rect.origin.x + rect.size.width - TOUCH_SIZE_IN &&
        TouchLocation.x < rect.origin.x + rect.size.width + TOUCH_SIZE_OUT &&
        TouchLocation.y < rect.origin.y + rect.size.height - TOUCH_SIZE_IN &&
        TouchLocation.y > rect.origin.y + TOUCH_SIZE_IN) {
        return YES;
    }
    return NO;
}
- (CGRect)modifyRect:(CGRect)rect byTranslation:(CGPoint)translation {
    translation = [self getSafeTranslation:translation byNewX:rect.origin.x + rect.size.width + translation.x];
    [self refreshLastPoint:translation];
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + translation.x, rect.size.height);
}
@end

@implementation MLRectModifier_BottomEdge
+ (BOOL)isHit:(CGRect)rect byTouchLocation:(CGPoint)TouchLocation {
    if (TouchLocation.x > rect.origin.x + TOUCH_SIZE_IN &&
        TouchLocation.x < rect.origin.x + rect.size.width - TOUCH_SIZE_IN &&
        TouchLocation.y < rect.origin.y + rect.size.height + TOUCH_SIZE_OUT &&
        TouchLocation.y > rect.origin.y + rect.size.height - TOUCH_SIZE_IN) {
        return YES;
    }
    return NO;
}
- (CGRect)modifyRect:(CGRect)rect byTranslation:(CGPoint)translation {
    translation = [self getSafeTranslation:translation byNewY:rect.origin.y + rect.size.height + translation.y];
    [self refreshLastPoint:translation];
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + translation.y);
}
@end

@implementation MLRectModifier_Body
+ (BOOL)isHit:(CGRect)rect byTouchLocation:(CGPoint)TouchLocation {
    if (TouchLocation.x > CGRectGetMinX(rect) + TOUCH_SIZE_IN &&
        TouchLocation.x < CGRectGetMaxX(rect) - TOUCH_SIZE_IN &&
        TouchLocation.y < CGRectGetMaxY(rect) - TOUCH_SIZE_IN &&
        TouchLocation.y > CGRectGetMinY(rect) + TOUCH_SIZE_IN) {
        return YES;
    }
    return NO;
}
- (CGRect)modifyRect:(CGRect)rect byTranslation:(CGPoint)translation {

    CGRect newRect =
        CGRectMake(rect.origin.x + translation.x, rect.origin.y + translation.y, rect.size.width, rect.size.height);
    // help user adjust the box
    newRect = CGRectIntersection(self.availableArea, newRect);
    if (newRect.size.width < 2 || newRect.size.height < 2) {
        return rect;
    }
    [self refreshLastPoint:translation];
    return newRect;

    //    CGPoint newTranslation = [self getSafeTranslation:translation byNewRect:newRect];
    //    if (CGPointEqualToPoint(newTranslation, translation)) {
    //        return newRect;
    //    } else {
    //        return CGRectMake(rect.origin.x + newTranslation.x, rect.origin.y + newTranslation.y, rect.size.width,
    //                          rect.size.height);
    //    }
}
@end
