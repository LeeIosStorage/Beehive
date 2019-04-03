//
//  LLRedpacketNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/25.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLRedpacketNode.h"

@implementation LLRedpacketNode

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"RedList"   : [LLUserInfoNode class]
             };
}

- (NSArray *)ImgUrls {
    
    NSMutableArray *imgUrls = [NSMutableArray array];
    if ([_ImgList isKindOfClass:[NSArray class]]) {
        for (NSString *url in _ImgList) {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, url];
            [imgUrls addObject:urlStr];
        }
        return imgUrls;
    }
    
    id dataObject = nil;
    if ([_ImgList isKindOfClass:[NSString class]]) {
        NSData *data = [_ImgList dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        dataObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    }
    
    if ([dataObject isKindOfClass:[NSArray class]]) {
        for (NSString *url in dataObject) {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, url];
            [imgUrls addObject:urlStr];
        }
    } else if ([dataObject isKindOfClass:[NSString class]]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, dataObject];
        [imgUrls addObject:urlStr];
    } else {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _ImgList];
        [imgUrls addObject:urlStr];
    }
    return imgUrls;
}

- (NSString *)AdvertImg {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _AdvertImg];
    return urlStr;
}

- (NSString *)HeadImg {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _HeadImg];
    return urlStr;
}

@end
