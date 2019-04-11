//
//  LLAdvertNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/6.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLAdvertNode : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, assign) int EnumAdrGroup;
@property (nonatomic, assign) int AdvertiType;
@property (nonatomic, strong) NSString *DataTitle;
@property (nonatomic, strong) NSString *DataUrl;
@property (nonatomic, strong) NSString *DataImg;
@property (nonatomic, strong) NSString *UrlAddress;
@property (nonatomic, assign) int SortNum;
@property (nonatomic, strong) NSString *UserId;
@property (nonatomic, strong) NSString *ProvinceId;
@property (nonatomic, strong) NSString *CityId;
@property (nonatomic, strong) NSString *CountyId;
@property (nonatomic, assign) CGFloat Price;
@property (nonatomic, strong) NSString *ExpireTime;
@property (nonatomic, strong) NSString *AddTime;

@end

NS_ASSUME_NONNULL_END
