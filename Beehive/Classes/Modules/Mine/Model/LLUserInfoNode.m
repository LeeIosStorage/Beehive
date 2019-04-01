//
//  LLUserInfoNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/1.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLUserInfoNode.h"

@implementation LLUserInfoNode

- (NSString *)HeadImg {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _HeadImg];
    return urlStr;
}

@end
