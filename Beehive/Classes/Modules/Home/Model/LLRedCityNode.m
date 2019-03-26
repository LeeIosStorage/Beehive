//
//  LLRedCityNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/25.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRedCityNode.h"
#import "LLRedpacketNode.h"

@implementation LLRedCityNode

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"RedList"   : [LLRedpacketNode class],
             };
}

@end
