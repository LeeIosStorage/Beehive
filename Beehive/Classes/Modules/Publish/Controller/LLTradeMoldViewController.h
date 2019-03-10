//
//  LLTradeMoldViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class LLTradeMoldNode;

typedef void (^LLTradeMoldViewControllerChooseBlock)(LLTradeMoldNode *node1, LLTradeMoldNode *node2);

@interface LLTradeMoldViewController : LLBaseViewController

@property (nonatomic, strong) LLTradeMoldNode *oneNode;
@property (nonatomic, strong) LLTradeMoldNode *twoNode;

@property (nonatomic, copy) LLTradeMoldViewControllerChooseBlock chooseBlock;

@end

NS_ASSUME_NONNULL_END
