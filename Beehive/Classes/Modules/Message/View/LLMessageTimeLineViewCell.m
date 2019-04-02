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
#import "LLMessageListNode.h"

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    LLMessageListNode *messageNode = (LLMessageListNode *)node;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:messageNode.HeadImg] setImage:self.avatarImageView setbitmapImage:[UIImage imageNamed:@""]];
    UIImage *sexImage = [UIImage imageNamed:@"user_sex_man"];
    if (messageNode.Sex == 1) {
        sexImage = [UIImage imageNamed:@"user_sex_woman"];
    }
    self.sexImageView.image = sexImage;
    
    self.nickNameLabel.text = messageNode.UserName;
    self.timeLabel.text = [WYCommonUtils dateDiscriptionFromNowBk:[WYCommonUtils dateFromUSDateString:messageNode.AddTime]];
    self.distanceLabel.text = [WYCommonUtils distanceFormatWithDistance:messageNode.Distance];
    
    self.contentLabel.text = messageNode.Title;
    self.images = [NSMutableArray arrayWithArray:messageNode.ImgUrls];
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
    
    [self.handleStatusView.readButton setTitle:[NSString stringWithFormat:@" %d", messageNode.LookCount] forState:UIControlStateNormal];
    [self.handleStatusView.commentButton setTitle:[NSString stringWithFormat:@" %d", messageNode.CommentCount] forState:UIControlStateNormal];
    [self.handleStatusView.favourButton setTitle:[NSString stringWithFormat:@" %d", messageNode.GoodCount] forState:UIControlStateNormal];
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
