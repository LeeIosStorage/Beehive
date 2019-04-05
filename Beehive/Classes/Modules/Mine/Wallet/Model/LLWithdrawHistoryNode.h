//
//  LLWithdrawHistoryNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/5.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLWithdrawHistoryNode : NSObject

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *UserId;
@property (strong, nonatomic) NSString *Amount;
@property (strong, nonatomic) NSString *OrderNum;
@property (strong, nonatomic) NSString *AddTime;
@property (assign, nonatomic) int Ratio;
@property (assign, nonatomic) int Status;

@end

NS_ASSUME_NONNULL_END
