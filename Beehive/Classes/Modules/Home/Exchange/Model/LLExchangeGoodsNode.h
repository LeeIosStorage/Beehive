//
//  LLExchangeGoodsNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/28.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLExchangeGoodsNode : NSObject

//"Id": 11,
//"UserId": 2,
//"Name": "这是个苹果商品",
//"OldPrice": 26,
//"NowPrice": 15,
//"LookCount": 0,
//"ConvertCount": 0,
//"ProvinceId": 330000,
//"CityId": 330100,
//"CountyId": 330110,
//"IsRecommend": false,
//"VisualUser": 0,
//"Longitude": 120.0548,
//"Latitude": 30.28294,
//"ContactsName": "钉包包",
//"Phone": "13803812345",
//"Address": "浙江省杭州市西湖区蒋村街道凌波路103-105号西溪花园·凌波苑 12幢2单元401",
//"ConvertExplain": "兑换礼品赠送价值观念不同颜色苹果",
//"ImgUrl": "[\"/upload/HeadImg/2019/03/28/0328101829792R6B8.jpg\"]",
//"ReleaseTime": "2019-03-29 00:00:00",
//"AddTime": "2019-03-28 22:18:29"

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *UserId;
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSString *OldPrice;
@property (strong, nonatomic) NSString *NowPrice;
@property (assign, nonatomic) int LookCount;
@property (assign, nonatomic) int ConvertCount;
@property (strong, nonatomic) NSString *ProvinceId;
@property (strong, nonatomic) NSString *CityId;
@property (strong, nonatomic) NSString *CountyId;
@property (assign, nonatomic) BOOL IsRecommend;
@property (assign, nonatomic) NSInteger VisualUser;
@property (assign, nonatomic) CGFloat Longitude;
@property (assign, nonatomic) CGFloat Latitude;
@property (strong, nonatomic) NSString *ContactsName;
@property (strong, nonatomic) NSString *Phone;
@property (strong, nonatomic) NSString *Address;
@property (strong, nonatomic) NSString *ConvertExplain;
@property (strong, nonatomic) NSString *ImgUrl;
@property (strong, nonatomic) NSArray *ImgList;
@property (strong, nonatomic) NSArray *ImgUrls;
@property (strong, nonatomic) NSString *ReleaseTime;
@property (strong, nonatomic) NSString *AddTime;

//详情数据
//"UserName": "leejunnnn",
//"HeadImg": "/upload/headImg.png",
//"Autograph": "",
//"Sex": 1,
//"IsCollection": false,
//"IsHaveCash": true,
//"CashPrice": 2,
//"CouponName": "你你就会",
//"CouponExplain": "你也不知道",
//"CashTime": "2019-03-30-2019-03-31",
//"Days": 1

@property (strong, nonatomic) NSString *UserName;
@property (strong, nonatomic) NSString *HeadImg;
@property (strong, nonatomic) NSString *Autograph;
@property (assign, nonatomic) NSInteger Sex;
@property (assign, nonatomic) BOOL IsCollection;
@property (assign, nonatomic) BOOL IsHaveCash;
@property (strong, nonatomic) NSString *CashPrice;//优惠价格
@property (strong, nonatomic) NSString *CouponName;
@property (strong, nonatomic) NSString *CouponExplain;
@property (strong, nonatomic) NSString *CashTime;
@property (assign, nonatomic) NSInteger Days;


@end

NS_ASSUME_NONNULL_END
