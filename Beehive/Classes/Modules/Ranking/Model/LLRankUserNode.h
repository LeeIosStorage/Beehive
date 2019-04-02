//
//  LLRankUserNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/2.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLRankUserNode : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *HeadImg;
@property (nonatomic, strong) NSString *Autograph;
@property (nonatomic, assign) CGFloat IncomeMoney;
@property (nonatomic, assign) int FansCount;

@end

NS_ASSUME_NONNULL_END
