//
//  LLWithdrawViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/16.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLWithdrawViewController.h"
#import "LLFundHandleHeaderView.h"

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
}

- (void)refreshData {
    
    self.fundHandleHeaderView.vcType = self.vcType;
    [self.fundHandleHeaderView updateCellWithData:nil];
    
    LLFundHandleHeaderView *headView = (LLFundHandleHeaderView *)self.tableView.tableHeaderView;
    [self.tableView layoutIfNeeded];
    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
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
