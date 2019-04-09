//
//  LLBeeTaskViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeTaskViewController.h"
#import "LLBeeTaskTableViewCell.h"
#import "LLInvitationCodeViewController.h"
#import "LLPublishViewController.h"

@interface LLBeeTaskViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataLists;

@property (nonatomic, assign) int recommendCount;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation LLBeeTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
    [self getRecommendCount];
}

- (void)setup {
    self.title = @"蜂巢任务";
}

- (void)refreshData {
    self.dataLists = [NSMutableArray array];
    [self.dataLists addObject:@{@"title":@"邀请2人成为黄蜂",@"des":@"每日可抢100红包"}];
    [self.dataLists addObject:@{@"title":@"邀请10人成为大黄蜂",@"des":@"每日可无限抢取红包"}];
    [self.dataLists addObject:@{@"title":@"发一个不小于1元任务红包",@"des":@"奖励10蜂蜜"}];
    
    [self.tableView reloadData];
}

- (void)getRecommendCount {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetRecommendCount"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caCheKey = @"GetRecommendCount";
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                NSDictionary *dic = data[0];
                weakSelf.recommendCount = [dic[@"RecommendCount"] intValue];
                weakSelf.isFirst = [dic[@"IsFirst"] boolValue];
            }
        }
        [weakSelf.tableView reloadData];
        
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
    return self.dataLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LLBeeTaskTableViewCell";
    LLBeeTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        [cell.btnTask addTarget:self action:@selector(handleClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSDictionary *dic = self.dataLists[indexPath.row];
    cell.labTitle.text = dic[@"title"];
    cell.labDes.text = dic[@"des"];
    [cell.btnTask setTitle:@"去邀请" forState:UIControlStateNormal];
//    cell.btnTask.enabled = true;
//    cell.btnTask.backgroundColor = kAppThemeColor;
    if (indexPath.row == 0) {
        cell.labCount.text = [NSString stringWithFormat:@"%d/2",self.recommendCount];
    } else if (indexPath.row == 1) {
        cell.labCount.text = [NSString stringWithFormat:@"%d/10",self.recommendCount];
    } else if (indexPath.row == 2) {
        [cell.btnTask setTitle:@"去完成" forState:UIControlStateNormal];
        int count = 0;
        if (self.isFirst) {
            count = 1;
            [cell.btnTask setTitle:@"已完成" forState:UIControlStateNormal];
        }
        cell.labCount.text = [NSString stringWithFormat:@"%d/1",count];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
}

-(void)handleClickAt:(id)sender event:(id)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath) {
//        NSDictionary *dic = self.dataLists[indexPath.row];
        if (indexPath.row == 2) {
            LLPublishViewController *vc = [[LLPublishViewController alloc] init];
            vc.publishVcType = LLPublishViewcTypeRedpacket;
            [self.navigationController pushViewController:vc animated:true];
        } else {
            LLInvitationCodeViewController *vc = [[LLInvitationCodeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
    }
}

@end
