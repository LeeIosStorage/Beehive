//
//  LLWithdrawViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLFundHandleVCType) {
    LLFundHandleVCTypeWithdraw, //提现
    LLFundHandleVCTypeDeposit, //充值
    LLFundHandleVCTypePresent, //赠送
};

@interface LLWithdrawViewController : LLBaseViewController

@property (nonatomic, assign) LLFundHandleVCType vcType;

@end

NS_ASSUME_NONNULL_END
