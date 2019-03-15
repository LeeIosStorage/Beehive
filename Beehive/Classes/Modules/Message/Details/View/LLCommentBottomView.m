//
//  LLCommentBottomView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/7.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCommentBottomView.h"

@interface LLCommentBottomView ()

@property (nonatomic, strong) UIImageView *imgLine;

@property (nonatomic, strong) UIButton *btnShare;
@property (nonatomic, strong) UIButton *btnLike;
@property (nonatomic, strong) UIButton *btnCollect;

@property (nonatomic, strong) UIView *viewComment;
@property (nonatomic, strong) UIImageView *imgInput;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *btnPublish;

@end

@implementation LLCommentBottomView

- (void)setup {
    [super setup];
    
    [self addSubview:self.imgLine];
    [self.imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [self addSubview:self.btnShare];
    [self.btnShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.btnLike];
    [self.btnLike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnShare.mas_right).offset(13);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.btnCollect];
    [self.btnCollect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnLike.mas_right).offset(13);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.btnPublish];
    [self.btnPublish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(45, 28));
    }];
    
    [self addSubview:self.viewComment];
    [self.viewComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnCollect.mas_right).offset(13);
        make.right.equalTo(self.btnPublish.mas_left).offset(-10);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(28);
    }];
}

#pragma mark - Action
- (void)shareAction:(id)sender {
    if (self.commentBottomViewHandleBlock) {
        self.commentBottomViewHandleBlock(0);
    }
}

- (void)likeAction:(id)sender {
    if (self.commentBottomViewHandleBlock) {
        self.commentBottomViewHandleBlock(1);
    }
}

- (void)collectAction:(id)sender {
    if (self.commentBottomViewHandleBlock) {
        self.commentBottomViewHandleBlock(2);
    }
}

- (void)publishAction:(id)sender {
    if (self.commentBottomViewSendBlock) {
        self.commentBottomViewSendBlock();
    }
}

#pragma mark - SetGet
- (UIImageView *)imgLine {
    if (!_imgLine) {
        _imgLine = [[UIImageView alloc] init];
        _imgLine.backgroundColor = LineColor;
    }
    return _imgLine;
}

- (UIButton *)btnShare {
    if (!_btnShare) {
        _btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnShare setImage:[UIImage imageNamed:@"message_share_icon"] forState:UIControlStateNormal];
        [_btnShare addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnShare;
}

- (UIButton *)btnLike {
    if (!_btnLike) {
        _btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnLike setImage:[UIImage imageNamed:@"message_zan_n"] forState:UIControlStateNormal];
        [_btnLike setImage:[UIImage imageNamed:@"message_zan_s"] forState:UIControlStateHighlighted];
        [_btnLike addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLike;
}

- (UIButton *)btnCollect {
    if (!_btnCollect) {
        _btnCollect = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCollect setImage:[UIImage imageNamed:@"message_shoucang_n"] forState:UIControlStateNormal];
        [_btnCollect setImage:[UIImage imageNamed:@"message_shoucang_s"] forState:UIControlStateHighlighted];
        [_btnCollect addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCollect;
}

- (UIButton *)btnPublish {
    if (!_btnPublish) {
        _btnPublish = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnPublish.layer.cornerRadius = 3;
        _btnPublish.layer.masksToBounds = true;
        _btnPublish.backgroundColor = kAppThemeColor;
        [_btnPublish setTitle:@"发布" forState:UIControlStateNormal];
        [_btnPublish.titleLabel setFont:[FontConst PingFangSCRegularWithSize:13]];
        [_btnPublish setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_btnPublish addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPublish;
}

- (UIView *)viewComment {
    if (!_viewComment) {
        _viewComment = [[UIView alloc] init];
        _viewComment.backgroundColor = kAppSectionBackgroundColor;
        _viewComment.layer.cornerRadius = 3;
        _viewComment.layer.masksToBounds = true;
        _viewComment.layer.borderWidth = 0.5;
        _viewComment.layer.borderColor = LineColor.CGColor;
        
        UIImageView *img = [UIImageView new];
        img.image = [UIImage imageNamed:@"message_comment_input_icon"];
        [_viewComment addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(9);
            make.centerY.equalTo(self->_viewComment);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        self.imgInput = img;
        
        UITextField *tf = [[UITextField alloc] init];
        self.textField = tf;
        NSString *placeholder = @"禁止打广告...";
        tf.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:[FontConst PingFangSCRegularWithSize:13] color:[UIColor colorWithHexString:@"a9a9aa"]];
        tf.textColor = kAppTitleColor;
//        tf.enabled = false;
        [_viewComment addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(img.mas_right).offset(9);
            make.right.mas_equalTo(-9);
            make.centerY.equalTo(self->_viewComment);
        }];
        
    }
    return _viewComment;
}

@end
