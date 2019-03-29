//
//  LLWalletDetailsNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/29.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLWalletDetailsNode : NSObject

@property (strong, nonatomic) NSString *WithdrawalExplain;
@property (strong, nonatomic) NSString *NickName;
@property (strong, nonatomic) NSString *Money;
@property (assign, nonatomic) int Ratio;

@property (strong, nonatomic) NSString *Explain; //赠送说明

@end

NS_ASSUME_NONNULL_END
