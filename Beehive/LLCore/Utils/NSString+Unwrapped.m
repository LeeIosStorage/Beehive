//
//  NSString+Unwrapped.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/28.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "NSString+Unwrapped.h"

@implementation NSString (Unwrapped)

- (NSString *)unwrapped:(NSString *)defaultS {
    if (!self || self.length == 0) {
        return defaultS;
    }
    return self;
}

@end
