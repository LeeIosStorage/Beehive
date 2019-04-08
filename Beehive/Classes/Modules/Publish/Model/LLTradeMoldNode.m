//
//  LLTradeMoldNode.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTradeMoldNode.h"

@implementation LLTradeMoldNode

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"tId":@"Id",
             @"title":@"Name",
             @"secondArray":@"ChildrenList",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"secondArray"   : [LLTradeMoldNode class]
             };
}

@end
