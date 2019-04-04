//
//  LLCollectionListNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/4.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCollectionListNode.h"

@implementation LLCollectionListNode

- (NSArray *)ImgUrls {
    
    NSMutableArray *imgUrls = [NSMutableArray array];
//    if ([_ImgList isKindOfClass:[NSArray class]]) {
//        for (NSString *url in _ImgList) {
//            NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, url];
//            [imgUrls addObject:urlStr];
//        }
//        return imgUrls;
//    }
    
    id dataObject = nil;
    if ([_ImgUrl isKindOfClass:[NSString class]]) {
        NSData *data = [_ImgUrl dataUsingEncoding:NSUTF8StringEncoding];
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
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, _ImgUrl];
        [imgUrls addObject:urlStr];
    }
    return imgUrls;
}

@end
