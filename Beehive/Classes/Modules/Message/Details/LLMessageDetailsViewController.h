//
//  LLMessageDetailsViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/6.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"
#import "LLMessageListNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLMessageDetailsViewController : LLBaseViewController

@property (nonatomic, strong) LLMessageListNode *messageListNode;

@end

NS_ASSUME_NONNULL_END
