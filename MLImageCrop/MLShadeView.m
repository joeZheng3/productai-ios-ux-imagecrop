//
//  MLShadeView.m
//  MLImageCrop
//
//  Created by Haihan Wang on 16/2/3.
//  Copyright © 2016年 Malong Tech. All rights reserved.
//

#import "MLShadeView.h"

@implementation MLShadeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = NO;
        _cropBorderColor = [UIColor whiteColor];
        _cropBorderWidth = 1;
        _cropAreaColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.2];
        _cropMaskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _pointColor = [UIColor colorWithRed:0.98 green:0.87 blue:0.2 alpha:1];
        _pointRadius = 4;
    }
    return self;
}

//- (void)redraw {
//    self drawRect:_cropArea
//}

- (void)setCropArea:(CGRect)cropArea {
    _cropArea = cropArea;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    // mask color
    if (_cropMaskColor != nil) {
        CGContextSetFillColorWithColor(context, _cropMaskColor.CGColor);
        CGContextFillRect(context, rect);
        CGContextClearRect(context, _cropArea);
    }

    // crop area color
    if (_cropAreaColor != nil) {
        CGContextSetFillColorWithColor(context, _cropAreaColor.CGColor);
    } else {
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    }

    // crop border
    if (_cropBorderWidth > 0) {
        CGContextSetStrokeColorWithColor(context, _cropBorderColor.CGColor);
        CGContextSetLineWidth(context, _cropBorderWidth);
        // todo custom line
        CGFloat dashPattern[] = {3, 3};
        CGContextSetLineDash(context, 0, dashPattern, 2);

        CGContextAddRect(context, _cropArea);
        CGContextDrawPath(context, kCGPathFillStroke);
    } else {
        CGContextFillRect(context, _cropArea);
    }

    // points
    if (_pointRadius > 0) {
        CGContextSetFillColorWithColor(context, _pointColor.CGColor);
        CGFloat pointSize = _pointRadius * 2;
        CGContextFillEllipseInRect(context, CGRectMake(_cropArea.origin.x - _pointRadius,
                                                       _cropArea.origin.y - _pointRadius, pointSize, pointSize));
        CGContextFillEllipseInRect(context, CGRectMake(_cropArea.origin.x + _cropArea.size.width - _pointRadius,
                                                       _cropArea.origin.y - _pointRadius, pointSize, pointSize));
        CGContextFillEllipseInRect(context, CGRectMake(_cropArea.origin.x + _cropArea.size.width - _pointRadius,
                                                       _cropArea.origin.y + _cropArea.size.height - _pointRadius,
                                                       pointSize, pointSize));
        CGContextFillEllipseInRect(context, CGRectMake(_cropArea.origin.x - _pointRadius,
                                                       _cropArea.origin.y + _cropArea.size.height - _pointRadius,
                                                       pointSize, pointSize));
    }
}

@end
