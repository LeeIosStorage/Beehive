//
//  LLRegisterViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/4.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLAmendPhoneVcType) {
    LLAmendPhoneVcTypeRegister,    //注册
    LLAmendPhoneVcTypeBind         //绑定手机号
};

@interface LLRegisterViewController : LLBaseViewController

@property (nonatomic, assign) LLAmendPhoneVcType vcType;

@end

NS_ASSUME_NONNULL_END
