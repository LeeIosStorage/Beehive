//
//  LEPublishMenuView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/4.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LEPublishMenuView.h"

@interface LEPublishMenuView ()

@property (nonatomic, strong) UIImageView *markImageView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) NSMutableArray *itemViews;//views

@property (nonatomic, strong) LEPublishMenuViewBlcok clickBlock;

@end

@implementation LEPublishMenuView

- (instancetype)initWithActionBlock:(LEPublishMenuViewBlcok)actionBlock
{
    self = [super init];
    if (self) {
        _clickBlock = actionBlock;
    }
    return self;
}

- (void)setup {
    [super setup];
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.markImageView];
    [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-(13 + 49));
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    NSArray *items = [NSArray arrayWithObjects:
                      @{@"title":@"红包任务", @"icon":@"publish_red_task"},
                      @{@"title":@"兑换商品", @"icon":@"publish_duihuan"},
                      @{@"title":@"提问红包", @"icon":@"publish_tiwen"},
                      @{@"title":@"便民信息", @"icon":@"publish_bianmin"}, nil];
    self.itemViews = [NSMutableArray array];
    [self addItems:items];
}

- (void)addItems:(NSArray *)items {
    if (self.itemViews.count > 0) {
        for (UIView *view in self.itemViews) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < items.count; i ++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = [UIColor clearColor];
        [self.markImageView addSubview:itemView];
        CGFloat bottom = 12 + 82 + 19;
        if (i > 1) {
            bottom = 12;
        }
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 82));
            if (i%2 == 0) {
                make.right.equalTo(self.markImageView.mas_centerX).offset(-40);
            } else {
                make.left.equalTo(self.markImageView.mas_centerX).offset(40);
            }
            make.bottom.equalTo(self.closeButton.mas_top).offset(-bottom);
        }];
        [self.itemViews addObject:itemView];
        
        NSDictionary *dic = items[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:dic[@"icon"]] forState:UIControlStateNormal];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(itemView);
            make.height.mas_equalTo(60);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kAppTitleColor;
        label.font = [FontConst PingFangSCRegularWithSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = dic[@"title"];
        [itemView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(itemView);
            make.centerX.equalTo(itemView);
        }];
    }
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.markImageView.alpha = 0.85;
    }];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)clickAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 10;
    if (self.clickBlock) {
        self.clickBlock(index);
    }
    [self dismiss];
}

#pragma mark - SetAndGet
- (UIImageView *)markImageView {
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc] init];
//        _markImageView.backgroundColor = kAppThemeColor;
        _markImageView.backgroundColor = UIColor.whiteColor;
        _markImageView.alpha = 0;
        _markImageView.userInteractionEnabled = true;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_markImageView addGestureRecognizer:tap];
    }
    return _markImageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"publish_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
