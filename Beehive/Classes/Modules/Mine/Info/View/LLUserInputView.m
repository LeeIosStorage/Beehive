//
//  LLUserInputView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/4.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLUserInputView.h"

@interface LLUserInputView ()

@end

@implementation LLUserInputView

- (void)setup {
    [super setup];
    self.backgroundColor = kAppMaskBackgroundColor;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = true;
    
    [self addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeImageView.mas_right).offset(8);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
        make.right.equalTo(self).offset(-10);
    }];
}

- (void)setInputViewType:(LLUserInputViewType)inputViewType {
    _inputViewType = inputViewType;
    if (inputViewType == LLUserInputViewTypePhone) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    } else if (inputViewType == LLUserInputViewTypePassword) {
        self.textField.secureTextEntry = true;
        [self addSubview:self.secretButton];
        [self.secretButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(0);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeImageView.mas_right).offset(8);
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-5);
            make.right.equalTo(self.secretButton.mas_left);
        }];
    } else if (inputViewType == LLUserInputViewTypeSMS) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:self.smsCodeView];
        [self.smsCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.width.mas_equalTo(88);
        }];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeImageView.mas_right).offset(8);
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-5);
            make.right.equalTo(self.smsCodeView.mas_left).offset(-5);
        }];
    } else if (inputViewType == LLUserInputViewTypeInviteCode) {
        
    }
}

- (void)setAttributedPlaceholder:(NSString *)placeholder {
    self.textField.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:[FontConst PingFangSCRegularWithSize:14] color:[UIColor colorWithHexString:@"a9a9aa"]];
}

- (void)secretAction:(id)sender {
    self.textField.secureTextEntry = !self.textField.secureTextEntry;
}

#pragma mark - SetAndGet
- (UIImageView *)typeImageView {
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc] init];
    }
    return _typeImageView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
    }
    return _textField;
}

- (UIView *)smsCodeView {
    if (!_smsCodeView) {
        _smsCodeView = [[UIView alloc] init];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"发送验证码" forState:UIControlStateNormal];
        [button setTitleColor:kAppThemeColor forState:UIControlStateNormal];
        [button setTitleColor:kAppSubTitleColor forState:UIControlStateDisabled];
        [button.titleLabel setFont:[FontConst PingFangSCRegularWithSize:14]];
        _smsCodeButton = button;
        [_smsCodeView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self->_smsCodeView);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        UIImageView *lineImageView = [[UIImageView alloc] init];
        lineImageView.backgroundColor = LineColor;
        [_smsCodeView addSubview:lineImageView];
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.width.mas_equalTo(1);
        }];
        
    }
    return _smsCodeView;
}

- (UIButton *)secretButton {
    if (!_secretButton) {
        _secretButton = [[UIButton alloc] init];
        [_secretButton setImage:[UIImage imageNamed:@"user_security"] forState:UIControlStateNormal];
        [_secretButton addTarget:self action:@selector(secretAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secretButton;
}

@end
