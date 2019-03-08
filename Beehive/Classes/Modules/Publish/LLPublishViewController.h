//
//  LLPublishViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/8.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLPublishViewcType) {
    LLPublishViewcTypeRedpacket,   //红包任务
    LLPublishViewcTypeExchange,    //兑换商品
    LLPublishViewcTypeAsk,         //提问红包
    LLPublishViewcTypeConvenience  //便民信息
};

@interface LLPublishViewController : LLBaseViewController

@property (nonatomic, assign) LLPublishViewcType publishVcType;

@end

NS_ASSUME_NONNULL_END
