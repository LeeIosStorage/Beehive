//
//  LELoginModel.m
//  XWAPP
//
//  Created by hys on 2018/5/21.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LELoginModel.h"

@implementation LELoginModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID":@"Id",
             @"headImgUrl":@"HeadImg",
             @"nickname":@"NickName",
             @"sessionToken":@"SessionToken",
             @"name":@"Name",
             @"mobile":@"Phone",
             @"payPassWord":@"PayPassWord",
             @"sex":@"Sex",
             @"invitationCode":@"InvitationCode",
             @"birthdayDate":@"BirthdayDate",
             @"regTime":@"reg_time",
             @"income" : @"IncomeMoney",
             @"readDuration" : @"read_duration",
             @"todayGolds" : @"today_golds",
             @"totalGolds" : @"total_golds",
             };
}

- (NSString *)headImgUrl{
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",[WYAPIGenerate sharedInstance].baseURL, [_headImgUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    return urlStr;
}

@end
