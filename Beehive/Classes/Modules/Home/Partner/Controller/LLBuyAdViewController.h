//
//  LLBuyAdViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"
#import "LLAdvertNode.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLBuyAdVcChooseDaysBlock)(int days);

@interface LLBuyAdViewController : LLBaseViewController

@property (nonatomic, strong) LLAdvertNode *advertNode;

@property (nonatomic, assign) NSInteger vcType;//0租用， 1竞价购买

@property (nonatomic, strong) LLBuyAdVcChooseDaysBlock chooseDaysBlock;

@end

NS_ASSUME_NONNULL_END
