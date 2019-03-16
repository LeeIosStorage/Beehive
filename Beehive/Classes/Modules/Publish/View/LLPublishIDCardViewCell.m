//
//  LLPublishIDCardViewCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/9.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLPublishIDCardViewCell.h"
#import "LLPublishCellNode.h"
#import <HXPhotoPicker/HXPhotoPicker.h>

@interface LLPublishIDCardViewCell ()

@property (nonatomic, strong) HXPhotoManager *photoManager;
@property (nonatomic, strong) HXDatePhotoToolManager *toolManager;

@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@property (nonatomic, weak) IBOutlet UIButton *btn1;
@property (nonatomic, weak) IBOutlet UIButton *btn2;

@end

@implementation LLPublishIDCardViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)node {
    LLPublishCellNode *cellNode = (LLPublishCellNode *)node;
    self.node = cellNode;
    self.labTitle.text = cellNode.title;
    [self.btn1 setImage:[UIImage imageNamed:@"3_1_1.1"] forState:UIControlStateNormal];
    [self.btn2 setImage:[UIImage imageNamed:@"3_1_1.1"] forState:UIControlStateNormal];
    if (cellNode.uploadImageDatas.count > 0) {
        [self.btn1 setImage:cellNode.uploadImageDatas[0] forState:UIControlStateNormal];
    }
    if (cellNode.uploadImageDatas.count > 1) {
        [self.btn2 setImage:cellNode.uploadImageDatas[1] forState:UIControlStateNormal];
    }
    
    if (cellNode.cellType == LLPublishCellTypeADImage) {
        self.btn1.hidden = true;
        if (cellNode.uploadImageDatas.count > 0) {
            [self.btn2 setImage:cellNode.uploadImageDatas[0] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)btn1Action:(id)sender {
//    HXWeakSelf
    [self.viewController hx_presentAlbumListViewControllerWithManager:self.photoManager done:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
        
        LLPublishCellNode *cellNode = (LLPublishCellNode *)self.node;
        
        if (photoList.count > 0) {
            // 获取图片
            HXPhotoModel *first = photoList.firstObject;
            [self.btn1 setImage:first.thumbPhoto forState:UIControlStateNormal];
            [self.toolManager getSelectedImageList:photoList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
                [cellNode.uploadImageDatas insertObjects:imageList atIndex:0];
            } failed:^{

            }];
        }
        
    } cancel:^(HXAlbumListViewController *viewController) {
        NSSLog(@"block - 取消了");
    }];
}

- (IBAction)btn2Action:(id)sender {
    [self.viewController hx_presentAlbumListViewControllerWithManager:self.photoManager done:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
        
        LLPublishCellNode *cellNode = (LLPublishCellNode *)self.node;
        
        if (photoList.count > 0) {
            // 获取图片
            HXPhotoModel *first = photoList.firstObject;
            [self.btn2 setImage:first.thumbPhoto forState:UIControlStateNormal];
            [self.toolManager getSelectedImageList:photoList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
                if (cellNode.cellType == LLPublishCellTypeADImage) {
                    [cellNode.uploadImageDatas insertObjects:imageList atIndex:0];
                } else {
                    [cellNode.uploadImageDatas insertObjects:imageList atIndex:1];
                }
            } failed:^{
                
            }];
        }
        
    } cancel:^(HXAlbumListViewController *viewController) {
        NSSLog(@"block - 取消了");
    }];
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
        _photoManager.configuration.photoMaxNum = 1;
        _photoManager.configuration.videoMaxNum = 1;
        _photoManager.configuration.videoMaxDuration = 500.f;
        _photoManager.configuration.showDateSectionHeader = NO;
        _photoManager.configuration.selectTogether = NO;
//        _photoManager.configuration.photoCanEdit = NO;
        _photoManager.configuration.hideOriginalBtn = YES;
        _photoManager.configuration.reverseDate = YES;
    }
    return _photoManager;
}

@end
