//
//  LLCommentNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/2.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLCommentNode : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *ReceivedId;
@property (nonatomic, strong) NSString *DataId;
@property (nonatomic, assign) int DataType; //（1：普通红包；2：红包任务；3：提问红包；4：便民信息）；
@property (nonatomic, assign) int CommnetType;
@property (nonatomic, assign) BOOL IsRead;
@property (nonatomic, assign) BOOL IsOptimum;
@property (nonatomic, strong) NSString *AddTime;
@property (nonatomic, strong) NSString *Contents;
@property (nonatomic, strong) NSString *UserId;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *HeadImg;
@property (nonatomic, assign) NSInteger Sex;

@end

NS_ASSUME_NONNULL_END
