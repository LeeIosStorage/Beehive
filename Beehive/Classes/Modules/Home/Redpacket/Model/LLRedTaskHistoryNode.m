//
//  LLRedTaskHistoryNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/2.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRedTaskHistoryNode.h"

@implementation LLRedTaskHistoryNode

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"RedEnvelopeList"   : [LLRedpacketNode class]
             };
}

@end
