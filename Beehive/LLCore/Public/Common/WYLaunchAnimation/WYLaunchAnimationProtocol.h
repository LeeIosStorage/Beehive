//
//  WYLaunchAnimationProtocol.h
//  WangYu
//
//  Created by XuLei on 16/2/18.
//  Copyright © 2016年 KID. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WYLaunchAnimationProtocol <NSObject>

- (void)configureAnimationWithView:(UIView *)view completion:(void (^)(BOOL finished))completion;

@end
