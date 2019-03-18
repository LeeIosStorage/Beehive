//
//  LLUploadAdViewController.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/15.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLUploadAdType) {
    LLUploadAdTypeNone,    //租赁
    LLUploadAdTypeLaunch,  //启动广告
    LLUploadAdTypeHome,    //首页广告
    LLUploadAdTypePopup,  //首页弹出广告
};

@interface LLUploadAdViewController : LLBaseViewController

@property (nonatomic, assign) LLUploadAdType vcType;

@end

NS_ASSUME_NONNULL_END
