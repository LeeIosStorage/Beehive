//
//  LLPromotionExplainNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/5.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLPromotionExplainNode : NSObject

@property (nonatomic, strong) NSString *VipExplain;
@property (nonatomic, assign) int IsPromotion;
@property (nonatomic, strong) NSString *Reason;

@property (nonatomic, assign) BOOL IsVip;
@property (nonatomic, strong) NSString *VipPrice;

@end

NS_ASSUME_NONNULL_END
