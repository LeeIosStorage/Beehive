//
//  LLRedTaskHistoryNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/2.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLRedpacketNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLRedTaskHistoryNode : NSObject

@property (nonatomic, assign) CGFloat SumMoney; //发布的
@property (nonatomic, assign) int SumUserCount;

@property (nonatomic, assign) CGFloat SumGrabMoney;
@property (nonatomic, assign) CGFloat DaySumGrabMoney;

@property (nonatomic, strong) NSArray *RedEnvelopeList;

@end

NS_ASSUME_NONNULL_END
