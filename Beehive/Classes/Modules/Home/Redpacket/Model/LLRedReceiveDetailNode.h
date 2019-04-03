//
//  LLRedReceiveDetailNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/3.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLUserInfoNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLRedReceiveDetailNode : NSObject

@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *HeadImg;
@property (nonatomic, strong) NSArray *ReceiveCondition;
@property (nonatomic, strong) NSArray *UserList;
@property (nonatomic, assign) CGFloat Money;
@property (nonatomic, assign) int Sex;
@property (nonatomic, assign) int SumCount;
@property (nonatomic, assign) int ReceiveCount;

@end

NS_ASSUME_NONNULL_END
