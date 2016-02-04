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
- (instancetype)initWithAvailableArea:(CGRect)availableArea;
- (CGRect)modifyRect:(CGRect)rect byTranslation:(CGPoint)translation;
+ (BOOL)isHit:(CGRect)rect byTouchLocation:(CGPoint)TouchLocation;
@property (nonatomic) CGRect availableArea;
@property (nonatomic) CGRect modifiedRect;
@property (nonatomic) CGPoint restTranslation;
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
