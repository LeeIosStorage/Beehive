//
//  LLAdvertDetailsNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/6.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLAdvertNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLAdvertDetailsNode : NSObject

@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *HeadImg;
@property (nonatomic, strong) NSString *CountyName;
@property (nonatomic, assign) int Sex;
@property (nonatomic, assign) CGFloat MoneyIncome;
@property (nonatomic, assign) BOOL IsHaveQueenBee;
@property (nonatomic, strong) NSArray *AdverList;

@end

NS_ASSUME_NONNULL_END
