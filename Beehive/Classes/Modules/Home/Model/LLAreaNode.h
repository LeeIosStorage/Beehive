//
//  LLAreaNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/7.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLAreaNode : NSObject

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *FullName;
@property (strong, nonatomic) NSArray *Children;

@end

NS_ASSUME_NONNULL_END
