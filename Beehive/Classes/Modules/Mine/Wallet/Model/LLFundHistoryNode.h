//
//  LLFundHistoryNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/5.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLFundHistoryNode : NSObject

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *UserId;
@property (strong, nonatomic) NSString *Money;
@property (strong, nonatomic) NSString *DataId;
@property (strong, nonatomic) NSString *ParentId;
@property (strong, nonatomic) NSString *GrandfatherId;
@property (strong, nonatomic) NSString *FromUserId;
@property (strong, nonatomic) NSString *ToUserId;
@property (assign, nonatomic) BOOL IsCompute;
@property (assign, nonatomic) int IncomeType;
@property (assign, nonatomic) int RecordType;
@property (strong, nonatomic) NSString *AddTime;
@property (strong, nonatomic) NSString *RecordTypeStr;

@end

NS_ASSUME_NONNULL_END
