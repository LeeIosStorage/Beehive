//
//  LLMessageListNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/2.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLMessageListNode : NSObject

@property (nonatomic, assign) NSInteger Row;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *UserId;
@property (nonatomic, assign) NSInteger OneTypeId;
@property (nonatomic, assign) NSInteger TwoTypeId;
@property (nonatomic, assign) NSInteger SendType;
@property (nonatomic, assign) NSInteger ProvinceId;
@property (nonatomic, assign) NSInteger CityId;
@property (nonatomic, assign) NSInteger CountyId;
@property (nonatomic, assign) int LookCount;
@property (nonatomic, assign) int CommentCount;
@property (nonatomic, assign) int GoodCount;
@property (nonatomic, assign) CGFloat Longitude;
@property (nonatomic, assign) CGFloat Latitude;
@property (nonatomic, assign) CGFloat Distance;
@property (nonatomic, strong) NSString *Phone;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *Address;
@property (nonatomic, strong) NSString *ImgUrlList;
@property (nonatomic, strong) NSArray *ImgList;
@property (nonatomic, strong) NSArray *ImgUrls;
@property (nonatomic, strong) NSString *AddTime;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *Autograph;
@property (nonatomic, strong) NSString *HeadImg;
@property (nonatomic, assign) BOOL IsGood;
@property (nonatomic, assign) BOOL IsCollection;
@property (nonatomic, assign) NSInteger Sex;

@end

NS_ASSUME_NONNULL_END
