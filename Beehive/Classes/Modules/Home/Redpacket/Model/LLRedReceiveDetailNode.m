//
//  LLRedReceiveDetailNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/3.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRedReceiveDetailNode.h"

@implementation LLRedReceiveDetailNode

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"UserList"   : [LLUserInfoNode class]
             };
}

- (NSString *)HeadImg {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _HeadImg];
    return urlStr;
}

@end
