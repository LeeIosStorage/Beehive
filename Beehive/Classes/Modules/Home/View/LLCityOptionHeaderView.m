//
//  LLCityOptionHeaderView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/3.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCityOptionHeaderView.h"
#import "LLCollectionView.h"
#import "LLCityOptionCollectionViewCell.h"

static NSString *const kLLCityOptionCollectionViewCell = @"LLCityOptionCollectionViewCell";

@interface LLCityOptionHeaderView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) LLCollectionView *collectionView;

@end

@implementation LLCityOptionHeaderView

- (void)setup {
    [super setup];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(9);
        make.height.mas_equalTo(47);
    }];
    [self.collectionView reloadData];
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowOffset = CGSizeMake(0, 3);
}

- (void)setRedCityArray:(NSMutableArray *)redCityArray {
    _redCityArray = redCityArray;
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark - SettingAndGetting
- (LLCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[LLCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = false;
        [_collectionView registerNib:[UINib nibWithNibName:kLLCityOptionCollectionViewCell bundle:nil] forCellWithReuseIdentifier:kLLCityOptionCollectionViewCell];
    }
    return _collectionView;
}

#pragma mark
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.redCityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LLCityOptionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLLCityOptionCollectionViewCell forIndexPath:indexPath];
    [cell updateCellWithData:self.redCityArray[indexPath.row]];
    return cell;
}

#pragma mark
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.selectBlock) {
        self.selectBlock(self.redCityArray[indexPath.row]);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(34, 47);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
