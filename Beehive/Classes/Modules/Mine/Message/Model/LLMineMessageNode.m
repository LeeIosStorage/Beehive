//
//  LLMineMessageNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/4.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMineMessageNode.h"

@implementation LLMineMessageNode

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"NoticeList"   : [LLNoticeNode class]
             };
}

@end
