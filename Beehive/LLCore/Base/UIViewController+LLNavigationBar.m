//
//  UIViewController+LLNavigationBar.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/1.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "UIViewController+LLNavigationBar.h"

@implementation UIViewController (LLNavigationBar)

- (void)createBarButtonItemAtPosition:(LLNavigationBarPosition)position
                          normalImage:(UIImage *)normalImage
                       highlightImage:(UIImage *)highlightImage
                                 text:(NSString *)text
                               action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setFrame:CGRectMake(0, 0, 64, 44)];
    [button setTitleColor:kAppTitleColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateHighlighted];
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleInsets = UIEdgeInsetsZero;
    switch (position) {
        case LLNavigationBarPositionLeft:
            imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            break;
        case LLNavigationBarPositionRight:
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            break;
        default:
            break;
    }
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [button setImageEdgeInsets:imageInsets];
    [button setTitleEdgeInsets:titleInsets];
    
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateHighlighted];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    switch (position) {
        case LLNavigationBarPositionLeft:
            negativeSpacer.width = -11;//可修正iOS11之前的偏移
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barButtonItem, nil];
//            self.navigationItem.leftBarButtonItem = barButtonItem;
//            self.navigationItem.hidesBackButton = false;
            break;
        case LLNavigationBarPositionRight:
            negativeSpacer.width = -11;//可修正iOS11之前的偏移
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barButtonItem, nil];
//            self.navigationItem.rightBarButtonItem = barButtonItem;
            break;
        default:
            break;
    }
}

@end
