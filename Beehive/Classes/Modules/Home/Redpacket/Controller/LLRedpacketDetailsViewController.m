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
#import "LEShareSheetView.h"
#import "LLRedTaskShowAlertView.h"
#import "LEAlertMarkView.h"
#import "LLRedrReceiveDetailsViewController.h"
#import "LLPersonalHomeViewController.h"

@interface LLRedpacketDetailsViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
LEShareSheetViewDelegate
>
{
    LEShareSheetView *_shareSheetView;
}
@property (nonatomic, strong) NSMutableArray *commentLists;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) LLRedpacketDetailsHeaderView *redpacketDetailsHeaderView;

@property (nonatomic, strong) LLCommentBottomView *commentBottomView;

@property (nonatomic, assign) NSInteger currentPage;

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
    self.title = @"红包详情";
    
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
//    _tableView
    _tableView.sectionFooterHeight = UITableViewAutomaticDimension;
    
    self.currentPage = 0;
    
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
    
    WEAKSELF
    self.redpacketDetailsHeaderView.segmentedHeadView.clickBlock = ^(NSInteger index) {
        if (index == 0) {
            weakSelf.currentPage = 0;
            [weakSelf.tableView reloadData];
        } else if (index == 1) {
            weakSelf.currentPage = 1;
            [weakSelf.tableView reloadData];
        }
    };
    self.redpacketDetailsHeaderView.redReceiveBlock = ^{
        LLRedrReceiveDetailsViewController *vc = [[LLRedrReceiveDetailsViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
    self.redpacketDetailsHeaderView.avatarBlock = ^{
        LLPersonalHomeViewController *vc = [[LLPersonalHomeViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
}

- (void)refreshData {
    [self.commentLists addObject:@""];
    [self.commentLists addObject:@""];
    [self.commentLists addObject:@""];
    
    self.redpacketDetailsHeaderView.type = self.vcType;
    [self.redpacketDetailsHeaderView updateCellWithData:nil];
    
    LLRedpacketDetailsHeaderView *headView = (LLRedpacketDetailsHeaderView *)self.tableView.tableHeaderView;
    [self.tableView layoutIfNeeded];
    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
}

#pragma mark - Action
- (void)moreAction:(id)sender {
    [self redTaskAlertViewShow];
}

- (void)sendComment {
    [self.view endEditing:true];
}

- (void)shareAction {
    
    LEShareModel *shareModel = [[LEShareModel alloc] init];
    shareModel.shareTitle = @"领红包";
    shareModel.shareDescription = @"";
    shareModel.shareWebpageUrl = [NSString stringWithFormat:@"%@/%@",[WYAPIGenerate sharedInstance].baseURL, kLLH5_DownLoad_Html_Url];
    //    shareModel.shareImage = [];
    _shareSheetView = [[LEShareSheetView alloc] init];
    _shareSheetView.owner = self;
    _shareSheetView.shareModel = shareModel;
    [_shareSheetView showShareAction];
}

- (void)redTaskAlertViewShow {
    LLRedTaskShowAlertView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"LLRedTaskShowAlertView" owner:self options:nil] firstObject];
    tipView.frame = CGRectMake(0, 0, 270, 115);
    __weak UIView *weakView = tipView;
    WEAKSELF
    tipView.clickBlock = ^{
        if ([weakView.superview isKindOfClass:[LEAlertMarkView class]]) {
            LEAlertMarkView *alert = (LEAlertMarkView *)weakView.superview;
            [alert dismiss];
        }
//        [weakSelf ];
    };
    LEAlertMarkView *alert = [[LEAlertMarkView alloc] initWithCustomView:tipView type:LEAlertMarkViewTypeCenter];
    [alert show];
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
        _commentBottomView.commentBottomViewHandleBlock = ^(NSInteger index) {
            if (index == 0) {
                [weakSelf shareAction];
            }
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
    if (self.currentPage == 1) {
        return 0;
    }
    return self.commentLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.currentPage == 0) {
        return 0;
    }
    return 130;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.currentPage == 0) {
        return nil;
    }
    static NSString *headerIdentifier = @"UITableViewHeaderFooterView";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
        header.backgroundColor = kAppBackgroundColor;
        header.contentView.backgroundColor = kAppBackgroundColor;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kAppTitleColor;
        label.font = [FontConst PingFangSCRegularWithSize:13];
        label.numberOfLines = 0;
        label.tag = 201;
        [header.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsMake(15, 10, 25, 10));
            make.left.equalTo(header.contentView).offset(10);
            make.right.equalTo(header.contentView).offset(-10);
            make.top.equalTo(header.contentView).offset(10);
//            make.bottom.equalTo(header.contentView).offset(-10);
        }];
        
        UIImageView *imgLine = [UIImageView new];
        imgLine.backgroundColor = LineColor;
        [header.contentView addSubview:imgLine];
        [imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(header);
            make.height.mas_equalTo(0.5);
        }];
    }
    UILabel *label = (UILabel *)[header.contentView viewWithTag:201];
    label.text = @"红包任务介绍红包任务介绍红包任务介绍红包任务介绍红包任务介绍红包任务介绍红包任务介绍红包任务介绍红包任务介绍红包任务介绍红包任务介绍红包任务介绍红包任务介绍红包任务介绍红包任务介绍红包任务介绍红包任务介绍";
    return header;
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
