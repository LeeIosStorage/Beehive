//
//  LLAdvertDetailsNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/6.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLAdvertDetailsNode.h"

@implementation LLAdvertDetailsNode

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"AdverList"   : [LLAdvertNode class]
             };
}

- (NSString *)HeadImg {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _HeadImg];
    return urlStr;
}

@end
