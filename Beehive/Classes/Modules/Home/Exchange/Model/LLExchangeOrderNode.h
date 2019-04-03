//
//  LLExchangeOrderNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/29.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLExchangeOrderNode : NSObject

@property (strong, nonatomic) NSString *Id;
@property (nonatomic, strong) NSString *UserId;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *HeadImg;
@property (nonatomic, assign) int Sex;
@property (nonatomic, strong) NSString *AddTime;
@property (nonatomic, strong) NSString *Money;

@property (nonatomic, strong) NSString *GoodsId;
@property (nonatomic, strong) NSString *GoodsUserId;
@property (nonatomic, strong) NSString *GoodsName;
@property (nonatomic, strong) NSString *GoodsImg;
@property (nonatomic, assign) CGFloat GoodsPrice;
@property (nonatomic, assign) int BuyStatus;
@property (nonatomic, assign) int BuyType;
@property (strong, nonatomic) NSString *ProvinceId;
@property (strong, nonatomic) NSString *CityId;
@property (strong, nonatomic) NSString *CountyId;
@property (assign, nonatomic) CGFloat Longitude;
@property (assign, nonatomic) CGFloat Latitude;
@property (strong, nonatomic) NSString *Address;
@property (strong, nonatomic) NSString *Phone;

@property (strong, nonatomic) NSString *CouponMoney;//优惠价格
@property (strong, nonatomic) NSString *CouponName;
@property (strong, nonatomic) NSString *CouponExplain;
@property (strong, nonatomic) NSString *CouponTime;
@property (assign, nonatomic) NSInteger Days;

@end

NS_ASSUME_NONNULL_END
