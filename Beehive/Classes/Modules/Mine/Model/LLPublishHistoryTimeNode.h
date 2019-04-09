//
//  LLPublishHistoryTimeNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/2.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLRedpacketNode.h"
#import "LLMessageListNode.h"
#import "LLExchangeGoodsNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLPublishHistoryTimeNode : NSObject

@property (nonatomic, strong) NSString *YearName;
@property (nonatomic, strong) NSArray *RedList;

@property (nonatomic, strong) NSString *TimeName;
@property (nonatomic, strong) NSArray *FacList;

//@property (nonatomic, strong) NSString *YearName;
@property (nonatomic, strong) NSArray *GoodsList;

@end

NS_ASSUME_NONNULL_END
