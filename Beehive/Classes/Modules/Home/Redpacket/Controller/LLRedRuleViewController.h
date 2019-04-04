//
//  LLRedRuleViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/3.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLInfoDetailsVcType) {
    LLInfoDetailsVcTypeSignRule, //签到抽奖规则
    LLInfoDetailsVcTypeNotice, //公告
    LLInfoDetailsVcTypeAbout, //关于蜂巢
    LLInfoDetailsVcTypeAdsBuyRule, //广告位购买规则
};

@interface LLRedRuleViewController : LLBaseViewController

@property (nonatomic, assign) LLInfoDetailsVcType vcType;
@property (nonatomic, strong) NSString *text;

@end

NS_ASSUME_NONNULL_END
