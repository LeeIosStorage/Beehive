//
//  LLAdvertNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/6.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLAdvertNode.h"

@implementation LLAdvertNode

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"DataTitle":@[@"DataTitle",@"Title"],
             @"DataImg":@[@"DataImg",@"CoverImgUrl"]
             };
}

- (NSString *)DataImg {
    if (_DataImg.length == 0) {
        return @"";
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _DataImg];
    return urlStr;
}

@end
