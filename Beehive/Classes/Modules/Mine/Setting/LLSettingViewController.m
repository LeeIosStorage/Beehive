//
//  LLSettingViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLSettingViewController.h"
#import "LLMineTableViewCell.h"
#import "LLMineNode.h"
#import "LLPayPasswordResetViewController.h"
#import "LLRedRuleViewController.h"
#import "LEFeedbackViewController.h"
#import "LLLoginPasswordResetViewController.h"
#import "LLAmendPhoneViewController.h"

@interface LLSettingViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataLists;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation LLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

#pragma mark -
#pragma mark - Private
- (void)setup {
    self.title = @"设置";
    
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    self.footerView.height = 60;
    self.tableView.tableFooterView = self.footerView;
    
    self.dataLists = [NSMutableArray array];
    LLMineNode *node = [[LLMineNode alloc] init];
    node.title = @"修改登录密码";
    node.vcType = LLMineNodeTypeSetLoginPwd;
    LLMineNode *node1 = [[LLMineNode alloc] init];
    node1.title = @"修改支付密码";
    node1.vcType = LLMineNodeTypeSetPayPwd;
    LLMineNode *node2 = [[LLMineNode alloc] init];
    node2.title = @"修改手机号";
    node2.vcType = LLMineNodeTypeSetPhone;
    [self.dataLists addObject:[NSArray arrayWithObjects:node, node1, node2, nil]];
    
    LLMineNode *node3 = [[LLMineNode alloc] init];
    node3.title = @"红包声音";
    node3.switchShow = true;
    node3.vcType = LLMineNodeTypeSetRedSound;
    [self.dataLists addObject:[NSArray arrayWithObjects:node3, nil]];
    
    LLMineNode *node4 = [[LLMineNode alloc] init];
    node4.title = @"意见反馈";
    node4.vcType = LLMineNodeTypeSetFeedback;
    LLMineNode *node5 = [[LLMineNode alloc] init];
    node5.title = @"关于蜂巢";
    node5.vcType = LLMineNodeTypeSetAbout;
    [self.dataLists addObject:[NSArray arrayWithObjects:node4, node5, nil]];
    
    LLMineNode *node6 = [[LLMineNode alloc] init];
    node6.title = @"清除缓存";
    node6.des = @"0.5M";
    node6.vcType = LLMineNodeTypeSetClearCache;
    LLMineNode *node7 = [[LLMineNode alloc] init];
    node7.title = @"版本更新";
    node7.des = @"V1.0.0";
    node7.vcType = LLMineNodeTypeSetVersion;
    [self.dataLists addObject:[NSArray arrayWithObjects:node6, node7, nil]];
    
    [self.tableView reloadData];
}

- (void)quitAction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出登录么?" preferredStyle:UIAlertControllerStyleAlert];
    WEAKSELF
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [LELoginUserManager clearUserInfo];
        [weakSelf.tabBarController setSelectedIndex:0];
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)switchRedRound:(BOOL)on {
    LELog(@"-----------%d",on);
}

#pragma mark - setget
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = kAppSectionBackgroundColor;
        
        [_footerView addSubview:self.saveButton];
        [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_footerView).offset(10);
            make.right.equalTo(self->_footerView).offset(-10);
            make.top.equalTo(self->_footerView).offset(12);
            make.bottom.equalTo(self->_footerView);
        }];
    }
    return _footerView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _saveButton.backgroundColor = kAppThemeColor;
        _saveButton.layer.cornerRadius = 3;
        _saveButton.layer.masksToBounds = true;
        [_saveButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_saveButton.titleLabel setFont:[FontConst PingFangSCRegularWithSize:14]];
        [_saveButton addTarget:self action:@selector(quitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataLists.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataLists[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    static NSString *headerIdentifier = @"UITableViewHeaderFooterView";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
        header.backgroundColor = kAppSectionBackgroundColor;
        header.contentView.backgroundColor = kAppSectionBackgroundColor;
        
        UIImageView *imgLine = [UIImageView new];
        imgLine.backgroundColor = LineColor;
        [header addSubview:imgLine];
        [imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(header);
            make.height.mas_equalTo(0.5);
        }];
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LLMineTableViewCell";
    LLMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    WEAKSELF
    cell.switchBlock = ^(BOOL on) {
        [weakSelf switchRedRound:on];
    };
    NSArray *array = self.dataLists[indexPath.section];
    [cell updateCellWithData:array[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    NSArray *array = self.dataLists[indexPath.section];
    LLMineNode *node = array[indexPath.row];
    switch (node.vcType) {
        case LLMineNodeTypeSetLoginPwd: {
            LLLoginPasswordResetViewController *vc = [[LLLoginPasswordResetViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeSetPayPwd: {
            LLPayPasswordResetViewController *vc = [[LLPayPasswordResetViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeSetPhone: {
            LLAmendPhoneViewController *vc = [[LLAmendPhoneViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeSetRedSound: {
            
        }
            break;
        case LLMineNodeTypeSetFeedback: {
            LEFeedbackViewController *vc = [[LEFeedbackViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeSetAbout: {
            LLRedRuleViewController *vc = [[LLRedRuleViewController alloc] init];
            vc.vcType = LLInfoDetailsVcTypeAbout;
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case LLMineNodeTypeSetClearCache: {
            
        }
            break;
        case LLMineNodeTypeSetVersion: {
            
        }
            break;
        default:
            break;
    }
}

@end
