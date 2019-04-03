//
//  LLPersonalHomeNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/3.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLUserInfoNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLPersonalHomeNode : LLUserInfoNode

@property (nonatomic, assign) int FollowCount;
@property (nonatomic, assign) int BeFollowCount;
@property (nonatomic, assign) int ReleaseCount;
@property (nonatomic, assign) BOOL IsFollow;

@end

NS_ASSUME_NONNULL_END
