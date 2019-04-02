//
//  LLRankUserNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/2.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRankUserNode.h"

@implementation LLRankUserNode

- (NSString *)HeadImg {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _HeadImg];
    return urlStr;
}

@end
