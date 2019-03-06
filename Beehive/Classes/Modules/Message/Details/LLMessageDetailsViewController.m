//
//  LLMessageDetailsViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/6.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMessageDetailsViewController.h"
#import "LLMessageDetailsHeaderView.h"
#import "LLMessageCommentViewCell.h"

@interface LLMessageDetailsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *commentLists;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) LLMessageDetailsHeaderView *messageDetailsHeaderView;

@end

@implementation LLMessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
}

- (void)setup {
    self.title = @"详情";
    
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:[UIImage imageNamed:@"message_details_more"] highlightImage:[UIImage imageNamed:@"message_details_more"] text:@"" action:@selector(moreAction:)];
    self.view.backgroundColor = kAppSectionBackgroundColor;
    
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.estimatedRowHeight = 73;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.commentLists = [NSMutableArray array];
    
    self.messageDetailsHeaderView.height = 419;
    self.tableView.tableHeaderView = self.messageDetailsHeaderView;
    
    [self.tableView reloadData];
    
}

- (void)refreshData {
    [self.commentLists addObject:@""];
    [self.commentLists addObject:@""];
    [self.commentLists addObject:@""];
    
    [self.tableView reloadData];
}

#pragma mark - Action
- (void)moreAction:(id)sender {
    
}

#pragma mark - set
- (LLMessageDetailsHeaderView *)messageDetailsHeaderView {
    if (!_messageDetailsHeaderView) {
        _messageDetailsHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLMessageDetailsHeaderView" owner:self options:nil] firstObject];
    }
    return _messageDetailsHeaderView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LLMessageCommentViewCell";
    LLMessageCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    [cell updateCellWithData:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    //    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

@end
