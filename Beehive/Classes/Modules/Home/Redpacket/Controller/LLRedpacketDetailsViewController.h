//
//  LLRedpacketDetailsViewController.h
//  Beehive
//
//  Created by liguangjun on 2019/3/14.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"
#import "LLRedpacketNode.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLRedpacketDetailsVcType) {
    LLRedpacketDetailsVcTypeAsk = 0, //提问红包
    LLRedpacketDetailsVcTypeTask = 1, //任务红包
};

@interface LLRedpacketDetailsViewController : LLBaseViewController

@property (nonatomic, strong) LLRedpacketNode *redpacketNode;

@property (nonatomic, assign) LLRedpacketDetailsVcType vcType;//0提问红包1任务红包

@end

NS_ASSUME_NONNULL_END
