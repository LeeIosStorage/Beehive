//
//  LLHandleStatusView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/6.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLHandleStatusView.h"

@interface LLHandleStatusView ()

@property (nonatomic, strong) UIButton *readButton;

@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) UIButton *favourButton;

@end

@implementation LLHandleStatusView

- (void)setup {
    [super setup];
    
    [self addSubview:self.readButton];
    [self.readButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
    }];
    [self.readButton setTitle:@" 0" forState:UIControlStateNormal];
    
    [self addSubview:self.commentButton];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];
    [self.commentButton setTitle:@" 0" forState:UIControlStateNormal];
    
    [self addSubview:self.favourButton];
    [self.favourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
    }];
    [self.favourButton setTitle:@" 0" forState:UIControlStateNormal];
}

- (void)updateWithData:(id)node {
    [self.readButton setTitle:@" 4" forState:UIControlStateNormal];
    [self.commentButton setTitle:@" 99" forState:UIControlStateNormal];
    [self.favourButton setTitle:@" 2" forState:UIControlStateNormal];
}

- (UIButton *)readButton {
    if (!_readButton) {
        _readButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readButton setImage:[UIImage imageNamed:@"message_read_icon"] forState:UIControlStateNormal];
        [_readButton setTitleColor:kAppLightTitleColor forState:UIControlStateNormal];
        [_readButton.titleLabel setFont:[FontConst PingFangSCRegularWithSize:11]];
        _readButton.contentMode = UIViewContentModeLeft;
        
    }
    return _readButton;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImage:[UIImage imageNamed:@"message_comment_icon"] forState:UIControlStateNormal];
        [_commentButton setTitleColor:kAppLightTitleColor forState:UIControlStateNormal];
        [_commentButton.titleLabel setFont:[FontConst PingFangSCRegularWithSize:11]];
    }
    return _commentButton;
}

- (UIButton *)favourButton {
    if (!_favourButton) {
        _favourButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favourButton setImage:[UIImage imageNamed:@"message_like_n_icon"] forState:UIControlStateNormal];
        [_favourButton setTitleColor:kAppLightTitleColor forState:UIControlStateNormal];
        [_favourButton.titleLabel setFont:[FontConst PingFangSCRegularWithSize:11]];
        _favourButton.contentMode = UIViewContentModeRight;
    }
    return _favourButton;
}

@end
