//
//  AppDelegate.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/27.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "AppDelegate.h"
#import "LLTabBarViewController.h"
#import "LLNavigationController.h"
#import "LLBeeHomeViewController.h"
#import "LLBeeMineViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#if DEBUG
    // iOS
    //热重载
    [[NSBundle bundleWithPath:@"/Applications/InjectionX.app/Contents/Resources/iOSInjection.bundle"] load];
#endif
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self initRootVc];
    [self.window makeKeyAndVisible];
    return YES;
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
    LLTabBarViewController *tabBar = [[LLTabBarViewController alloc] init];
    tabBar.viewControllers = [self tabbarControllers];
    self.window.rootViewController = tabBar;
    
    [UITabBarItem appearance].titlePositionAdjustment = UIOffsetMake(0, -3);
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    NSArray *tabBarItems = tabBar.tabBar.items;
    NSMutableArray *tabs = [NSMutableArray array];
    [tabs addObject:@{@"title":@"首页", @"nIcon":@"", @"sIcon":@""}];
    [tabs addObject:@{@"title":@"我的", @"nIcon":@"", @"sIcon":@""}];
    for (int i = 0; i < tabs.count; i++) {
        UITabBarItem *item = (UITabBarItem *)tabBarItems[i];
        NSDictionary *infoDic = tabs[i];
        item.title = infoDic[@"title"];
        item.image = [[UIImage imageNamed:infoDic[@"nIcon"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:infoDic[@"sIcon"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

- (void)initLoginVc {
    LLBeeMineViewController *vc = [[LLBeeMineViewController alloc] init];
    LLNavigationController *loginNav = [[LLNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = loginNav;
}

- (NSArray *)tabbarControllers {
    NSMutableArray *tabs = [NSMutableArray array];
    
    LLNavigationController *homeNav = [[LLNavigationController alloc] initWithRootViewController:[[LLBeeHomeViewController alloc] init]];
    LLNavigationController *mineNav = [[LLNavigationController alloc] initWithRootViewController:[[LLBeeMineViewController alloc] init]];
    [tabs addObject:homeNav];
    [tabs addObject:mineNav];
    return tabs;
}

@end
