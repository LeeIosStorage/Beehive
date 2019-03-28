//
//  NSString+Unwrapped.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/28.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Unwrapped)

- (NSString *)unwrapped:(NSString *)defaultS;

@end

NS_ASSUME_NONNULL_END
