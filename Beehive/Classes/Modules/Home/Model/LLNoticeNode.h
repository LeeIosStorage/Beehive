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

//收到的消息
@property (strong, nonatomic) NSString *UserId;
@property (strong, nonatomic) NSString *SendUserId;
@property (assign, nonatomic) int NoticeType;
@property (strong, nonatomic) NSString *DataId;
@property (strong, nonatomic) NSString *AddTime;
@property (strong, nonatomic) NSString *UserName;
@property (strong, nonatomic) NSString *HeadImg;
@property (strong, nonatomic) NSString *ImgUrl;
@property (strong, nonatomic) NSArray *ImgUrls;
@property (strong, nonatomic) NSString *DataTitle;
@property (strong, nonatomic) NSString *DataAddTime;

@end

NS_ASSUME_NONNULL_END
