//
//  MLRectModifier.h
//  MLImageCrop
//
//  Created by Haihan Wang on 16/2/3.
//  Copyright © 2016年 Malong Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MLRectModifier : NSObject
/**
 *  init by available area
 *
 *  @param availableArea available area
 *  @param startPoint    first point
 *
 *  @return
 */
- (instancetype)initWithAvailableArea:(CGRect)availableArea startPoint:(CGPoint)startPoint;
/**
 *  change the rect by translation, it will adjust the rect if it out the available area
 *
 *  @param rect        current rect
 *  @param translation translation of moving
 *
 *  @return new rect
 */
- (CGRect)modifyRect:(CGRect)rect byTranslation:(CGPoint)translation;
/**
 *  to check is it can use current modifier
 *
 *  @param rect          current rect
 *  @param TouchLocation touch location
 *
 *  @return Yes means hit
 */
+ (BOOL)isHit:(CGRect)rect byTouchLocation:(CGPoint)TouchLocation;
@property (nonatomic) CGRect availableArea;
@property (nonatomic) CGRect modifiedRect;
@property (nonatomic) CGPoint lastPoint;
@end

@interface MLRectModifier_LeftTop : MLRectModifier
@end
@interface MLRectModifier_RightTop : MLRectModifier
@end
@interface MLRectModifier_RightBottom : MLRectModifier
@end
@interface MLRectModifier_LeftBottom : MLRectModifier
@end
@interface MLRectModifier_LeftEdge : MLRectModifier
@end
@interface MLRectModifier_TopEdge : MLRectModifier
@end
@interface MLRectModifier_RightEdge : MLRectModifier
@end
@interface MLRectModifier_BottomEdge : MLRectModifier
@end
@interface MLRectModifier_Body : MLRectModifier
@end
