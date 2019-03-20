//
//  UINavigationItem+LLWidth.m
//  Beehive
//
//  Created by liguangjun on 2019/3/20.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "UINavigationItem+LLWidth.h"
#import "NSObject+LLRuntime.h"

#ifndef sx_deviceVersion
#define sx_deviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

#define kDefaultNavigationItemSpace SCREEN_WIDTH > 375 ? 20 : 16

@implementation UINavigationItem (LLWidth)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(setRightBarButtonItem:) swizzledSel:@selector(sx_setRightBarButtonItem:)];
        [self swizzleInstanceMethodWithOriginSel:@selector(setRightBarButtonItems:) swizzledSel:@selector(sx_setRightBarButtonItems:)];
    });
}

- (void)sx_setRightBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self sx_setRightBarButtonItem:barButtonItem];
    if (sx_deviceVersion >= 11)
    {
        //给view增加2倍的默认偏移的宽度，这样位置正好可以与iOS11以下设备的位置一致，而且相应区域较大
        UIView * view = barButtonItem.customView;
        if ([view isKindOfClass:[UIButton class]])
            barButtonItem.customView.width = 44;
            barButtonItem.customView.height = 44;
        //这里针对其他类型的视图可以做其他处理
        //...
    }
}

- (void)sx_setRightBarButtonItems:(NSArray <UIBarButtonItem *> *)barButtonItems
{
    if (sx_deviceVersion >= 11)
    {
        for (UIBarButtonItem * barButtonItem in barButtonItems) {
            barButtonItem.customView.width = 44;
            barButtonItem.customView.height = 44;
        }
    }
    [self sx_setRightBarButtonItems:barButtonItems];
}

@end
