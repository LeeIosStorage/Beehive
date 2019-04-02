//
//  LLMessageListNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/2.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMessageListNode.h"

@implementation LLMessageListNode

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Distance":@[@"DistanceNum",@"Distance"],
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
    if ([_ImgUrlList isKindOfClass:[NSString class]]) {
        NSData *data = [_ImgUrlList dataUsingEncoding:NSUTF8StringEncoding];
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
    }
    return imgUrls;
}

- (NSString *)HeadImg {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _HeadImg];
    return urlStr;
}

@end
