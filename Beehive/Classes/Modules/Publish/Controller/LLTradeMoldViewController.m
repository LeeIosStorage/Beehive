//
//  LLTradeMoldViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLTradeMoldViewController.h"
#import "LLTradeMoldNode.h"

@interface LLTradeMoldViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *dataSoucre1;
@property (nonatomic, strong) NSMutableArray *dataSoucre2;
@property (nonatomic, weak) IBOutlet UITableView *tableView1;
@property (nonatomic, weak) IBOutlet UITableView *tableView2;

@end

@implementation LLTradeMoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
//    [self refreshData];
    [self getIndustryList];
}

- (void)setup {
    self.title = @"选择行业";
    self.tableView1.backgroundColor = kAppSectionBackgroundColor;
}

- (void)refreshData {
//    self.dataSoucre1 = [NSMutableArray array];
//    self.dataSoucre2 = [NSMutableArray array];
//    for (int i = 0; i < 7; i ++) {
//        LLTradeMoldNode *node = [[LLTradeMoldNode alloc] init];
//        node.tId = [NSNumber numberWithInt:i];
//        if (i == 0) node.title = @"生活服务";
//        else if (i == 1) node.title = @"琴棋书画";
//        else if (i == 2) node.title = @"互联网+";
//        else if (i == 3) node.title = @"聊天占卜";
//        else if (i == 4) node.title = @"教育学习";
//        else if (i == 5) node.title = @"娱乐兴趣";
//        else if (i == 6) node.title = @"其他";
//        node.secondArray = [NSMutableArray array];
//        for (int j = 0; j < 5; j ++) {
//            LLTradeMoldNode *node1 = [[LLTradeMoldNode alloc] init];
//            node1.tId = [NSNumber numberWithInt:j];
//            node1.title = [NSString stringWithFormat:@"%d",j];
//            if ([node.tId isEqualToNumber:[NSNumber numberWithInt:1]]) {
//                if (j == 0) node1.title = @"绘画";
//                else if (j == 1) node1.title = @"乐器";
//                else if (j == 2) node1.title = @"舞蹈";
//                else if (j == 3) node1.title = @"手工";
//                else if (j == 4) node1.title = @"其他";
//            }
//            [node.secondArray addObject:node1];
//        }
//        [self.dataSoucre1 addObject:node];
//    }
    
    for (LLTradeMoldNode *tmpNode in self.dataSoucre1) {
        if ([tmpNode.tId intValue] == [self.oneNode.tId intValue]) {
            self.dataSoucre2 = [NSMutableArray arrayWithArray:tmpNode.secondArray];
        }
    }
    
    [self.tableView1 reloadData];
    [self.tableView2 reloadData];
}

#pragma mark - Request
- (void)getIndustryList {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetIndustryList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caCheKey = @"GetIndustryList";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:[LLTradeMoldNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            weakSelf.dataSoucre1 = [NSMutableArray arrayWithArray:data];
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableView1 == tableView) {
        return self.dataSoucre1.count;
    }
    return self.dataSoucre2.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView1 == tableView) {
        static NSString *cellIdentifier = @"UITableViewCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.contentView.backgroundColor = kAppSectionBackgroundColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = kAppTitleColor;
            label.font = [FontConst PingFangSCRegularWithSize:13];
            label.tag = 201;
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
            }];
        }
        LLTradeMoldNode *node = self.dataSoucre1[indexPath.row];
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:201];
        label.text = node.title;
        label.textColor = kAppTitleColor;
        cell.contentView.backgroundColor = kAppSectionBackgroundColor;
        if ([self.oneNode.tId intValue] == [node.tId intValue]) {
            label.textColor = kAppThemeColor;
            cell.contentView.backgroundColor = UIColor.whiteColor;
        }
        return cell;
    }
    static NSString *cellIdentifier = @"UITableViewCell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = UIColor.whiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = kAppTitleColor;
        label.font = [FontConst PingFangSCRegularWithSize:13];
        label.tag = 202;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(30);
            make.centerY.equalTo(cell.contentView);
        }];
    }
    LLTradeMoldNode *node = self.dataSoucre2[indexPath.row];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:202];
    label.text = node.title;
    label.textColor = kAppTitleColor;
    if ([self.twoNode.tId intValue] == [node.tId intValue]) {
        label.textColor = kAppThemeColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    if (tableView == self.tableView1) {
        self.oneNode = self.dataSoucre1[indexPath.row];
        self.dataSoucre2 = [NSMutableArray arrayWithArray:self.oneNode.secondArray];
        self.twoNode = nil;
        [self.tableView1 reloadData];
        [self.tableView2 reloadData];
    } else if (tableView == self.tableView2) {
        self.twoNode = self.dataSoucre2[indexPath.row];
        [self.tableView2 reloadData];
        if (self.chooseBlock) {
            self.chooseBlock(self.oneNode, self.twoNode);
        }
        [self.navigationController popViewControllerAnimated:true];
    }
}

@end
