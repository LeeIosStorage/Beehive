//
//  LLBannerNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/28.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBannerNode.h"

@implementation LLBannerNode

- (NSString *)ImageSrc{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _ImageSrc];
    return urlStr;
}

@end
