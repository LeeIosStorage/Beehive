//
//  LLMineWalletViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/8.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMineWalletViewController.h"
#import "LLMineTableViewCell.h"
#import "LLMineNode.h"
#import "LLRedTaskHistoryViewController.h"
#import "LLWithdrawViewController.h"

@interface LLMineWalletViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIView *headerView;

@property (nonatomic, strong) NSMutableArray *dataLists;

@end

@implementation LLMineWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

#pragma mark -
#pragma mark - Private
- (void)setup {
    self.title = @"钱包";
    self.headerView.height = 225;
    self.tableView.tableHeaderView = self.headerView;
    
    self.dataLists = [NSMutableArray array];
    LLMineNode *node = [[LLMineNode alloc] init];
    node.title = @"明细";
    node.icon = @"5_5_0.5";
    node.vcType = LLMineNodeTypeWalletDetail;
    [self.dataLists addObject:node];
    
    LLMineNode *node1 = [[LLMineNode alloc] init];
    node1.title = @"蜂蜜历史";
    node1.icon = @"5_5_0.6";
    node1.vcType = LLMineNodeTypeWalletBeeHistory;
    [self.dataLists addObject:node1];
    
    LLMineNode *node2 = [[LLMineNode alloc] init];
    node2.title = @"提现明细";
    node2.icon = @"5_5_0.7";
    node2.vcType = LLMineNodeTypeWalletWithdrawDetail;
    [self.dataLists addObject:node2];
    
    [self.tableView reloadData];
}

- (IBAction)withdrawAction:(id)sender {
    LLWithdrawViewController *vc = [[LLWithdrawViewController alloc] init];
    vc.vcType = LLFundHandleVCTypeWithdraw;
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)depositAction:(id)sender {
    LLWithdrawViewController *vc = [[LLWithdrawViewController alloc] init];
    vc.vcType = LLFundHandleVCTypeDeposit;
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)presentAction:(id)sender {
    LLWithdrawViewController *vc = [[LLWithdrawViewController alloc] init];
    vc.vcType = LLFundHandleVCTypePresent;
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LLMineTableViewCell";
    LLMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    cell.indexPath = indexPath;
    [cell updateCellWithData:self.dataLists[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    LLMineNode *node = self.dataLists[indexPath.row];
    switch (node.vcType) {
        case LLMineNodeTypeWalletDetail: {
            
        }
            break;
        case LLMineNodeTypeWalletBeeHistory: {
            LLRedTaskHistoryViewController *vc = [[LLRedTaskHistoryViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeWalletWithdrawDetail: {
            
        }
            break;
        default:
            break;
    }
}

@end
