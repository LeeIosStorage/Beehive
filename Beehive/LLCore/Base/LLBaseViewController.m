//
//  LLBaseViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/27.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"
#import "UIViewController+LLNavigationBar.h"

@interface LLBaseViewController ()
<
UIGestureRecognizerDelegate
>

@property (strong, nonatomic) WYNetWorkManager *networkManager;

@property (strong, nonatomic) UIView *customTitleView;
@property (strong, nonatomic) UILabel *customTitleLabel;

@property (strong, nonatomic) UIView *emptyDataSetView;
@property (strong, nonatomic) UILabel *emptyTipLabel;
@property (strong, nonatomic) UIImageView *emptyTipImageView;

@end

@implementation LLBaseViewController

#pragma mark -
#pragma mark - Lifecycle
- (void)dealloc{
    LELog(@"!!!!!");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kAppBackgroundColor;
    
    if (self.navigationController.viewControllers.count > 1) {
        [self createBarButtonItemAtPosition:LLNavigationBarPositionLeft normalImage:[UIImage imageNamed:@"light_nav_back"] highlightImage:[UIImage imageNamed:@"light_nav_back"] text:@"" action:@selector(backAction:)];
    } else {
    }
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

//- (void)injected {
//    NSLog(@"I've been injected: %@", self);
//    self.view.backgroundColor = UIColor.darkGrayColor;
//    self.navigationItem.title = @"我又来了1111222111";
//}

#pragma mark -
#pragma mark - Public
- (void)setCustomTitle:(NSString *)customTitle{
    _customTitle = customTitle;
    
    self.navigationItem.titleView = self.customTitleView;
    _customTitleLabel.text = customTitle;
    
    _customTitleLabel.frame = self.navigationItem.titleView.bounds;
}

- (void)setRightButton:(UIButton *)rightButton{
    
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    _rightButton = rightButton;
}

- (void)setRightBarButtonItemWithTitle:(NSString *)title color:(UIColor *)color{
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClicked:)];
    rightBarButtonItem.tintColor = color;
    [rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:HitoPFSCRegularOfSize(14)} forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:HitoPFSCRegularOfSize(14)} forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setLeftBarButtonItemWithTitle:(NSString *)title color:(UIColor *)color{
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClicked:)];
    leftBarButtonItem.tintColor = color;
    [leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:HitoPFSCRegularOfSize(16)} forState:UIControlStateNormal];
    [leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:HitoPFSCRegularOfSize(16)} forState:UIControlStateSelected];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)needTapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}

- (void)refreshViewWithObject:(id)object
{
    
}

- (void)rightButtonClicked:(id)sender
{
    
}

- (void)leftButtonClicked:(id)sender
{
    
}

- (void)showEmptyDataSetView:(BOOL)hidden title:(NSString *)title image:(UIImage *)image{
    UIView *view = self.view;
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            view = subView;
            break;
        }
    }
    
    if (!hidden) {
        if (!self.emptyDataSetView.superview) {
            [view addSubview:self.emptyDataSetView];
            [self.emptyDataSetView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(view);
                make.width.mas_equalTo(SCREEN_WIDTH-12*2);
                make.top.equalTo(view).offset(100);
            }];
        }
        self.emptyTipLabel.text = title;
        self.emptyTipImageView.image = image;
        CGSize size = image.size;
        [self.emptyTipImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
        }];
        
    }else{
        
    }
    self.emptyDataSetView.hidden = hidden;
}

#pragma mark -
#pragma mark - Private
- (void)viewTapped
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - Set And Getters
- (WYNetWorkManager *)networkManager{
    if (!_networkManager) {
        _networkManager = [[WYNetWorkManager alloc] init];
    }
    return _networkManager;
}

- (UIView *)customTitleView{
    if (!_customTitleView) {
        _customTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        //        _customTitleView.backgroundColor = [UIColor yellowColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:_customTitleView.bounds];
        _customTitleLabel = titleLabel;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = HitoPFSCRegularOfSize(17);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_customTitleView addSubview:titleLabel];
        
    }
    return _customTitleView;
}

- (UIView *)emptyDataSetView{
    if (!_emptyDataSetView) {
        _emptyDataSetView = [[UIView alloc] init];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        _emptyTipImageView = imageView;
        [_emptyDataSetView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self->_emptyDataSetView);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"666666"];
        //        label.backgroundColor = kAppThemeColor;
        label.font = HitoPFSCRegularOfSize(15);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        _emptyTipLabel = label;
        [_emptyDataSetView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self->_emptyDataSetView);
            make.top.equalTo(imageView.mas_bottom).offset(15);
        }];
    }
    return _emptyDataSetView;
}

@end
