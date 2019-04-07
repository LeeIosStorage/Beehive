//
//  LLAreaNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/7.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLAreaNode.h"

@implementation LLAreaNode

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"Children"   : [LLAreaNode class]
             };
}

@end
