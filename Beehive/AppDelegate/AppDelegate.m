//
//  AppDelegate.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/27.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "AppDelegate.h"
#import "LLTabBarViewController.h"
#import "LLPlusButton.h"
#import "LLNavigationController.h"
#import "LLBeeHomeViewController.h"
#import "LLBeeMineViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "LLLoginViewController.h"
#import "LLAddShopAddressViewController.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WYShareManager.h"
#import "UMSocialWechatHandler.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()
<
UITabBarControllerDelegate
>

@property (nonatomic, strong) LLTabBarViewController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#if DEBUG
    // iOS
    //热重载
    [[NSBundle bundleWithPath:@"/Applications/InjectionX.app/Contents/Resources/iOSInjection.bundle"] load];
    //
    [CocoaDebug enable];
#endif
    
    [SVProgressHUD setCurrentDefaultStyle];
    
    [WYAPIGenerate sharedInstance].netWorkHost = defaultNetworkHost;
    
    [self configPlatforms];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self initRootVc];
//    [self initLoginVc];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)configPlatforms {
    [AMapServices sharedServices].apiKey = AMapKey;
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMS_APPKEY];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_ID appSecret:WX_Secret redirectURL:nil];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    LELog(@"query=%@,scheme=%@,host=%@", url.query, url.scheme, url.host);
    NSString *scheme = [url scheme];
    
    //三方登录
    BOOL isUMSocial = ([[url absoluteString] hasPrefix:[NSString stringWithFormat:@"tencent%@://qzapp",QQ_ID]] || [[url absoluteString] hasPrefix:[NSString stringWithFormat:@"%@://oauth",WX_ID]]);
    if (isUMSocial) {
        //        _isUMSocialLogin = NO;
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    //    [TencentOAuth CanHandleOpenURL:url]
    
    if ([scheme hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:[WYShareManager shareInstance]];
    }
    if ([scheme hasPrefix:@"wb"]) {
        return [WeiboSDK handleOpenURL:url delegate:[WYShareManager shareInstance]];
    }
    if ([scheme hasPrefix:@"tencent"]) {
        return [QQApiInterface handleOpenURL:url delegate:[WYShareManager shareInstance]];
    }
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSInteger status = [[resultDic objectForKey:@"resultStatus"] integerValue];
            switch (status) {
                case 9000:
                {
                    [SVProgressHUD showCustomSuccessWithStatus:@"支付成功"];
                }
                    break;
                default:
                {
                    [SVProgressHUD showCustomErrorWithStatus:@"支付失败"];
                }
                    break;
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    LELog(@"openURL url=%@, sourceApplication=%@, annotation=%@", url, sourceApplication, annotation);
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [self handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - init
- (void)initRootVc {
    
//    LLAddShopAddressViewController *vc = [[LLAddShopAddressViewController alloc] init];
//    LLNavigationController *nav = [[LLNavigationController alloc] initWithRootViewController:vc];
//    self.window.rootViewController = nav;
//    return;
    
    
    [LLPlusButton registerPlusButton];
    LLTabBarViewController *tabBarController = [[LLTabBarViewController alloc] init];
    [tabBarController hideTabBadgeBackgroundSeparator];
    tabBarController.delegate = self;
    tabBarController.selectedIndex = 0;
    self.tabBarController = tabBarController;
    self.window.rootViewController = tabBarController;
}

- (void)initLoginVc {
    LLLoginViewController *vc = [[LLLoginViewController alloc] init];
    LLNavigationController *loginNav = [[LLNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = loginNav;
}

#pragma mark - 
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        UIViewController *currentVc = [nav.viewControllers lastObject];
        if ([currentVc isKindOfClass:[LLBeeMineViewController class]]) {
            if ([[LELoginManager sharedInstance] needUserLogin:tabBarController]) {
                return NO;
            }
            return YES;
        }
    }
    return YES;
}

@end
