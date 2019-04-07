//
//  LLBeeKingNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/7.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLBeeKingNode : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *UserId;
@property (nonatomic, assign) CGFloat CostMoeny;//价格
@property (nonatomic, assign) BOOL IsBiddingPrice;
@property (nonatomic, assign) CGFloat StartPrice;//最低竞价
@property (nonatomic, strong) NSString *StartTime;
@property (nonatomic, strong) NSString *EndTime;
@property (nonatomic, strong) NSString *CountyId;
@property (nonatomic, assign) int Days;
@property (nonatomic, strong) NSString *AreaName;

@end

NS_ASSUME_NONNULL_END
