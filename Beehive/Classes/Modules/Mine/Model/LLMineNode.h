//
//  LLMineNode.h
//  Beehive
//
//  Created by liguangjun on 2019/3/7.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLMineNodeType) {
    LLMineNodeTypeWallet, //钱包
    LLMineNodeTypeBeeQun, //蜂群
    LLMineNodeTypeBeeLobby, //大厅
    LLMineNodeTypeBeeTask, //任务
    LLMineNodeTypeCode, //邀请码
    LLMineNodeTypeOrder, //兑换订单
    LLMineNodeTypeNotice, //公告
    LLMineNodeTypeHelp, //
    LLMineNodeTypeSet, //
    LLMineNodeTypeVIP, //
    LLMineNodeTypeTui,  //
    //设置相关
    LLMineNodeTypeSetLoginPwd, //修改登录密码
    LLMineNodeTypeSetPayPwd, //修改支付密码
    LLMineNodeTypeSetPhone, //修改手机号
    //钱包相关
    LLMineNodeTypeWalletDetail, //明细
    LLMineNodeTypeWalletBeeHistory, //
    LLMineNodeTypeWalletWithdrawDetail, //提现明细
};

@interface LLMineNode : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, assign) LLMineNodeType vcType;

@end

NS_ASSUME_NONNULL_END
