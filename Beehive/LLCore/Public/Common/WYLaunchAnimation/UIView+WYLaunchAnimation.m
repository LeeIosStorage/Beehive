//
//  UIView+WYLaunchAnimation.m
//  WangYu
//
//  Created by XuLei on 16/2/18.
//  Copyright © 2016年 KID. All rights reserved.
//

#import "UIView+WYLaunchAnimation.h"

@implementation UIView (WYLaunchAnimation)

- (void)showInView:(UIView *)superView animation:(id<WYLaunchAnimationProtocol>)animation completion:(void (^)(BOOL finished))completion {
    if (superView == nil) {
        NSLog(@"superView can't nil");
        return;
    }
    superView.hidden = NO;
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
    
    self.frame = superView.bounds;
    
    if (animation && [animation respondsToSelector:@selector(configureAnimationWithView:completion:)]) {
        [animation configureAnimationWithView:self completion:completion];
    }else {
        completion(YES);
    }
}

- (void)showInWindowWithAnimation:(id<WYLaunchAnimationProtocol>)animation completion:(void (^)(BOOL finished))completion {
    [self showInView:[[UIApplication sharedApplication].delegate window] animation:animation completion:completion];
}

@end
