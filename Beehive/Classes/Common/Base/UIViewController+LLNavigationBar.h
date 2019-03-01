//
//  UIViewController+LLNavigationBar.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/1.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <UIKit/UIKit.h>

//NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLNavigationBarPosition) {
    LLNavigationBarPositionLeft,
    LLNavigationBarPositionRight
};

@interface UIViewController (LLNavigationBar)

/**
 *  创建导航栏左右item
 *  @param position       左右位置
 *  @param normalImage    normal状态image
 *  @param highlightImage highlight状态image
 *  @param text           文本
 *  @param action         动作
 */
- (void)createBarButtonItemAtPosition:(LLNavigationBarPosition)position
                          normalImage:(UIImage *)normalImage
                       highlightImage:(UIImage *)highlightImage
                                 text:(NSString *)text
                               action:(SEL)action;

@end

//NS_ASSUME_NONNULL_END
