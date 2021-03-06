//
//  LEShareSheetView.m
//  XWAPP
//
//  Created by hys on 2018/5/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEShareSheetView.h"
#import "LEShareWindow.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "WYShareManager.h"
#import "SDImageCache.h"
#import "WYNetWorkManager.h"

@interface LEShareSheetView ()
<
LEShareWindowDelegate
>
{
}

@property (strong, nonatomic) WYNetWorkManager *networkManager;

@property (strong, nonatomic) LEShareWindow *shareSheet;

@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareDescription;
@property (nonatomic, strong) NSString *shareWebpageUrl;
@property (nonatomic, strong) UIImage *shareImage;

@end

@implementation LEShareSheetView

#pragma mark -
#pragma mark - Lifecycle
- (void)dealloc
{
//    LELog(@"%s",__func__);
    _owner = nil;
    _shareSheet = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark - Public
- (void)showShareAction{
    
    [self shareContent];
    
    self.shareSheet.delegate = self;
    [self.shareSheet setCustomerSheet];
    
}

- (void)shareContent{
//    if (self.newsModel) {
//        self.shareTitle = self.newsModel.title;
//        self.shareDescription = @"分享得乐币";
//        NSString *webUrl = [NSString stringWithFormat:@"%@/%@?userId=%@&token=%@&code=%@",[WYAPIGenerate sharedInstance].baseWebUrl,kAppSharePackageWebURLPath,[LELoginUserManager userID],[LELoginUserManager authToken],[LELoginUserManager invitationCode]];
//        self.shareWebpageUrl = webUrl;
//
//        NSString *imageUrl = NULL;
//        if (self.newsModel.cover.count > 0) {
//            imageUrl = [self.newsModel.cover objectAtIndex:0];
//        }
//        if (imageUrl) {
//            self.shareImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
//        }
//
//    }else
    if (self.shareModel){
        self.shareTitle = self.shareModel.shareTitle;
        self.shareDescription = self.shareModel.shareDescription;
        self.shareWebpageUrl = self.shareModel.shareWebpageUrl;
        self.shareImage = self.shareModel.shareImage;
    }
}

#pragma mark -
#pragma mark - Private
-(void)shareToWX:(int)scene{
    [[WYShareManager shareInstance] shareToWXWithScene:scene title:self.shareTitle description:self.shareDescription webpageUrl:self.shareWebpageUrl image:self.shareImage isVideo:_isVideo];
}

- (void)shareToWXTimeline{
    [self shareToWX:WXSceneTimeline];
}

- (void)shareToWXSession{
    [self shareToWX:WXSceneSession];
}

- (void)shareToQQ{
    
    [[WYShareManager shareInstance] shareToQQTitle:self.shareTitle description:self.shareDescription webpageUrl:self.shareWebpageUrl image:self.shareImage isVideo:_isVideo isQZone:NO];
}

- (void)shareToQZone{
    
    [[WYShareManager shareInstance] shareToQQTitle:self.shareTitle description:self.shareDescription webpageUrl:self.shareWebpageUrl image:self.shareImage isVideo:_isVideo isQZone:YES];
}

- (void)shareToWeibo{
    
    [[WYShareManager shareInstance] shareToWb:^(WBSendMessageToWeiboResponse *response) {
        
    } title:self.shareTitle description:self.shareDescription webpageUrl:self.shareWebpageUrl image:self.shareImage VC:_owner isVideo:_isVideo];
}

- (void)copylink{
    if (self.shareWebpageUrl.length == 0) {
        return;
    }
    UIPasteboard *copyBoard = [UIPasteboard generalPasteboard];
    copyBoard.string = self.shareWebpageUrl;
    [copyBoard setPersistent:YES];
    [SVProgressHUD showCustomSuccessWithStatus:@"复制成功"];
}

- (void)collectAction{
    if (self.owner && [self.owner respondsToSelector:@selector(shareSheetCollectAction)]) {
        [self.owner shareSheetCollectAction];
    }
}

- (void)reportAction{
    
    [SVProgressHUD showCustomWithStatus:nil];
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"NewsReport"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userId = [LELoginUserManager userID];
    if (!userId) {
        userId = @"";
    }
    [params setObject:userId forKey:@"userId"];
    [params setObject:@"" forKey:@"content"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:@"举报成功"];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma mark - Set And Getters
- (LEShareWindow *)shareSheet{
    if (!_shareSheet) {
        _shareSheet = [[LEShareWindow alloc] init];
        _shareSheet.delegate = self;
    }
    return _shareSheet;
}

- (WYNetWorkManager *)networkManager{
    if (!_networkManager) {
        _networkManager = [[WYNetWorkManager alloc] init];
    }
    return _networkManager;
}

#pragma mark -
#pragma mark - LEShareWindowDelegate
-(void)shareWindowClickAt:(NSIndexPath *)indexPath action:(NSString *)action{
    if (action) {
        SEL opAction = NSSelectorFromString(action);
        if ([self respondsToSelector:opAction]) {
            ((void(*)(id,SEL, id,id))objc_msgSend)(self, opAction, nil, nil);
        }
    }
}

@end
