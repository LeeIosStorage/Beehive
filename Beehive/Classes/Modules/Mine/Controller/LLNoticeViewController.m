//
//  LLNoticeViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLNoticeViewController.h"
#import "LLRedRuleViewController.h"

@interface LLNoticeViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, assign) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataLists;

@end

@implementation LLNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [self refreshData];
}

- (void)setup {
    self.title = @"系统公告";
    if (self.vcType == LLNoticeVcTypeHelp) {
        self.title = @"帮助中心";
    }
    self.tableView.backgroundColor = self.view.backgroundColor;
    
//    self.dataLists = [NSMutableArray array];
//    [self.tableView reloadData];
}

- (void)refreshData {
    self.dataLists = [NSMutableArray array];
    [self.dataLists addObject:@"公告？"];
    [self.dataLists addObject:@"公告？"];
    [self.dataLists addObject:@"公告？"];
    [self.dataLists addObject:@"如何获得抽奖机会？"];
    
    if (self.vcType == LLNoticeVcTypeHelp) {
        self.dataLists = [NSMutableArray array];
        [self.dataLists addObject:@"如何获得抽奖机会？"];
        [self.dataLists addObject:@"如何获得抽奖机会？"];
        [self.dataLists addObject:@"如何获得抽奖机会？"];
        [self.dataLists addObject:@"如何获得抽奖机会？"];
    }
    
    [self.tableView reloadData];
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

static int label_tag = 201;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCellP";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [FontConst PingFangSCRegularWithSize:13];
        label.textColor = kAppTitleColor;
        label.tag = label_tag;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(10);
            make.centerY.equalTo(cell.contentView);
        }];
        
        UIImageView *rightImg = [UIImageView new];
        rightImg.image = [UIImage imageNamed:@"app_cell_right_icon"];
        [cell.contentView addSubview:rightImg];
        [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(11, 11));
        }];
        
        UIImageView *lineImg = [UIImageView new];
        lineImg.backgroundColor = LineColor;
        [cell.contentView addSubview:lineImg];
        [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(0);
            make.right.equalTo(cell.contentView).offset(0);
            make.bottom.equalTo(cell.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    NSString *title = self.dataLists[indexPath.row];
    UILabel *lable = (UILabel *)[cell.contentView viewWithTag:label_tag];
    lable.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    NSString *title = self.dataLists[indexPath.row];
    
    LLRedRuleViewController *vc = [[LLRedRuleViewController alloc] init];
    vc.vcType = LLInfoDetailsVcTypeNotice;
    vc.text = title;
    [self.navigationController pushViewController:vc animated:true];
}

@end
