//
//  LLChooseLocationViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLChooseLocationViewController.h"
#import "LLChooseLocationScopeView.h"

@interface LLChooseLocationViewController ()

@property (nonatomic, strong) LLChooseLocationScopeView *chooseLocationScopeView;

@property (nonatomic, strong) UIButton *affirmButton;

@end

@implementation LLChooseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.title = @"选择位置";
    [self.view addSubview:self.chooseLocationScopeView];
    [self.chooseLocationScopeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(110);
    }];
    
    [self.view addSubview:self.affirmButton];
    [self.affirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    self.chooseLocationScopeView.chooseCityBlock = ^{
        
    };
    self.chooseLocationScopeView.chooseScopeBlock = ^(NSInteger index) {
        
    };
}

- (void)affirmAction {
//    if (self.currentCoordinate.latitude == 0 || self.currentCoordinate.longitude == 0) {
//        [SVProgressHUD showCustomInfoWithStatus:@"请选择地址"];
//        return;
//    }
//    if (self.chooseCoordinateBlock) {
//        self.chooseCoordinateBlock(self.currentCoordinate, self.currentAddress);
//    }
//    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - setget
- (LLChooseLocationScopeView *)chooseLocationScopeView {
    if (!_chooseLocationScopeView) {
        _chooseLocationScopeView = [[[NSBundle mainBundle] loadNibNamed:@"LLChooseLocationScopeView" owner:self options:nil] firstObject];
    }
    return _chooseLocationScopeView;
}

- (UIButton *)affirmButton {
    if (!_affirmButton) {
        _affirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_affirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_affirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _affirmButton.backgroundColor = kAppThemeColor;
        [_affirmButton.titleLabel setFont:[FontConst PingFangSCRegularWithSize:14]];
        _affirmButton.layer.cornerRadius = 3;
        _affirmButton.layer.masksToBounds = true;
        [_affirmButton addTarget:self action:@selector(affirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _affirmButton;
}

@end
