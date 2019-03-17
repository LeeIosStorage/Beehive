//
//  LLNoticeViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLNoticeVcType) {
    LLNoticeVcTypeNotice, //通知
    LLNoticeVcTypeHelp, //帮助
};

@interface LLNoticeViewController : LLBaseViewController

@property (nonatomic, assign) LLNoticeVcType vcType;

@end

NS_ASSUME_NONNULL_END
