//
//  LLMineMessageNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/4.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLNoticeNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLMineMessageNode : NSObject

@property (assign, nonatomic) int CommentCount;
@property (assign, nonatomic) int GoodCount;
@property (strong, nonatomic) NSArray *NoticeList;

@end

NS_ASSUME_NONNULL_END
