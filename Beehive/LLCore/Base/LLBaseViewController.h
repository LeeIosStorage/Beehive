//
//  LLBaseViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/2/27.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYNetWorkManager.h"
#import "LERefreshHeader.h"
#import "LERefreshFooter.h"
#import "UIViewController+LLNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLBaseViewController : UIViewController

@property (strong, nonatomic) NSString *customTitle;

@property (strong, nonatomic) UIButton *rightButton;

//右边BarButton设置文字
- (void)setRightBarButtonItemWithTitle:(NSString *)title color:(UIColor *)color;
- (void)setLeftBarButtonItemWithTitle:(NSString *)title color:(UIColor *)color;

/**
 *  如果设置了rightButton或者setRightBarButtonItemWithTitle:则需要在子类中重写此方法
 */
- (void)rightButtonClicked:(id)sender;

- (void)leftButtonClicked:(id)sender;

/** 登录成功后刷新页面
 *
 */
- (void)refreshViewWithObject:(id)object;

/** 需要点击消除输入框
 *
 */
- (void)needTapGestureRecognizer;

/** 请求类
 *  EX: self.networkManager
 */
- (WYNetWorkManager *)networkManager;

//空白页面提示语
- (void)showEmptyDataSetView:(BOOL)hidden title:(NSString *)title image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
