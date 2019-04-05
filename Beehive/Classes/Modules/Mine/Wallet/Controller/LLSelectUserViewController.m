//
//  LLSelectUserViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/5.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLSelectUserViewController.h"
#import "LLRedReceiveUserTableViewCell.h"
#import "LESearchBar.h"

@interface LLSelectUserViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UISearchBarDelegate
>

@property (nonatomic, strong) UIView *customTitleView;
@property (nonatomic, strong) LESearchBar *searchBar;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataLists;

@end

@implementation LLSelectUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
//    self.title = @"红包详情";
    self.view.backgroundColor = UIColor.whiteColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.dataLists = [NSMutableArray array];
    
    [self createBarButtonItemAtPosition:LLNavigationBarPositionRight normalImage:[UIImage imageNamed:@"publish_close"] highlightImage:[UIImage imageNamed:@"publish_close"] text:nil action:@selector(clearAction:)];
    
    self.navigationItem.titleView = self.customTitleView;
}

#pragma mark - Request
- (void)getUserList:(NSString *)searchName {
    
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetUserList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:searchName forKey:@"searchName"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:[LLUserInfoNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        NSArray *tmpListArray = [NSArray array];
        if ([dataObject isKindOfClass:[NSArray class]]) {
            tmpListArray = (NSArray *)dataObject;
        }
        weakSelf.dataLists = [NSMutableArray array];
        [weakSelf.dataLists addObjectsFromArray:tmpListArray];
        
        [weakSelf.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
    }];
}

#pragma mark - Action
- (void)searchBarResign {
    [self.searchBar resignFirstResponder];
}

- (void)clearAction:(id)sender {
    [self searchBarResign];
    self.searchBar.text = nil;
    [self.dataLists removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - setget
- (UIView *)customTitleView {
    if (!_customTitleView) {
        _customTitleView = [[UIView alloc] init];
        _customTitleView.backgroundColor = kAppSectionBackgroundColor;
        _customTitleView.frame = CGRectMake(0, 0, SCREEN_WIDTH-100, 26);
        _customTitleView.layer.cornerRadius = 13;
        _customTitleView.layer.masksToBounds = true;
        
        self.searchBar = [[LESearchBar alloc] initWithFrame:_customTitleView.frame];
        self.searchBar.delegate = self;
        NSString *placeholder = @"输入信息内容";
        self.searchBar.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:[FontConst PingFangSCRegularWithSize:14] color:[UIColor colorWithHexString:@"a9a9aa"]];
        [_customTitleView addSubview:self.searchBar];
    }
    return _customTitleView;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [self searchAction:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self getUserList:searchText];
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
    [cell updateUserCellWithData:self.dataLists[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    LLUserInfoNode *userNode = self.dataLists[indexPath.row];
    [self.navigationController popViewControllerAnimated:NO];
    if (self.selectUserNodeBlock) {
        self.selectUserNodeBlock(userNode);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self searchBarResign];
    }
}

@end
