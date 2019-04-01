//
//  LLBeeQunMoneyNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/1.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLBeeQunMoneyNode : NSObject

@property (nonatomic, assign) CGFloat TotalSumMoney;
@property (nonatomic, assign) CGFloat NowTotalSumMoney;
@property (nonatomic, assign) CGFloat ParentSumMoney; //一级
@property (nonatomic, assign) CGFloat GrandSumMoney; //二级
@property (nonatomic, assign) int ParentSumCount;
@property (nonatomic, assign) int GrandSumCount;

@end

NS_ASSUME_NONNULL_END
