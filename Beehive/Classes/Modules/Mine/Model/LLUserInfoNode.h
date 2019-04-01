//
//  LLUserInfoNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/1.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLUserInfoNode : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *UserId;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *HeadImg;
@property (nonatomic, strong) NSString *Autograph;
@property (nonatomic, strong) NSString *AddTime;
@property (nonatomic, assign) CGFloat Money;

@end

NS_ASSUME_NONNULL_END
