//
//  LLExchangeOrderNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/29.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLExchangeOrderNode.h"

@implementation LLExchangeOrderNode

- (NSString *)HeadImg {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _HeadImg];
    return urlStr;
}

- (NSString *)GoodsImg {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _GoodsImg];
    return urlStr;
}

@end
