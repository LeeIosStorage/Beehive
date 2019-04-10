//
//  WYLaunchFadeScaleAnimation.h
//  WangYu
//
//  Created by XuLei on 16/2/18.
//  Copyright © 2016年 KID. All rights reserved.
//

#import "WYLaunchBaseAnimation.h"

@interface WYLaunchFadeScaleAnimation : WYLaunchBaseAnimation

@property (nonatomic, assign) CGFloat scale;    // scale ratio default 1.6

+ (instancetype)fadeAnimation;
+ (instancetype)fadeScaleAnimation;
+ (instancetype)fadeAnimationWithDelay:(CGFloat)delay;

@end
