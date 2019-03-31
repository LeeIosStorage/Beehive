//
//  LLFollowUserNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/31.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLFollowUserNode.h"

@implementation LLFollowUserNode

- (NSString *)HeadImg {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _HeadImg];
    return urlStr;
}

@end
