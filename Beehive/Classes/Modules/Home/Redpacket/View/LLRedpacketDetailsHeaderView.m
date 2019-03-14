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
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *acceptViewConstraintH;
@property (nonatomic, weak) IBOutlet UIView *adsView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *adsViewConstraintH;
@property (nonatomic, weak) IBOutlet UIView *allowView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *allowViewConstraintH;

@end

@implementation LLRedpacketDetailsHeaderView

- (void)setup {
    [super setup];
    self.images = [NSMutableArray array];
    
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
}

- (void)updateCellWithData:(id)node {
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:@""] setImage:self.avatarImageView setbitmapImage:[UIImage imageNamed:@"app_def"]];
    self.contentLabel.text = @"信息正文信息正文信息正文信息正文信息正文信息正文信息正文信息正文";
    //    self.gridImageView.backgroundColor = kAppThemeColor;
    self.images = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
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
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LLImageItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLLImageItemViewCell forIndexPath:indexPath];
    
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
    return [self calculateGridImageViewSize];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
