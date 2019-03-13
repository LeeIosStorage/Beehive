//
//  LEAlertMarkView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/13.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LEAlertMarkView.h"

@interface LEAlertMarkView ()

@property (nonatomic, strong) UIView *customView;

@end

@implementation LEAlertMarkView

#pragma mark -
#pragma mark - Lifecycle
- (void)dealloc
{
    LELog(@"!!!!");
}

- (instancetype)initWithCustomView:(UIView *)customView {
    self = [super init];
    if (self) {
        self.customView = customView;
        [self setup];
    }
    return self;
}

- (void)setup {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = kAppMaskOpaqueBlackColor;
    
    if (self.customView) {
        [self addSubview:self.customView];
        LELog(@"%f",self.customView.frame.size.width);
        CGSize size = self.customView.frame.size;
        [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(size);
        }];
    }
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
