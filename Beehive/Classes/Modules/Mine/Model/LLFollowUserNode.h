//
//  LLFollowUserNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/31.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLFollowUserNode : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *UserId;
@property (nonatomic, strong) NSString *FollowUserId;
@property (nonatomic, assign) BOOL IsMutualFollow; //互相关注
@property (nonatomic, strong) NSString *AddTime;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *HeadImg;
@property (nonatomic, strong) NSString *Autograph;

@end

NS_ASSUME_NONNULL_END
