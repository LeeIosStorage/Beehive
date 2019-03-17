//
//  LLFundDetailViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLFundDetailVCType) {
    LLFundDetailVCTypeWithdraw, //提现
    LLFundDetailVCTypeAll,      //所有
};

@interface LLFundDetailViewController : LLBaseViewController

@property (nonatomic, assign) LLFundDetailVCType vcType;

@end

NS_ASSUME_NONNULL_END
