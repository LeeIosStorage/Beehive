//
//  LLPublishCellNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/8.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLTradeMoldNode.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLPublishCellType) {
    LLPublishCellTypeRedMold = 0,    //红包类型选择
    LLPublishCellTypeTaskMold,       //红包任务类型
    LLPublishCellTypeTradeMold,      //行业类型
    LLPublishCellTypeCompanyMold,    //个人企业类型
    LLPublishCellTypePhone,          //手机号
    LLPublishCellTypeInputTitle,     //输入标题
    LLPublishCellTypeImage,          //选择照片
    LLPublishCellTypeTaskName,       //任务名称
    LLPublishCellTypeTaskExplain,    //任务说明
    LLPublishCellTypeLinkAddress,    //链接地址输入
    LLPublishCellTypeLocation,       //选择位置
    LLPublishCellTypeRedAmount,      //红包金额
    LLPublishCellTypeRedCount,       //红包个数
    LLPublishCellTypeShopAddress,    //商店地址
    LLPublishCellTypeOldPrice,       //商品原价
    LLPublishCellTypeExchangeCount,  //蜂蜜兑换数
    LLPublishCellTypePubDate,        //发布时间
    LLPublishCellTypeVisible,        //可见用户
    LLPublishCellTypeMore,           //展示更多
    LLPublishCellTypeAge,
    LLPublishCellTypeSex,
    LLPublishCellTypeHobbies,        //兴趣爱好
    LLPublishCellTypeCouponName,     //优惠券名称
    LLPublishCellTypeCouponExplain,  //优惠券说明
    LLPublishCellTypeCouponPrice,    //优惠价格
    LLPublishCellTypeCouponDate,     //优惠起止时间
    LLPublishCellTypeIntro,          //输入介绍
    LLPublishCellTypeIDCard,         //身份证
    LLPublishCellTypeContacts,       //联系人
    LLPublishCellTypeShipAddress,    //收货地址
    LLPublishCellTypeHouseNumber,    //门牌号
    LLPublishCellTypeADImage,        //广告图
    
    //UserSet
    LLPublishCellTypeAvatar,         //头像
    LLPublishCellTypeNickName,       //昵称
    LLPublishCellTypeBirthdayDate,   //生日
    LLPublishCellTypeSignature,      //签名
    
};

typedef NS_ENUM(NSInteger, LLPublishInputType) {
    LLPublishInputTypeSelect = 0, //选择类型
    LLPublishInputTypeInput,      //输入类型
};

@interface LLPublishCellNode : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) NSString *placeholder; //默认文案
@property (nonatomic, strong) NSString *inputText;   //选择之后的Text
@property (nonatomic, assign) int inputMaxCount;     //最大输入字数  <=0无限制

@property (nonatomic, strong) NSMutableArray *uploadImageDatas; //图片Data

@property (nonatomic, assign) LLPublishCellType cellType; //发布功能类型
@property (nonatomic, assign) LLPublishInputType inputType; //输入功能类型

@property (nonatomic, assign) BOOL isMore; //是否展开更多
@property (nonatomic, assign) BOOL hiddenLine; //是否隐藏line

@property (nonatomic, assign) NSInteger redMold; //红包-0普通/1任务
@property (nonatomic, assign) NSInteger taskMold; //任务-0图片/1链接
@property (nonatomic, assign) NSInteger companyMold; //企业-0个人/1企业

@property (nonatomic, strong) NSDate *date; //发布时间
@property (nonatomic, assign) NSInteger visibleMold; //可见-0所有/1仅自己
@property (nonatomic, assign) NSInteger ageMold; //
@property (nonatomic, assign) NSInteger sexMold;
@property (nonatomic, strong) NSArray *hobbiesIndexs; //兴趣索引
@property (nonatomic, strong) NSString *couponPrice; //优惠价格
@property (nonatomic, strong) NSDate *couponBeginDate; //优惠开始时间
@property (nonatomic, strong) NSDate *couponEndDate; //优惠结束时间

@property (nonatomic, strong) LLTradeMoldNode *tradeMoldNode1;
@property (nonatomic, strong) LLTradeMoldNode *tradeMoldNode2;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;//经纬度
@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, strong) NSString *houseNumber;
@property (nonatomic, strong) NSString *phone;//手机号
@property (nonatomic, strong) NSString *contacts;//联系人

@end

NS_ASSUME_NONNULL_END
