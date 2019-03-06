//
//  LLMessageTimeLineViewCell.m
//  Beehive
//
//  Created by liguangjun on 2019/3/5.
//  Copyright © 2019年 Leejun. All rights reserved.
//

#import "LLMessageTimeLineViewCell.h"
#import "LLHandleStatusView.h"
#import "LLCollectionView.h"
#import "LLImageItemViewCell.h"

static NSString *const kLLImageItemViewCell = @"LLImageItemViewCell";

@interface LLMessageTimeLineViewCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;

@property (nonatomic, weak) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

@property (nonatomic, weak) IBOutlet UICollectionView *gridImageView;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *gridImageViewConstraintH;

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;

@property (nonatomic, weak) IBOutlet LLHandleStatusView *handleStatusView;

@end

@implementation LLMessageTimeLineViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = UIColor.whiteColor;
    self.contentView.backgroundColor = self.backgroundColor;
    self.avatarImageView.layer.cornerRadius = 20;
    self.avatarImageView.layer.masksToBounds = true;
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    CGFloat viewWidth = (SCREEN_WIDTH-10-57-10)/3;
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
