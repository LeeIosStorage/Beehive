//
//  LLSelectUserViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/5.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"
#import "LLUserInfoNode.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLSelectUserVcNodeBlock)(LLUserInfoNode *node);

@interface LLSelectUserViewController : LLBaseViewController

@property (nonatomic, strong) LLSelectUserVcNodeBlock selectUserNodeBlock;

@end

NS_ASSUME_NONNULL_END
