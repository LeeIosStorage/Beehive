//
//  LLBidAdvertNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/9.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLUserInfoNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLBidAdvertNode : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, assign) int BidType;
@property (nonatomic, assign) BOOL IsBidPrice;
@property (nonatomic, assign) int Days;
@property (nonatomic, assign) CGFloat Money;
@property (nonatomic, strong) NSString *StartTime;
@property (nonatomic, strong) NSString *EndTime;

@property (nonatomic, strong) NSArray *BidPriceList;

@end

NS_ASSUME_NONNULL_END
