//
//  LLUserInputView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/4.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLUserInputViewType) {
    LLUserInputViewTypeNomal,
    LLUserInputViewTypePhone,
    LLUserInputViewTypePassword,
    LLUserInputViewTypeSetPassword,
    LLUserInputViewTypeSMS,
    LLUserInputViewTypeInviteCode
};

@interface LLUserInputView : LLView

@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *smsCodeView;
@property (nonatomic, strong) UIButton *smsCodeButton;
@property (nonatomic, strong) UIButton *secretButton;

@property (nonatomic, assign) LLUserInputViewType inputViewType;

- (void)setAttributedPlaceholder:(NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END
