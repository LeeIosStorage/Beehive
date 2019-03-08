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

@property (nonatomic, strong) HXPhotoView *photoView;
@property (nonatomic, strong) HXPhotoManager *photoManager;
@property (nonatomic, strong) HXDatePhotoToolManager *toolManager;


@end

@implementation LLPublishImageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.labTitle.mas_bottom);
        make.bottom.equalTo(self.contentView).offset(-30);
        make.height.mas_equalTo(65);
    }];
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

#pragma mark - SetGet
- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
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

- (HXPhotoView *)photoView{
    if (!_photoView) {
        _photoView = [HXPhotoView photoManager:self.photoManager];
        _photoView.delegate = self;
        _photoView.outerCamera = YES;
        _photoView.previewShowDeleteButton = YES;
        _photoView.showAddCell = YES;
        _photoView.editEnabled = NO;
        _photoView.spacing = 5;
        int lineCount = (SCREEN_WIDTH-10*2)/(65+5);
        _photoView.lineCount = lineCount;
        [_photoView.collectionView reloadData];
    }
    return _photoView;
}

#pragma mark -
#pragma mark - HXPhotoViewDelegate

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    LLPublishCellNode *cellNode = (LLPublishCellNode *)self.node;
    cellNode.uploadImageDatas = [NSMutableArray array];
    
    if (self.cellUpdateHeightBlock) {
        self.cellUpdateHeightBlock();
    }
//    WEAKSELF
    if (photos.count > 0) {
        // 获取图片
        [self.toolManager getSelectedImageList:allList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
            [imageList enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imageData = UIImageJPEGRepresentation(obj, WY_IMAGE_COMPRESSION_QUALITY);
                [cellNode.uploadImageDatas addObject:imageData];
                if (idx == imageList.count - 1) {
                    
                }
            }];
        } failed:^{
            
        }];
    }
}

- (void)photoView:(HXPhotoView *)photoView imageChangeComplete:(NSArray<UIImage *> *)imageList {
    NSSLog(@"imageList: %@",imageList);
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    
    //    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + 106 + 50 + kPhotoViewMargin*2 + 140);
    //    [self updateViewConstraints];
    LELog(@"高度更新了！！！！！！");
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetHeight(frame));
    }];
}

- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index {
    NSSLog(@"%@ --> index - %ld",model,index);
}

- (BOOL)photoViewShouldDeleteCurrentMoveItem:(HXPhotoView *)photoView {
    return NO;
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
