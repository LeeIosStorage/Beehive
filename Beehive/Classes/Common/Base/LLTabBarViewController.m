//
//  LLTabBarViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/27.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTabBarViewController.h"
#import "LLNavigationController.h"
#import "LLBeeHomeViewController.h"
#import "LLBeeMessageViewController.h"
#import "LLBeeRankingViewController.h"
#import "LLBeeMineViewController.h"

@interface LLTabBarViewController ()

@end

@implementation LLTabBarViewController

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    UIOffset titlePositionAdjustment = UIOffsetZero;
    CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers tabBarItemsAttributes:self.tabBarItemsAttributesForController imageInsets:imageInsets titlePositionAdjustment:titlePositionAdjustment context:nil];
//    tabBarController.tabBarHeight = 70;
    [self customizeTabBarAppearance:tabBarController];
    return (self = (LLTabBarViewController *)tabBarController);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray *)viewControllers {
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    LLNavigationController *homeNav = [[LLNavigationController alloc] initWithRootViewController:[[LLBeeHomeViewController alloc] init]];
    LLNavigationController *messageNav = [[LLNavigationController alloc] initWithRootViewController:[[LLBeeMessageViewController alloc] init]];
    LLNavigationController *rankNav = [[LLNavigationController alloc] initWithRootViewController:[[LLBeeRankingViewController alloc] init]];
    LLNavigationController *mineNav = [[LLNavigationController alloc] initWithRootViewController:[[LLBeeMineViewController alloc] init]];
    [viewControllers addObject:homeNav];
    [viewControllers addObject:messageNav];
    [viewControllers addObject:rankNav];
    [viewControllers addObject:mineNav];
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *firstItem = @{CYLTabBarItemTitle : @"首页",
                                CYLTabBarItemImage : @"tab_home_normal",
                                CYLTabBarItemSelectedImage : @"tab_home_highlight"
                                };
    NSDictionary *secondItem = @{CYLTabBarItemTitle : @"消息",
                                CYLTabBarItemImage : @"tab_message_normal",
                                CYLTabBarItemSelectedImage : @"tab_message_highlight"
                                };
    NSDictionary *thirdItem = @{CYLTabBarItemTitle : @"排行榜",
                                CYLTabBarItemImage : @"tab_ranking_normal",
                                CYLTabBarItemSelectedImage : @"tab_ranking_highlight"
                                };
    NSDictionary *fourthItem = @{CYLTabBarItemTitle : @"我的",
                                CYLTabBarItemImage : @"tab_account_normal",
                                CYLTabBarItemSelectedImage : @"tab_account_highlight"
                                };
    NSArray *tabBarItemsAttributes = @[
                                       firstItem,
                                       secondItem,
                                       thirdItem,
                                       fourthItem
                                       ];
    return tabBarItemsAttributes;
}

- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    UITabBar *tabBarAppearance = [UITabBar appearance];
    [UITabBar appearance].translucent = NO;
    NSString *tabBarBackgroundImageName = @"tabbarBg";
    UIImage *tabBarBackgroundImage = [UIImage imageNamed:tabBarBackgroundImageName];
    UIImage *scanedTabBarBackgroundImage = [[self class] scaleImage:tabBarBackgroundImage];
    [tabBarAppearance setBackgroundImage:scanedTabBarBackgroundImage];
    
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

+ (UIImage *)scaleImage:(UIImage *)image {
    CGFloat halfWidth = image.size.width/2;
    CGFloat halfHeight = image.size.height/2;
    UIImage *secondStrechImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(halfHeight, halfWidth, halfHeight, halfWidth) resizingMode:UIImageResizingModeStretch];
    return secondStrechImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
