//
//  LLBidAdvertNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/9.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBidAdvertNode.h"

@implementation LLBidAdvertNode

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"BidPriceList"   : [LLUserInfoNode class]
             };
}

@end
