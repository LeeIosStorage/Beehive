//
//  UIView+WYLaunchAnimation.h
//  WangYu
//
//  Created by XuLei on 16/2/18.
//  Copyright © 2016年 KID. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYLaunchAnimationProtocol.h"

@interface UIView (WYLaunchAnimation)

- (void)showInView:(UIView *)superView animation:(id<WYLaunchAnimationProtocol>)animation completion:(void (^)(BOOL finished))completion;

- (void)showInWindowWithAnimation:(id<WYLaunchAnimationProtocol>)animation completion:(void (^)(BOOL finished))completion;

@end
