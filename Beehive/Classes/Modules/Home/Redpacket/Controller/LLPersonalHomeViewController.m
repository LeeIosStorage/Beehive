//
//  LLPersonalHomeViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPersonalHomeViewController.h"
#import "LLPersonalHomeHeaderView.h"
#import "LLRedTaskHistoryTableViewCell.h"

@interface LLPersonalHomeViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) LLPersonalHomeHeaderView *personalHomeHeaderView;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataLists;

@end

@implementation LLPersonalHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
}

- (void)setup {
    self.title = @"个人主页";
    self.view.backgroundColor = kAppSectionBackgroundColor;
    self.dataLists = [NSMutableArray array];
    
    self.personalHomeHeaderView.height = 228;
    self.tableView.tableHeaderView = self.personalHomeHeaderView;
}

- (void)refreshData {
    self.dataLists = [NSMutableArray array];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    
    [self.personalHomeHeaderView updateCellWithData:nil];
    
    [self.tableView reloadData];
}

#pragma mark - set
- (LLPersonalHomeHeaderView *)personalHomeHeaderView {
    if (!_personalHomeHeaderView) {
        _personalHomeHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLPersonalHomeHeaderView" owner:self options:nil] firstObject];
    }
    return _personalHomeHeaderView;
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
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LLRedTaskHistoryTableViewCell";
    LLRedTaskHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    cell.indexPath = indexPath;
    [cell updateCellWithData:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
}

@end
