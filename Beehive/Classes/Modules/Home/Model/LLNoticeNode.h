//
//  LLNoticeNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/25.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLNoticeNode : NSObject

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Summary;
@property (strong, nonatomic) NSString *Contents;
@property (assign, nonatomic) BOOL IsRead;
@property (assign, nonatomic) NSInteger EnumMessageType;

@end

NS_ASSUME_NONNULL_END
