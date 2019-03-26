//
//  LLHomeNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/25.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLRedCityNode.h"
#import "LLRedpacketNode.h"
#import "LLNoticeNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLHomeNode : NSObject

@property (strong, nonatomic) NSArray *NoticeList;
@property (strong, nonatomic) NSArray *RedEnvelopesList; //圈里
@property (strong, nonatomic) NSArray *FirstRowRedList;
@property (strong, nonatomic) NSArray *AdvertInfo;

@property (strong, nonatomic) NSString *ProvinceName;
@property (strong, nonatomic) NSString *CityName;
@property (strong, nonatomic) NSString *CountyName;

@property (strong, nonatomic) NSString *QueenName;
@property (strong, nonatomic) NSString *QueenHeadImg;
@property (assign, nonatomic) BOOL isHaveQueen;

@end

NS_ASSUME_NONNULL_END
