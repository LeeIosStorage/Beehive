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
#import "LLCommentBottomView.h"
#import "LLLocationManager.h"
#import "LLCommentNode.h"
#import "LEShareSheetView.h"
#import "LEMenuView.h"
#import "LLReportViewController.h"

@interface LLMessageDetailsViewController ()
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

@property (nonatomic, strong) LLMessageDetailsHeaderView *messageDetailsHeaderView;

@property (nonatomic, strong) LLCommentBottomView *commentBottomView;

@property (assign, nonatomic) int nextCursor;

@end

@implementation LLMessageDetailsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self refreshData];
    [self getFacilitateDetail];
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
    
    self.tableView.tableHeaderView = self.messageDetailsHeaderView;
    [self.messageDetailsHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        //top布局一定要加上 不然origin.y可能为负值
        make.top.width.equalTo(self.tableView);
    }];
    
    [self.tableView reloadData];
    
    [self.view addSubview:self.commentBottomView];
    [self.commentBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
    
    self.nextCursor = 1;
    [self addMJ];
}

- (void)refreshData {
    
    [self.messageDetailsHeaderView updateCellWithData:self.messageListNode];
    
    LLMessageDetailsHeaderView *headView = (LLMessageDetailsHeaderView *)self.tableView.tableHeaderView;
    [self.tableView layoutIfNeeded];
    self.tableView.tableHeaderView = headView;
    
    [self.tableView reloadData];
    
    [self refreshStateUI];
}

- (void)refreshStateUI {
    self.commentBottomView.btnCollect.selected = self.messageListNode.IsCollection;
    self.commentBottomView.btnLike.selected = self.messageListNode.IsGood;
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    WEAKSELF;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        weakSelf.nextCursor = 1;
        [weakSelf getCommentList];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上啦加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getCommentList];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

#pragma mark - Request
- (void)getFacilitateDetail {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetFacilitateDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.messageListNode.Id forKey:@"id"];
    [params setValue:[NSNumber numberWithDouble:[LLLocationManager sharedInstance].currentCoordinate.latitude] forKey:@"latitude"];
    [params setValue:[NSNumber numberWithDouble:[LLLocationManager sharedInstance].currentCoordinate.longitude] forKey:@"longitude"];
    NSString *caCheKey = [NSString stringWithFormat:@"GetFacilitateDetail-%@",self.messageListNode.Id];
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:[LLMessageListNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                LLMessageListNode *node = data[0];
                NSString *Id = weakSelf.messageListNode.Id;
                int commentCount = weakSelf.messageListNode.CommentCount;
                
                weakSelf.messageListNode = node;
                weakSelf.messageListNode.Id = Id;
                weakSelf.messageListNode.CommentCount = commentCount;
            }
        }
        [weakSelf refreshData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)getCommentList {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetCommentList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.messageListNode.Id forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"pageSize"];
    //type：类别（1：普通红包；2：红包任务；3：提问红包；4：便民信息）；
    [params setObject:[NSNumber numberWithInteger:4] forKey:@"type"];
    
    NSString *caCheKey = [NSString stringWithFormat:@"GetCommentList-4-%@",self.messageListNode.Id];
    BOOL needCache = false;
    if (self.nextCursor == 1) needCache = true;
    [self.networkManager POST:requesUrl needCache:needCache caCheKey:caCheKey parameters:params responseClass:[LLCommentNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        NSArray *tmpListArray = [NSArray array];
        if ([dataObject isKindOfClass:[NSArray class]]) {
            tmpListArray = (NSArray *)dataObject;
        }
        if (weakSelf.nextCursor == 1) {
            weakSelf.commentLists = [NSMutableArray array];
        }
        [weakSelf.commentLists addObjectsFromArray:tmpListArray];
        
        if (!isCache) {
            if (tmpListArray.count < DATA_LOAD_PAGESIZE_COUNT) {
                [weakSelf.tableView.mj_footer setHidden:YES];
            }else{
                [weakSelf.tableView.mj_footer setHidden:NO];
                weakSelf.nextCursor ++;
            }
        }
        
        [weakSelf.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)sendComment:(NSString *)content {
    [self.view endEditing:true];
    [SVProgressHUD showCustomWithStatus:@"发送中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"CommentRedEnvelopes"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.messageListNode.Id forKey:@"id"];
    [params setValue:content forKey:@"contents"];
    //type：类别（0：红包；1：便民信息）
    [params setObject:[NSNumber numberWithInteger:1] forKey:@"type"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLCommentNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        weakSelf.commentBottomView.textField.text = nil;
        [weakSelf.tableView.mj_header beginRefreshing];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)collectionRequest {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"RedEnvelopesCollection"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.messageListNode.Id forKey:@"id"];
    //type：类别（0：商品；1：红包；2：便民信息）
    [params setObject:[NSNumber numberWithInt:2] forKey:@"type"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                
            }
        }
        weakSelf.messageListNode.IsCollection = !weakSelf.messageListNode.IsCollection;
        [weakSelf refreshStateUI];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

- (void)likeRequest {
    [SVProgressHUD showCustomWithStatus:@"请求中..."];
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"RedEnvelopesGood"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.messageListNode.Id forKey:@"id"];
    //type：类别（0：红包；1：便民信息）
    [params setObject:[NSNumber numberWithInt:1] forKey:@"type"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [SVProgressHUD dismiss];
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:message];
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            if (data.count > 0) {
                
            }
        }
        weakSelf.messageListNode.IsGood = !weakSelf.messageListNode.IsGood;
        [weakSelf refreshStateUI];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

#pragma mark - Action
- (void)moreAction:(id)sender {
    LEMenuView *menuView = [[LEMenuView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, HitoTopHeight, 80, 67)];
    [menuView show];
    
    WEAKSELF
    menuView.menuViewClickBlock = ^(NSInteger index) {
        if (index == 0) {
            LLReportViewController *vc = [[LLReportViewController alloc] init];
            vc.dataId = self.messageListNode.Id;
            vc.type = 3;
            [weakSelf.navigationController pushViewController:vc animated:true];
        }
    };
}

- (void)shareAction {
    [self.view endEditing:true];
    LEShareModel *shareModel = [[LEShareModel alloc] init];
    shareModel.shareTitle = self.messageListNode.Title;
    shareModel.shareDescription = @"";
    shareModel.shareWebpageUrl = [NSString stringWithFormat:@"%@/%@",[WYAPIGenerate sharedInstance].baseURL, kLLH5_DownLoad_Html_Url];
    //    shareModel.shareImage = [];
    _shareSheetView = [[LEShareSheetView alloc] init];
    _shareSheetView.owner = self;
    _shareSheetView.shareModel = shareModel;
    [_shareSheetView showShareAction];
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
- (LLMessageDetailsHeaderView *)messageDetailsHeaderView {
    if (!_messageDetailsHeaderView) {
        _messageDetailsHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LLMessageDetailsHeaderView" owner:self options:nil] firstObject];
    }
    return _messageDetailsHeaderView;
}

- (LLCommentBottomView *)commentBottomView {
    if (!_commentBottomView) {
        _commentBottomView = [[LLCommentBottomView alloc] init];
        
        WEAKSELF
        _commentBottomView.commentBottomViewSendBlock = ^(NSString * _Nonnull commentText) {
            [weakSelf sendComment:commentText];
        };
        _commentBottomView.commentBottomViewHandleBlock = ^(NSInteger index) {
            if (index == 0) {
                [weakSelf shareAction];
            } else if (index == 1) {
                [weakSelf likeRequest];
            } else if (index == 2) {
                [weakSelf collectionRequest];
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
    [cell updateCellWithData:self.commentLists[indexPath.row]];
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
