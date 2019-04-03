//
//  LLRedpacketNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/25.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLUserInfoNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLRedpacketNode : NSObject

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *Title;
@property (assign, nonatomic) NSInteger RedType;//1：普通红包 2：任务红包 3：提问红包
@property (assign, nonatomic) int RedClassify;//0默认 1：上传图片；2：添加链接
@property (assign, nonatomic) CGFloat Latitude;
@property (assign, nonatomic) CGFloat Longitude;
@property (assign, nonatomic) CGFloat Distance;
@property (nonatomic, assign) BOOL IsGood;
@property (nonatomic, assign) BOOL IsCollection;

@property (strong, nonatomic) NSString *UserId;
@property (assign, nonatomic) int ProvinceId;
@property (assign, nonatomic) int CityId;
@property (assign, nonatomic) int CountyId;
@property (assign, nonatomic) int RadiusType;
@property (assign, nonatomic) CGFloat Money;
@property (assign, nonatomic) int Count;
@property (assign, nonatomic) CGFloat SurplusMoney;//剩余
@property (assign, nonatomic) int SurplusCount;//剩余
@property (strong, nonatomic) NSString *ReleaseTime;
@property (assign, nonatomic) int VisibleUser;
@property (assign, nonatomic) int ScreenStarAge;
@property (assign, nonatomic) int ScreenEndAge;
@property (strong, nonatomic) NSString *ScreenHobby;
@property (assign, nonatomic) int ScreenSex;
@property (assign, nonatomic) int CommentCount;
@property (assign, nonatomic) int LookCount;
@property (assign, nonatomic) int GoodCount;
@property (strong, nonatomic) NSString *TaskName;
@property (strong, nonatomic) NSString *TaskExplain;
@property (strong, nonatomic) NSString *TaskSummary;
@property (strong, nonatomic) NSString *AdvertImg;
@property (strong, nonatomic) NSString *UrlAddress;
@property (strong, nonatomic) NSString *AddTime;
@property (strong, nonatomic) NSString *UserName;
@property (strong, nonatomic) NSString *HeadImg;
@property (assign, nonatomic) int Sex;
@property (strong, nonatomic) id ImgList;
@property (strong, nonatomic) NSArray *ImgUrls;
@property (assign, nonatomic) CGFloat MyRedMoney;
@property (strong, nonatomic) NSArray *RedList;

@end

NS_ASSUME_NONNULL_END
