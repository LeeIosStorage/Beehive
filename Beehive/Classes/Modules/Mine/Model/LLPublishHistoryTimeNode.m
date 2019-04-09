//
//  LLPublishHistoryTimeNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/2.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPublishHistoryTimeNode.h"

@implementation LLPublishHistoryTimeNode

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"RedList"   : [LLRedpacketNode class],
             @"FacList"   : [LLMessageListNode class],
             @"GoodsList"  : [LLExchangeGoodsNode class],
             };
}

@end
