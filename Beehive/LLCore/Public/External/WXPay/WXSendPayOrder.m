//
//  WXSendPayOrder.m
//  StarEasySwim
//
//  Created by yibingding/王 on 17/1/13.
//  Copyright © 2017年 YBD. All rights reserved.
//

#import "WXSendPayOrder.h"
#import "WXApi.h"

@implementation WXSendPayOrder

+ (BOOL)wxSendPayOrderWidthName:(NSString *)orderName orderNumber:(NSString *)orderNumber orderPrice:(NSString *)oederPrice notifyURL:(NSString *)notifyURL {
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc] ;
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    //NSString *str = [NSString stringWithFormat:@"%@",[payDic valueForKey:@"price"]];;
    NSMutableDictionary *dict =[req sendPay_demo:orderName order_price:oederPrice orderNo:orderNumber notifyURL:notifyURL];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
//        [YBDGlobal showAlertTitle:debug];
        //[[Global sharedInstance] alert:debug];
        
        NSLog(@"%@\n\n",debug);
        return NO;
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
        return YES;
    }
    
}
@end
