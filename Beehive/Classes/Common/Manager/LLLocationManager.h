//
//  LLLocationManager.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/2.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLLocationManager : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;

+ (LLLocationManager *)sharedInstance;
- (void)login;
- (void)logout;

@end

NS_ASSUME_NONNULL_END
