//
//  LLHomeNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/25.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLHomeNode.h"

@implementation LLHomeNode

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isHaveQueen":@"IsHaveQueen",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"NoticeList"   : [LLNoticeNode class],
             @"RedEnvelopesList"   : [LLRedpacketNode class],
             @"FirstRowRedList"   : [LLRedCityNode class],
             };
}

- (NSString *)QueenHeadImg {
    if (_QueenHeadImg.length == 0) {
        return @"";
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _QueenHeadImg];
    return urlStr;
}

@end
