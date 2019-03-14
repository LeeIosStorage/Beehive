//
//  LLRedpacketDetailsViewController.m
//  Beehive
//
//  Created by liguangjun on 2019/3/14.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLRedpacketDetailsViewController.h"
#import "LLRedpacketDetailsHeaderView.h"
#import "LLMessageCommentViewCell.h"
#import "LLCommentBottomView.h"

@interface LLRedpacketDetailsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *commentLists;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) LLRedpacketDetailsHeaderView *redpacketDetailsHeaderView;

@property (nonatomic, strong) LLCommentBottomView *commentBottomView;

@end

@implementation LLRedpacketDetailsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.estimatedRowHeight = 73;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.commentLists = [NSMutableArray array];
    
    self.tableView.tableHeaderView = self.redpacketDetailsHeaderView;
    [self.redpacketDetailsHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        //top布局一定要加上 不然origin.y可能为负值
        make.top.width.equalTo(self.tableView);
    }];
    
    [self.tableView reloadData];
    
    [self.view addSubview:self.commentBottomView];
    [self.commentBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
}

- (void)refreshData {
    [self.commentLists addObject:@""];
    [self.commentLists addObject:@""];
    [self.commentLists addObject:@""];
    
    [self.redpacketDetailsHeaderView updateCellWithData:nil];
    
    LLRedpacketDetailsHeaderView *headView = (LLRedpacketDetailsHeaderView *)self.tableView.tableHeaderView;
    [self.tableView layoutIfNeeded];
    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
}

#pragma mark - Action
- (void)moreAction:(id)sender {
    
}

- (void)sendComment {
    [self.view endEditing:true];
}

#pragma mark -
#pragma mark - NSNotification
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [self.commentBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-keyboardRect.size.height);
        }];
        [self.view layoutIfNeeded];
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [self.commentBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(0);
        }];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - set
- (LLRedpacketDetailsHeaderView *)redpacketDetailsHeaderView {
    if (!_redpacketDetailsHeaderView) {
        _redpacketDetailsHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLRedpacketDetailsHeaderView" owner:self options:nil] firstObject];
    }
    return _redpacketDetailsHeaderView;
}

- (LLCommentBottomView *)commentBottomView {
    if (!_commentBottomView) {
        _commentBottomView = [[LLCommentBottomView alloc] init];
        
        WEAKSELF
        _commentBottomView.commentBottomViewSendBlock = ^{
            [weakSelf sendComment];
        };
    }
    return _commentBottomView;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self.view endEditing:YES];
    }
}

@end
