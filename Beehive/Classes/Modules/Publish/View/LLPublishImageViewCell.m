//
//  LLPublishImageViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/8.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPublishImageViewCell.h"
#import "LLPublishCellNode.h"
#import <HXPhotoPicker/HXPhotoPicker.h>

@interface LLPublishImageViewCell ()
<
HXPhotoViewDelegate
>

@property (nonatomic, weak) IBOutlet UILabel *labTitle;

@property (nonatomic, weak) IBOutlet HXPhotoView *photoView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *photoViewConstraintH;
@property (nonatomic, strong) HXPhotoManager *photoManager;
@property (nonatomic, strong) HXDatePhotoToolManager *toolManager;


@end

@implementation LLPublishImageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.photoView = [HXPhotoView photoManager:self.photoManager];
    self.photoView.manager = self.photoManager;
    self.photoView.delegate = self;
    self.photoView.outerCamera = YES;
    self.photoView.previewShowDeleteButton = YES;
    self.photoView.showAddCell = YES;
    [self.photoView.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    LLPublishCellNode *cellNode = (LLPublishCellNode *)node;
    self.node = cellNode;
    self.labTitle.text = cellNode.title;
}

- (HXPhotoManager *)photoManager {
    if (!_photoManager) {
        HXPhotoManagerSelectedType type = HXPhotoManagerSelectedTypePhoto;
        _photoManager = [[HXPhotoManager alloc] initWithType:type];
        _photoManager.configuration.openCamera = YES;
        _photoManager.configuration.saveSystemAblum = YES;
        _photoManager.configuration.themeColor = kAppThemeColor;
        _photoManager.configuration.lookLivePhoto = YES;
        _photoManager.configuration.photoMaxNum = 9;
        _photoManager.configuration.videoMaxNum = 1;
        _photoManager.configuration.videoMaxDuration = 500.f;
        _photoManager.configuration.showDateSectionHeader = NO;
        _photoManager.configuration.selectTogether = NO;
        _photoManager.configuration.photoCanEdit = NO;
        _photoManager.configuration.hideOriginalBtn = YES;
        _photoManager.configuration.reverseDate = YES;
    }
    return _photoManager;
}

#pragma mark -
#pragma mark - HXPhotoViewDelegate

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    LLPublishCellNode *cellNode = (LLPublishCellNode *)self.node;
    cellNode.uploadImageDatas = [NSMutableArray array];
//    WEAKSELF
    if (photos.count > 0) {
        // 获取图片
        [self.toolManager getSelectedImageList:allList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
            for (UIImage *image in imageList) {
                NSData *imageData = UIImageJPEGRepresentation(image, WY_IMAGE_COMPRESSION_QUALITY);
                [cellNode.uploadImageDatas addObject:imageData];
            }
        } failed:^{
            
        }];
    }
}

- (void)photoView:(HXPhotoView *)photoView imageChangeComplete:(NSArray<UIImage *> *)imageList {
    NSSLog(@"%@",imageList);
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    
    //    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + 106 + 50 + kPhotoViewMargin*2 + 140);
    //    [self updateViewConstraints];
    self.photoViewConstraintH.constant = CGRectGetHeight(frame);
}

- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index {
    NSSLog(@"%@ --> index - %ld",model,index);
}

- (BOOL)photoViewShouldDeleteCurrentMoveItem:(HXPhotoView *)photoView {
    return YES;
}
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerBegan:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    //    [UIView animateWithDuration:0.25 animations:^{
    //        self.bottomView.alpha = 0.5;
    //    }];
    //    NSSLog(@"长按手势开始了 - %ld",indexPath.item);
}
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerChange:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    //    CGPoint point = [longPgr locationInView:self.view];
    //    if (point.y >= self.bottomView.hx_y) {
    //        [UIView animateWithDuration:0.25 animations:^{
    //            self.bottomView.alpha = 1;
    //        }];
    //    }else {
    //        [UIView animateWithDuration:0.25 animations:^{
    //            self.bottomView.alpha = 0.5;
    //        }];
    //    }
    //    NSSLog(@"长按手势改变了 %@ - %ld",NSStringFromCGPoint(point), indexPath.item);
}
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerEnded:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    //    CGPoint point = [longPgr locationInView:self.view];
    //    if (point.y >= self.bottomView.hx_y) {
    //        self.needDeleteItem = YES;
    //        [self.photoView deleteModelWithIndex:indexPath.item];
    //    }else {
    //        self.needDeleteItem = NO;
    //    }
    NSSLog(@"长按手势结束了 - %ld",indexPath.item);
    //    [UIView animateWithDuration:0.25 animations:^{
    //        self.bottomView.alpha = 0;
    //    }];
}

@end
