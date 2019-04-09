//
//  WYPayManager.m
//  WangYu
//
//  Created by KID on 15/5/20.
//  Copyright (c) 2015年 KID. All rights reserved.
//

#import "WYPayManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WYWeakArray.h"
#import "APOrderInfo.h"
#import "APRSASigner.h"

//商户号
#define MCH_ID          @"1530691401"
//商户API密钥
#define PARTNER_ID      @"fengzhuanhongbaoyingshuiwangluo1"

static WYPayManager* wy_payManager = nil;

@interface WYPayManager ()
{
    WYWeakArray* _listeners;
}
@end

@implementation WYPayManager

+ (WYPayManager*)shareInstance {
    @synchronized(self) {
        if (wy_payManager == nil) {
            wy_payManager = [[WYPayManager alloc] init];
        }
    }
    return wy_payManager;
}

- (id)init{
    self = [super init];
    if (self) {
        [WXApi registerApp:WX_ID enableMTA:YES];
    }
    return self;
}

- (void)addListener:(id<WYPayManagerListener>)listener{
    [_listeners addObject:listener];
}
- (void)removeListener:(id<WYPayManagerListener>)listener{
    [_listeners removeObject:listener];
}
- (void)login {
    _listeners = [[WYWeakArray alloc] init];
}
- (void)logout {
    [_listeners removeAllObjects];
}

- (void)payForWinxinWith:(NSDictionary *)dictionary {
    NSString *partnerId = MCH_ID;
    NSString *prepayId = [dictionary objectForKey:@"BillNumber"];
    NSString *package, *time_stamp, *nonce_str;
    time_t now;
    time(&now);
    time_stamp  = [NSString stringWithFormat:@"%ld", now];
    nonce_str	= [self generateTradeNO];
    package         = @"Sign=WXPay";
    
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:WX_ID        forKey:@"appid"];
    [signParams setObject:nonce_str!=nil?nonce_str:@""  forKey:@"noncestr"];
    [signParams setObject:package      forKey:@"package"];
    [signParams setObject:partnerId        forKey:@"partnerid"];
    [signParams setObject:time_stamp   forKey:@"timestamp"];
    [signParams setObject:prepayId!=nil?prepayId:@""     forKey:@"prepayid"];
    //生成签名
    NSString *sign  = [self createMd5Sign:signParams];
    //添加签名
    [signParams setObject:sign forKey:@"sign"];
    
    NSMutableDictionary *dict = signParams;
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [dict objectForKey:@"appid"];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = [time_stamp intValue];
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    [WXApi sendReq:req];
}

- (void)payForAlipayWith:(NSDictionary *)dictionary {
    
    // 重要说明
    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = AliPay_APPID;
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = AliPay_PrivateKey;
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        [SVProgressHUD showCustomInfoWithStatus:@"缺少appId或者私钥,请检查参数设置"];
        return;
    }
    
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    APOrderInfo* order = [APOrderInfo new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    NSString *notifyURL = [NSString stringWithFormat:@"%@%@",[WYAPIGenerate sharedInstance].baseURL, [dictionary objectForKey:@"AlipayNotify"]];
    order.notify_url = notifyURL;
    
    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = @"蜂巢红包";
    order.biz_content.subject = dictionary[@"subject"];
    order.biz_content.out_trade_no = dictionary[@"BillNumber"]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", [[dictionary objectForKey:@"PayAmount"] floatValue]]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    LELog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
     //*/
    // NOTE: 如果加签成功，则继续执行支付
//    NSString *signedString = [dictionary objectForKey:@"BillNumber"];
//    NSString *orderInfoEncoded = @"";
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"beehive";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            LELog(@"reslut = %@",resultDic);
            NSInteger status = [[resultDic objectForKey:@"resultStatus"] integerValue];
            switch (status) {
                case 9000: {
                    [SVProgressHUD showSuccessWithStatus:@"支付宝支付成功"];
                }
                    break;
                default: {
                    [SVProgressHUD showCustomErrorWithStatus:@"支付宝支付失败"];
                }
                    break;
            }
        }];
    }
    
    
    /******
    Order *order = [[Order alloc] init];
    order.partner = AliPay_PID;
    order.seller = AliPay_Seller;
//    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.tradeNO = [dictionary objectForKey:@"out_trade_no"]; //订单ID
    order.productName = [dictionary objectForKey:@"netbarName"]; //商品标题
    order.productDescription = @"上网费用"; //商品描述
    order.amount = [dictionary objectForKey:@"amount"]; //商品价格
    NSString *notifyURL = [NSString stringWithFormat:@"%@/pay/alipayNotify",[WYEngine shareInstance].baseUrl];
    order.notifyURL = notifyURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    NSString *appScheme = @"beehive";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(AliPay_PrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
//    NSArray *array = [[UIApplication sharedApplication] windows];
//    UIWindow* win=[array objectAtIndex:0];
//    [win setHidden:NO];
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
             NSLog(@"reslut = %@", resultDic);
             NSInteger status = [[resultDic objectForKey:@"resultStatus"] integerValue];
             switch (status) {
                 case 9000:
                 {
//                     NSLog(@"===============支付成功");
//                     [WYProgressHUD AlertSuccess:@"支付宝支付成功"];
                     
                     [self payTaskWithTitle:@"支付宝支付成功"];
                     //通知lisnteners
                     NSArray* listeners = [_listeners copy];
                     for (id<WYPayManagerListener> listener in listeners) {
                         if ([listener respondsToSelector:@selector(payManagerResultStatus:payType:)]) {
                             [listener payManagerResultStatus:1 payType:0];
                         }
                     }
                 }
                     break;
                 default:
                 {
                     [WYProgressHUD AlertError:@"支付宝支付失败"];
                     NSLog(@"===============支付失败%@", [resultDic objectForKey:@"memo"]);
                     NSArray* listeners = [_listeners copy];
                     for (id<WYPayManagerListener> listener in listeners) {
                         if ([listener respondsToSelector:@selector(payManagerResultStatus:payType:)]) {
                             [listener payManagerResultStatus:0 payType:0];
                         }
                     }
                 }
                     break;
             }
//             [win setHidden:YES];
         }];
        
    }
     *****/
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayReq class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"支付结果：成功！";
                [SVProgressHUD showSuccessWithStatus:@"微信支付成功"];
//                LELog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                //通知lisnteners
                NSArray* listeners = [_listeners copy];
                for (id<WYPayManagerListener> listener in listeners) {
                    if ([listener respondsToSelector:@selector(payManagerResultStatus:payType:)]) {
                        [listener payManagerResultStatus:1 payType:1];
                    }
                }
            }
                break;
                
            default:
                [SVProgressHUD showCustomErrorWithStatus:@"微信支付失败"];
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                LELog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                NSArray* listeners = [_listeners copy];
                for (id<WYPayManagerListener> listener in listeners) {
                    if ([listener respondsToSelector:@selector(payManagerResultStatus:payType:)]) {
                        [listener payManagerResultStatus:0 payType:1];
                    }
                }
                break;
        }
    }
}

//md5 encode
- (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];

    return output;
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", PARTNER_ID];
    //得到MD5 sign签名
    NSString *md5Sign =[self md5:contentString];
    
    return md5Sign;
}

- (NSString *)generateTradeNO
{
    static int kNumber = 20;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((int)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

#pragma mark - custom
/******
- (void)payTaskWithTitle:(NSString *)title{
    int tag = [[WYEngine shareInstance] getConnectTag];
    [[WYEngine shareInstance] orderTaskWithUid:[WYEngine shareInstance].uid tag:tag];
    [[WYEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [WYEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [WYProgressHUD AlertError:errorMsg];
            return;
        }
        BOOL showTaskAlter = [WYCommonUtils showTaskAlterWithJsonRetExtendDic:[jsonRet dictionaryObjectForKey:@"extend"]];
        if (showTaskAlter) {
            NSArray *completeTasks = [[jsonRet dictionaryObjectForKey:@"extend"] arrayObjectForKey:@"completeTasks"];
            if (completeTasks) {
                for (int index = 0 ; index < completeTasks.count; index ++) {
                    NSMutableDictionary *newExtendDic = [[NSMutableDictionary alloc] initWithDictionary:[jsonRet dictionaryObjectForKey:@"extend"]];
                    [newExtendDic setObject:[NSNumber numberWithInt:index] forKey:@"index"];
                    [self performSelector:@selector(showTaskAlter:) withObject:newExtendDic afterDelay:index*2.5];
                }
            }
        }else{
            [WYProgressHUD AlertSuccess:title];
        }
    }tag:tag];
}

-(void)showTaskAlter:(id)sender{
    NSDictionary *extendDic = (NSDictionary*)sender;
    NSInteger index = [extendDic intValueForKey:@"index"];
    [WYCommonUtils AlertCustom:[WYCommonUtils tipTextTaskAlterWithJsonRetExtendDic:extendDic index:index] At:nil];
}
*******/
@end
