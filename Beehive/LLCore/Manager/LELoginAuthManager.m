//
//  LELoginAuthManager.m
//  XWAPP
//
//  Created by hys on 2018/5/31.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LELoginAuthManager.h"
#import "WXApi.h"
#import "LELoginUserManager.h"

#define kIsInReviewVersionKey @"isInReviewVersionKey"

@interface LELoginAuthManager ()

@property (strong, nonatomic) WYNetWorkManager *netWorkManager;

@end

@implementation LELoginAuthManager

static LELoginAuthManager *_instance = nil;
+ (LELoginAuthManager *)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.taskList = [[NSMutableArray alloc] init];
        self.globalTaskConfig = [[NSDictionary alloc] init];
        self.allAreaList = [[NSMutableArray alloc] init];
        
        NSUserDefaults *originalDefaults = [NSUserDefaults standardUserDefaults];
        id object = [originalDefaults objectForKey:kIsInReviewVersionKey];
        self.isInReviewVersion = [object boolValue];
    }
    return self;
}

#pragma mark -
#pragma mark - 三方授权
- (void)socialAuthBinding:(UMSocialPlatformType)loginType presentingController:(UIViewController *)presentingController success:(LoginAuthBindingSuccessBlock)success{
    
    if (![WXApi isWXAppInstalled]) {
        [SVProgressHUD showCustomInfoWithStatus:@"请安装微信."];
        return;
    }
    WEAKSELF;
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:loginType currentViewController:presentingController completion:^(id result, NSError *error) {
        if (error) {
            
            NSString *message = @"授权失败";
            NSDictionary *info = nil;
            info = [NSDictionary dictionaryWithObject:message forKey:@"error"];
            [SVProgressHUD showCustomInfoWithStatus:message];
            if (success) {
                success(NO, nil);
            }
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            NSMutableDictionary *info = [NSMutableDictionary dictionary];
            if (resp.name) {
                [info setObject:resp.name forKey:@"username"];
            }
            if (resp.uid) {
                [info setObject:resp.uid forKey:@"openId"];
            }
            if (resp.accessToken) {
                [info setObject:resp.accessToken forKey:@"accessToken"];
            }
            if (resp.iconurl) {
                [info setObject:resp.iconurl forKey:@"avatar"];
            }
            if (resp.unionId) {
                [info setObject:resp.unionId forKey:@"unionId"];
            }
        
//            [LELoginUserManager setWxNickname:resp.name];
//
            if (success) {
                success(YES, info);
            }
//            [weakSelf saveUserInfoRequestWithWxNickname:resp.name success:success];
            
        }
    }];
}

#pragma mark -
#pragma mark - Request

- (void)saveUserInfoRequestWithWxNickname:(NSString *)wxNickname success:(LoginAuthBindingSuccessBlock)success{
    
    WEAKSELF;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"SaveUserDetail"];
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [jsonDic setObject:[LELoginUserManager userID] forKey:@"id"];
    [jsonDic setObject:[LELoginUserManager nickName]?[LELoginUserManager nickName]:@"" forKey:@"nickname"];
    [jsonDic setObject:[LELoginUserManager headImgUrl]?[LELoginUserManager headImgUrl]:@"" forKey:@"headimg"];
    [jsonDic setObject:[LELoginUserManager sex]?[LELoginUserManager sex]:@"1" forKey:@"sex"];
    [jsonDic setObject:[NSNumber numberWithInt:[[LELoginUserManager age] intValue]] forKey:@"age"];
    [jsonDic setObject:[LELoginUserManager occupation]?[LELoginUserManager occupation]:@"" forKey:@"occupation"];
    [jsonDic setObject:[LELoginUserManager education]?[LELoginUserManager education]:@"" forKey:@"education"];
    [jsonDic setObject:wxNickname?wxNickname:@"" forKey:@"wechat"];
    
    [self.netWorkManager POST:requestUrl needCache:NO caCheKey:nil parameters:jsonDic responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        [SVProgressHUD showCustomInfoWithStatus:@"设置成功"];
        [LELoginUserManager setWxNickname:wxNickname];
        if (success) {
            success(YES, nil);
        }
        
//        [weakSelf updateUserTaskStateRequestWith:@"2" success:^(BOOL success) {
//
//        }];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

- (void)refreshAllAreaList {
    WEAKSELF
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetAllAreaList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caCheKey = @"GetAllAreaList";
    [self.netWorkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:[LLAreaNode class] needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
//            [SVProgressHUD showCustomErrorWithStatus:message];
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *data = (NSArray *)dataObject;
            weakSelf.allAreaList = [NSMutableArray arrayWithArray:data];
        }
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

/*********
 
- (void)getGlobalTaskConfigRequestSuccess:(LoginAuthBindingSuccessBlock)success{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetGlobalTaskConfig"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [self.netWorkManager POST:requestUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        if ([dataObject isKindOfClass:[NSDictionary class]]) {
            WeakSelf.globalTaskConfig = dataObject;
        }
        if (success) {
            success(YES);
        }
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

- (void)updateUserTaskStateRequestWith:(NSString *)taskId success:(LoginAuthBindingSuccessBlock)success{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"UpdateUserTaskState"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    if (taskId) [params setObject:taskId forKey:@"taskId"];
    [params setObject:[NSNumber numberWithInteger:1] forKey:@"state"];
    
    [self.netWorkManager POST:requestUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            if (success) {
                success(NO);
            }
            return ;
        }
        
        if (success) {
            success(YES);
        }
        
        [WeakSelf refreshTaskInfoRequestSuccess:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
            
        } failure:^(id responseObject, NSError *error) {
            
        }];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

- (void)refreshTaskInfoRequestSuccess:(WYRequestSuccessBlock)success failure:(WYRequestFailureBlock)failure{
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetUserTask"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    
    [self.netWorkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        NSArray *array = [NSArray modelArrayWithClass:[LETaskListModel class] json:dataObject];
        [WeakSelf.taskList removeAllObjects];
        [WeakSelf.taskList addObjectsFromArray:array];
        
        if (success){
            success(requestType,message,NO,dataObject);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUITaskInfoNotificationKey object:dataObject];
        
    } failure:^(id responseObject, NSError *error) {
        failure(nil, error);
    }];
    
}

#pragma mark -
#pragma mark - Public
- (BOOL)taskCompletedWithTaskType:(LETaskCenterType)taskType{
    __block BOOL isCompleted = NO;
    [self.taskList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LETaskListModel class]]) {
            LETaskListModel *model = (LETaskListModel *)obj;
            if (model.taskType == taskType && model.taskStatus == 1) {
                isCompleted = YES;
                *stop = YES;
            }
        }
    }];
    return isCompleted;
}
- (BOOL)taskCompletedWithGreenHandTask{
    __block BOOL isCompleted = YES;
    [self.taskList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LETaskListModel class]]) {
            LETaskListModel *model = (LETaskListModel *)obj;
            if (model.type == 1 && model.taskStatus == 0) {
                isCompleted = NO;
                *stop = YES;
            }
        }
    }];
    return isCompleted;
}

- (LETaskListModel *)getTaskWithTaskType:(LETaskCenterType)taskType{
    
    __block LETaskListModel *taskModel = nil;
    [self.taskList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LETaskListModel class]]) {
            LETaskListModel *model = (LETaskListModel *)obj;
            if (model.taskType == taskType) {
                taskModel = model;
                *stop = YES;
            }
        }
    }];
    return taskModel;
    
}

- (void)checkUpdateWithAppID:(NSString *)appID{
    
    HitoWeakSelf;
    [self.netWorkManager checkUpdateWithAppID:appID success:^(NSDictionary *resultDic, BOOL isNewVersion, NSString *newVersion, NSString *currentVersion) {
        
        WeakSelf.isInReviewVersion = isNewVersion;
        
        NSUserDefaults *originalDefaults = [NSUserDefaults standardUserDefaults];
        [originalDefaults setObject:[NSNumber numberWithBool:isNewVersion] forKey:kIsInReviewVersionKey];
        [originalDefaults synchronize];
        
        [WeakSelf resetTabBarTitle];
        
    } failure:^(NSError *error) {
        WeakSelf.isInReviewVersion = YES;
    }];
}

- (void)resetTabBarTitle{
    if ([LELoginAuthManager sharedInstance].isInReviewVersion) {
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (window.windowLevel != UIWindowLevelNormal){
            NSArray *windows = [[UIApplication sharedApplication] windows];
            for(UIWindow * tmpWin in windows){
                if (tmpWin.windowLevel == UIWindowLevelNormal){
                    window = tmpWin;
                    break;
                }
            }
        }
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        if ([nextResponder isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarVc = (UITabBarController *)nextResponder;
            for (UITabBarItem *item in tabBarVc.tabBar.items) {
                if ([item.title isEqualToString:@"任务中心"]) {
                    item.title = @"发现";
                }
            }
        }
    }
}

- (void)userAttentionWithUserId:(NSString *)userId isAttention:(BOOL)isAttention result:(LERequestStatusBlock)result{
//    HitoWeakSelf;
    NSString *api = @"attention";
    if (!isAttention) {
        api = @"unAttention";
    }
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:api];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId.length > 0) [params setObject:userId forKey:@"userId"];
    [self.netWorkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            result(NO);
            return;
        }
        result(YES);
        
    } failure:^(id responseObject, NSError *error) {
        result(NO);
    }];
}
 ********/

#pragma mark -
#pragma mark - Set And Getters
- (WYNetWorkManager *)netWorkManager{
    if (!_netWorkManager) {
        _netWorkManager = [[WYNetWorkManager alloc] init];
    }
    return _netWorkManager;
}

@end
