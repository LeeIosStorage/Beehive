//
//  LLUploadAdViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"
#import "LLAdvertNode.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLUploadAdType) {
    LLUploadAdTypeNone,    //租赁
    LLUploadAdTypeEdit,    //编辑
    LLUploadAdTypeLaunch,  //启动广告
    LLUploadAdTypeHome,    //首页广告
    LLUploadAdTypePopup,  //首页弹出广告
};

typedef void(^LLUploadAdVcSuccessBlock)(void);

@interface LLUploadAdViewController : LLBaseViewController

@property (nonatomic, assign) LLUploadAdType vcType;

@property (nonatomic, strong) LLUploadAdVcSuccessBlock successBlock;

@property (nonatomic, strong) LLAdvertNode *advertNode;

@end

NS_ASSUME_NONNULL_END
