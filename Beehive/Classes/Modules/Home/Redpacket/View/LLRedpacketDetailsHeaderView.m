//
//  LLRedpacketDetailsHeaderView.m
//  Beehive
//
//  Created by liguangjun on 2019/3/14.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLRedpacketDetailsHeaderView.h"
#import "LLImageItemViewCell.h"

static NSString *const kLLImageItemViewCell = @"LLImageItemViewCell";

@interface LLRedpacketDetailsHeaderView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;

@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *likeCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *redPriceLabel;

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

@property (nonatomic, weak) IBOutlet UICollectionView *gridImageView;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *gridImageViewConstraintH;

@property (nonatomic, weak) IBOutlet UIView *acceptView;
@property (nonatomic, weak) IBOutlet UILabel *acceptRedLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *acceptViewConstraintH;
@property (nonatomic, weak) IBOutlet UIView *adsView;
@property (nonatomic, weak) IBOutlet UIImageView *adsImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *adsViewConstraintH;
@property (nonatomic, weak) IBOutlet UIView *allowView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *allowViewConstraintH;
@property (nonatomic, weak) IBOutlet UICollectionView *allowCollectionView;
@property (nonatomic, strong) NSMutableArray *users;


@end

@implementation LLRedpacketDetailsHeaderView

- (void)setup {
    [super setup];
    self.images = [NSMutableArray array];
    self.users = [NSMutableArray array];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.gridImageView.collectionViewLayout = flowLayout;
    self.gridImageView.delegate = self;
    self.gridImageView.dataSource = self;
    self.gridImageView.showsHorizontalScrollIndicator = false;
    self.gridImageView.showsVerticalScrollIndicator = false;
    [self.gridImageView registerNib:[UINib nibWithNibName:kLLImageItemViewCell bundle:nil] forCellWithReuseIdentifier:kLLImageItemViewCell];
    
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.minimumLineSpacing = 8;
//    flowLayout1.minimumInteritemSpacing = 5;
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.allowCollectionView.collectionViewLayout = flowLayout1;
    self.allowCollectionView.delegate = self;
    self.allowCollectionView.dataSource = self;
    self.allowCollectionView.showsHorizontalScrollIndicator = false;
    self.allowCollectionView.showsVerticalScrollIndicator = false;
    [self.allowCollectionView registerNib:[UINib nibWithNibName:kLLImageItemViewCell bundle:nil] forCellWithReuseIdentifier:kLLImageItemViewCell];
    
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:@""] setImage:self.avatarImageView setbitmapImage:[UIImage imageNamed:@"app_def"]];
    self.contentLabel.text = @"信息正文信息正文信息正文信息正文信息正文信息正文信息正文信息正文";
    //    self.gridImageView.backgroundColor = kAppThemeColor;
    self.images = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        [self.images addObject:kLLAppTestHttpURL];
    }
    [self.gridImageView reloadData];
    
    NSInteger row = self.images.count/3;
    if (self.images.count%3 == 0) {
        row -= 1;
    }
    CGFloat height = (row+1)*[self calculateGridImageViewSize].height + row*5;
    if (self.images.count == 0) {
        height = 0;
    }
    self.gridImageViewConstraintH.constant = height;
    
    self.users = [NSMutableArray array];
    for (int i = 0; i < 14; i ++) {
        [self.users addObject:kLLAppTestHttpURL];
    }
    [self.allowCollectionView reloadData];
    
    NSArray *items = nil;
    if (self.type == 0) {
        self.acceptViewConstraintH.constant = 48;
        self.acceptView.hidden = false;
        self.adsViewConstraintH.constant = 0;
        self.allowViewConstraintH.constant = 0;
        self.adsView.hidden = true;
        self.allowView.hidden = true;
        NSString *acceptMoney = @"20";
        NSString *acceptText = [NSString stringWithFormat:@"回答被采纳后将获得%@元红包",acceptMoney];
        self.acceptRedLabel.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:acceptText range:NSMakeRange(9, acceptMoney.length) font:[FontConst PingFangSCRegularWithSize:13] color:UIColor.redColor];
        
        items = @[@{kllSegmentedTitle:@"全部答案",kllSegmentedType:@(0)},@{kllSegmentedTitle:@"红包任务介绍",kllSegmentedType:@(0)}];
        
    } else if (self.type == 1) {
        self.acceptViewConstraintH.constant = 0;
        self.acceptView.hidden = true;
        self.adsViewConstraintH.constant = 180;
        self.adsView.hidden = false;
        self.allowViewConstraintH.constant = 106;
        self.allowView.hidden = false;
        [WYCommonUtils setImageWithURL:[NSURL URLWithString:kLLAppTestHttpURL] setImage:self.adsImageView setbitmapImage:nil];
        
        items = @[@{kllSegmentedTitle:@"评论",kllSegmentedType:@(0)},@{kllSegmentedTitle:@"红包任务介绍",kllSegmentedType:@(0)}];
    }
    
    [self.segmentedHeadView setItems:items];
}

- (CGSize)calculateGridImageViewSize {
    CGFloat viewWidth = (SCREEN_WIDTH-10-10-10)/3;
    return CGSizeMake(viewWidth, viewWidth);
}

#pragma mark
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.allowCollectionView) {
        return self.users.count;
    }
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.allowCollectionView) {
        LLImageItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLLImageItemViewCell forIndexPath:indexPath];
        cell.imageView.layer.cornerRadius = 20;
        cell.imageView.layer.masksToBounds = true;
        
        [cell updateCellWithData:self.users[indexPath.row]];
        return cell;
    }
    LLImageItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLLImageItemViewCell forIndexPath:indexPath];
    cell.imageView.layer.cornerRadius = 4;
    cell.imageView.layer.masksToBounds = true;
    [cell updateCellWithData:self.images[indexPath.row]];
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
    if (collectionView == self.allowCollectionView) {
        return CGSizeMake(40, 40);
    }
    return [self calculateGridImageViewSize];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
