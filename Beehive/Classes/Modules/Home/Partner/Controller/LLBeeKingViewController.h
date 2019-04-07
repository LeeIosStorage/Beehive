//
//  LLBeeKingViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"
#import "LLHomeNode.h"
#import "LLBeeKingNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLBeeKingViewController : LLBaseViewController

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) LLHomeNode *areaNode;

@property (nonatomic, strong) LLBeeKingNode *beeKingNode;

@end

NS_ASSUME_NONNULL_END
