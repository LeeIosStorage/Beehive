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

@interface LLRedpacketDetailsViewController : LLBaseViewController

@property (nonatomic, strong) LLRedpacketNode *redpacketNode;

@property (nonatomic, assign) NSInteger vcType;//0提问红包1任务红包

@end

NS_ASSUME_NONNULL_END
