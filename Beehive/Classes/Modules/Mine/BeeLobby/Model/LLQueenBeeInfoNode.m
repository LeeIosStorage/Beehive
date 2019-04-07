//
//  LLQueenBeeInfoNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/7.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLQueenBeeInfoNode.h"

@implementation LLQueenBeeInfoNode

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"AdvertList"   : [LLAdvertNode class]
             };
}

@end
