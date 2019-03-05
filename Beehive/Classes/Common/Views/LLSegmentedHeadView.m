//
//  LLSegmentedHeadView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/5.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLSegmentedHeadView.h"

@interface LLSegmentedHeadView ()

@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIImageView *selImageView;

@end

@implementation LLSegmentedHeadView

- (void)setup {
    [super setup];
    
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
}

- (void)setItems:(NSArray *)items {
    [self removeAllSubviews];
    
    CGFloat itemW = SCREEN_WIDTH/items.count;
    for (int i = 0; i < items.count; i ++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.tag = 10 + i;
        [self addSubview:itemView];
        CGFloat bottom = 12 + 82 + 19;
        if (i > 1) {
            bottom = 12;
        }
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(itemW*i);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(itemW);
        }];
        
        NSDictionary *dic = items[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:dic[kllSegmentedTitle] forState:UIControlStateNormal];
        [button setTitleColor:kAppTitleColor forState:UIControlStateNormal];
        [button setTitleColor:kAppThemeColor forState:UIControlStateSelected];
        [button.titleLabel setFont:[FontConst PingFangSCRegularWithSize:15]];
        [button setSelected:false];
        if (self.selectIndex == i) {
            [button setSelected:true];
        }
        button.tag = 20;
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.top.equalTo(itemView);
        }];
        NSInteger type = [dic[kllSegmentedType] integerValue];
        if (type == 1) {
            UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [markBtn setImage:[UIImage imageNamed:@"message_jiao_down"] forState:UIControlStateNormal];
            [markBtn setImage:[UIImage imageNamed:@"message_jiao_up"] forState:UIControlStateSelected];
            markBtn.tag = 21;
            [itemView addSubview:markBtn];
            [markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(itemView);
                make.left.equalTo(button.mas_right).offset(5);
            }];
        }
    }
    
    [self addSubview:self.lineImageView];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *itemView = (UIView *)[self viewWithTag:10 + self.selectIndex];
    [self addSubview:self.selImageView];
    [self.selImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(itemView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(1.5);
    }];
    
    
}

- (void)clickAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.superview.tag - 10;
    _selectIndex = index;
    UIView *itemView = (UIView *)[self viewWithTag:10 + self.selectIndex];
    [self.selImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(itemView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(1.5);
    }];
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *)obj;
            for (UIButton *button in view.subviews) {
                button.selected = false;
                if (view.tag - 10 == index) {
                    button.selected = true;
                }
            }
        }
    }
    
    if (self.clickBlock) {
        self.clickBlock(index);
    }
}

- (UIImageView *)lineImageView {
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = LineColor;
    }
    return _lineImageView;
}
- (UIImageView *)selImageView {
    if (!_selImageView) {
        _selImageView = [[UIImageView alloc] init];
        _selImageView.backgroundColor = kAppThemeColor;
    }
    return _selImageView;
}

@end
