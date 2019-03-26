//
//  LLRedpacketNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/25.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLRedpacketNode : NSObject

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *Title;
@property (assign, nonatomic) NSInteger RedType;//1：普通红包 2：提问红包 3：任务红包
@property (assign, nonatomic) CGFloat Latitude;
@property (assign, nonatomic) CGFloat Longitude;
@property (assign, nonatomic) CGFloat Distance;

@end

NS_ASSUME_NONNULL_END
