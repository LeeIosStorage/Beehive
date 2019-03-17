//
//  LLBeeQunPersonsViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/17.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeQunPersonsViewController.h"
#import "LLRedReceiveUserTableViewCell.h"

@interface LLBeeQunPersonsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataLists;

@end

@implementation LLBeeQunPersonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
}

- (void)setup {
    self.title = @"一级蜂群";
    if (self.vcType == 1) {
        self.title = @"二级蜂群";
    }
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.dataLists = [NSMutableArray array];
}

- (void)refreshData {
    self.dataLists = [NSMutableArray array];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    [self.dataLists addObject:@""];
    
    [self.tableView reloadData];
}

#pragma mark - set

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
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LLRedReceiveUserTableViewCell";
    LLRedReceiveUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
