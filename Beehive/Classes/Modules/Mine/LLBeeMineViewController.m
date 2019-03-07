//
//  LLBeeMineViewController.m
//  Beehive
//
//  Created by yilunzheluo on 2019/2/27.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBeeMineViewController.h"
#import "LLMessageDetailsViewController.h"
#import "LLMineCollectionViewCell.h"

static NSString *const kLLMineCollectionViewCell = @"LLMineCollectionViewCell";

@interface LLBeeMineViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation LLBeeMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}

- (void)setup {
    self.navigationItem.title = @"我的";
    
    self.view.backgroundColor = kAppSectionBackgroundColor;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = false;
//    self.collectionView.showsVerticalScrollIndicator = false;
    [self.collectionView registerNib:[UINib nibWithNibName:kLLMineCollectionViewCell bundle:nil] forCellWithReuseIdentifier:kLLMineCollectionViewCell];
    
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObject:@""];
    [self.dataSource addObject:@""];
    [self.dataSource addObject:@""];
    
    [self.collectionView reloadData];
}

- (CGSize)calculateGridImageViewSize {
    CGFloat viewWidth = SCREEN_WIDTH/3;
    return CGSizeMake(viewWidth, 80);
}

#pragma mark
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LLMineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLLMineCollectionViewCell forIndexPath:indexPath];
    
    [cell updateCellWithData:self.dataSource[indexPath.row]];
    return cell;
}

#pragma mark
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self calculateGridImageViewSize];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
