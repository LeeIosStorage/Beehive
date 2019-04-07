//
//  LLQueenBeeInfoNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/7.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLAdvertNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLQueenBeeInfoNode : NSObject

@property (nonatomic, assign) CGFloat Money;
@property (nonatomic, strong) NSArray *AdvertList;

@end

NS_ASSUME_NONNULL_END
