//
//  LLWithdrawViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLWithdrawViewController.h"
#import "LLFundHandleHeaderView.h"
#import "LLBeePresentAffirmView.h"
#import "LEAlertMarkView.h"

@interface LLWithdrawViewController ()

@property (nonatomic, strong) LLFundHandleHeaderView *fundHandleHeaderView;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation LLWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
}

- (void)setup {
    self.title = @"提现";
    if (self.vcType == LLFundHandleVCTypeDeposit) {
        self.title = @"充值";
    } else if (self.vcType == LLFundHandleVCTypePresent) {
        self.title = @"赠送蜂蜜";
    }
    
    self.tableView.tableHeaderView = self.fundHandleHeaderView;
    [self.fundHandleHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        //top布局一定要加上 不然origin.y可能为负值
        make.top.width.equalTo(self.tableView);
    }];
    [self.tableView reloadData];
    
    WEAKSELF
    self.fundHandleHeaderView.affirmBlock = ^{
        if (weakSelf.vcType == LLFundHandleVCTypeWithdraw) {
            
        } else if (weakSelf.vcType == LLFundHandleVCTypeDeposit) {
            
        } else if (weakSelf.vcType == LLFundHandleVCTypePresent) {
            [weakSelf showBeePresentAffirmView];
        }
    };
}

- (void)refreshData {
    
    self.fundHandleHeaderView.vcType = self.vcType;
    [self.fundHandleHeaderView updateCellWithData:nil];
    
    LLFundHandleHeaderView *headView = (LLFundHandleHeaderView *)self.tableView.tableHeaderView;
    [self.tableView layoutIfNeeded];
    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
}

- (void)showBeePresentAffirmView {
    LLBeePresentAffirmView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLBeePresentAffirmView" owner:self options:nil] firstObject];
    tipView.frame = CGRectMake(0, 0, 260, 280);
    [tipView updateCellWithData:nil];
    __weak UIView *weakView = tipView;
    WEAKSELF
    tipView.clickBlock = ^(NSInteger index) {
        if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
            LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
            [alert dismiss];
        }
        if (index == 1) {
            
        }
    };
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:tipView type:LEAlertMarkViewTypeCenter];
    [alert show];
}

#pragma mark - set
- (LLFundHandleHeaderView *)fundHandleHeaderView {
    if (!_fundHandleHeaderView) {
        _fundHandleHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLFundHandleHeaderView" owner:self options:nil] firstObject];
    }
    return _fundHandleHeaderView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    //    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self.view endEditing:YES];
    }
}

@end
