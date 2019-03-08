//
//  LLPlusButton.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/28.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPlusButton.h"
#import "LEPublishMenuView.h"
#import "LLRedRuleViewController.h"
#import "LELoginManager.h"
#import "LLPublishViewController.h"

@implementation LLPlusButton

#pragma mark -
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

#pragma mark -
#pragma mark - CYLPlusButtonSubclassing Methods
+ (id)plusButton {
    LLPlusButton *button = [[LLPlusButton alloc] init];
    UIImage *normalButtonImage = [UIImage imageNamed:@"tab_post_highlight"];
    UIImage *hlightButtonImage = [UIImage imageNamed:@"tab_post_highlight"];
    [button setImage:normalButtonImage forState:UIControlStateNormal];
    [button setImage:hlightButtonImage forState:UIControlStateSelected];
    UIImage *normalButtonBackImage = [UIImage imageNamed:@"tab_videoback"];
    [button setBackgroundImage:normalButtonBackImage forState:UIControlStateNormal];
    [button setBackgroundImage:normalButtonBackImage forState:UIControlStateSelected];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
    [button sizeToFit];
    button.frame = CGRectMake(0.0, 0.0, 55, 59);
    
    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark -
#pragma mark - Event Response
- (void)clickPublish {
    CYLTabBarController *tabBarController = [self cyl_tabBarController];
    UINavigationController *viewController = tabBarController.selectedViewController;
    
//    __weak UINavigationController *weakVc = viewController;
    LEPublishMenuView *publishMenuView = [[LEPublishMenuView alloc] initWithActionBlock:^(NSInteger index) {
        
//        [[LELoginManager sharedInstance] needUserLogin:tabBarController];
        if (index == 0) {
            LLPublishViewController *vc = [[LLPublishViewController alloc] init];
            vc.publishVcType = LLPublishViewcTypeRedpacket;
            [viewController pushViewController:vc animated:true];
        } else if (index == 1) {
            LLPublishViewController *vc = [[LLPublishViewController alloc] init];
            vc.publishVcType = LLPublishViewcTypeExchange;
            [viewController pushViewController:vc animated:true];
        } else if (index == 2) {
            LLPublishViewController *vc = [[LLPublishViewController alloc] init];
            vc.publishVcType = LLPublishViewcTypeAsk;
            [viewController pushViewController:vc animated:true];
        } else if (index == 3) {
            LLPublishViewController *vc = [[LLPublishViewController alloc] init];
            vc.publishVcType = LLPublishViewcTypeConvenience;
            [viewController pushViewController:vc animated:true];
        }
    }];
    [publishMenuView showInView:tabBarController.view];
}

#pragma mark - CYLPlusButtonSubclassing
+ (NSUInteger)indexOfPlusButtonInTabBar {
    return 2;
}

+ (BOOL)shouldSelectPlusChildViewController {
    BOOL isSelected = CYLExternPlusButton.selected;
    if (isSelected) {
    } else {
    }
    return YES;
}

+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight {
    return  0.3;
}

+ (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight {
    return (CYL_IS_IPHONE_X ? - 6 : 4);
}

@end
