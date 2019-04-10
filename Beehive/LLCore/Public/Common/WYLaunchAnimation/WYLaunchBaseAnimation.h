//
//  WYLaunchBaseAnimation.h
//  WangYu
//
//  Created by XuLei on 16/2/18.
//  Copyright © 2016年 KID. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYLaunchAnimationProtocol.h"

@interface WYLaunchBaseAnimation : NSObject<WYLaunchAnimationProtocol>

@property (nonatomic, assign) CGFloat duration; // duration time
@property (nonatomic, assign) CGFloat delay;    // delay hide
@property (nonatomic, assign) UIViewAnimationOptions options;

@end
