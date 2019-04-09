//
//  WXSendPayOrder.h
//  StarEasySwim
//
//  Created by yibingding/王 on 17/1/13.
//  Copyright © 2017年 YBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "payRequsestHandler.h"

@interface WXSendPayOrder : NSObject

+ (BOOL)wxSendPayOrderWidthName:(NSString *)orderName
                    orderNumber:(NSString *)orderNumber
                     orderPrice:(NSString *)oederPrice
                      notifyURL:(NSString *)notifyURL;

@end
