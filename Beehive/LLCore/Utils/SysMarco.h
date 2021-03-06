//
//  SysMarco.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#ifndef SysMarco_h
#define SysMarco_h

#define Itunes_APPID   @"1404835477"

#define QQ_ID                       @"101569296"
#define QQ_Key                      @"c7e2a20c7b5c8bcb2f0e78d8b0a677db"
#define WX_ID                       @"wxe0de70ea4dbdbcc9"
#define WX_Secret                   @"b5983b99ec2361568c83ad5eddd1f45a"
#define SINA_ID                     @"2752056969"
#define SINA_Secret                 @"3a1c7b67d5bd8265605a0e773358afa7"
#define Sina_RedirectURL            @"https://api.weibo.com/oauth2/default.html"

#define UMS_APPKEY                  @"5c94804f61f564e0360019b3"

#define JPUSH_APPKEY                @"4cf4260806b72b07ac84edbf"
#define JPUSH_CHANNLE               @"Apple Store"
#ifdef  DEBUG
#define APS_FOR_PRODUCTION 0
#else
#define APS_FOR_PRODUCTION 1
#endif

//Bugly
#define kBuglyAppID  @"e26d4b0928"
#define kGrowingIOAppID  @"8f00a97b58a86872"

//高德地图key
#define AMapKey @"11c9b34acc16cd7a3aed4e4d0bf556d8"

//支付宝
#define AliPay_PID                      @"2088431858827233"
#define AliPay_APPID                    @"2019032563702101"
#define AliPay_Seller                   @"nishizxf@126.com"
#define AliPay_PublicKey                @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnfq4+tKBampmCSzWmcEf0AZQEebkyx/Z20IcZejLph/xY2sFmMq5ZRxa9tyGO/7phjZo9WXwZ0tV2+GJRXjuERf2WufzA7QtzPeuvONvL5Y3LcsV4uSUYAsVTnLSOmH/sVLxy6xp16B6TWkDsmz1tedQLyeSbT0PsfqB/4TGdCx7gSfojL97c4wkSCZNGeF7qoy7MZqDZoHKCdHXHcq1oPxx4PINnXdVgs80rS1j6SY1V9thGJuHAHlFBdORxAw7BrhBzso+SxBnsup3XLvzzgvJwJP/Xjn2N/qzUsQ1cAKgTaDo8QgDeAv+Nsn9pbx0zJ3iSglx1fRZ2T5VJ4/TxwIDAQAB"
#define AliPay_PrivateKey @"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCd+rj60oFqamYJLNaZwR/QBlAR5uTLH9nbQhxl6MumH/FjawWYyrllHFr23IY7/umGNmj1ZfBnS1Xb4YlFeO4RF/Za5/MDtC3M9668428vljctyxXi5JRgCxVOctI6Yf+xUvHLrGnXoHpNaQOybPW151AvJ5JtPQ+x+oH/hMZ0LHuBJ+iMv3tzjCRIJk0Z4XuqjLsxmoNmgcoJ0dcdyrWg/HHg8g2dd1WCzzStLWPpJjVX22EYm4cAeUUF05HEDDsGuEHOyj5LEGey6ndcu/POC8nAk/9eOfY3+rNSxDVwAqBNoOjxCAN4C/42yf2lvHTMneJKCXHV9FnZPlUnj9PHAgMBAAECggEAcT/cPYqMVcICdY9cJArLCHCOE9dGqsqhfUmuW+v/mY6Kl++PqpGhR/eEyjUaUYYS2DDHGyxBo3rhCOhsZI4lc8GOzGo8zqnqr2XbMPOFsEJqOfy9KtMb/qHTW1J6nHnGN9MzHQPzOC2Fn1qp2M29cvJoi/U9RewhBUCE0qzXK03bp+YPdyZyKDFW/OTMRjZNmh6I9OLcMoUwgA4XI9LZjy13cwNMunC4sLM3lQz5nep2jRoeBCPdqWM2WJKs13bqOypAueLDAo4jJGtHiwEq19FJHBCY/hQep0fu8OFag3UfU8GEEkQl6Zr/+d8vBgOwRLLH6oFjqcCRsdyE8LgQSQKBgQDOmKcjIqNaBJSdUASOfr/sVy6KDhQNpqVs7nLL/ZtpL0/pln9XPtxxOWcEeBB5YGQrEFSEyJtTo5zyWs8cJgakxor9siYizxFuNsSuBMEZ9orQ81j5OTU62KbncHF6/hsNE3P9C+1REnkHflh9LsukBxOBxprla/hT0jOg7LXp5QKBgQDDwdrPAlFOSqx851bRJ4QqizxkLWfBG3IXbdgiwjB6nQVMfwbntNEdOJ58daBPWjev7R/CW4J+NuSCP/5HK0y26sWWm/GSMd3pXoN6HQ5Mnq+uY1jTB3ksXcg1OE0vPBCc32a4Vmu00qtRUmeA4hNEoFyV6ugp/6a0uHBL5Xh8OwKBgCgq2eQk6emollR3qEskLaB/2taQoil9SxCA0+UBa+PphPn/fsaxvB5vcK4Xwew3Z4JP7H7cmgaK+wrLyRTJ9+S1jXSB3JRL+jGZiGflGL45hwfVKGlcTBMi6GB7JjUpjozeSWDbnspycwGX+RBttr4vegVzXc5ZTbDOX6dcHopZAoGAPawKKmOZh+fgta0QXe5sJhcdnJXtdRoXdKgnirPRIB/t9m6il0cRBnq6+4z3R2it2KAE/G9mCitzDFHq4zMSBSKrw0o37g4F0qrzEvqqcZsgz/j+l+Vn2IFnPNUTBAmRVkrPis23Ow2P6Zvjfeg7l8hJwvVx1SF0vMTKpC6UKdcCgYEApsBCiBsGeDt/zj3iOaNfvx8m/el2kPvqr3lZ9T97BrueyBtjQAhId4DtytcT7k1njyrPVH6iY0skMOk0w+nrP6ngK5GQ6UThAHltPOOtRhIcQNGYR1QPPKTNwK+cMm3BtQTKPqe73OpJw0w2aqKklmjdKnU0WIxn46UKM6zYgEI="

#define MAX_WX_IMAGE_SIZE 32*1024
#define WY_IMAGE_COMPRESSION_QUALITY 0.4

// 每页加载数
#define DATA_LOAD_PAGESIZE_COUNT 20
//评论最大数
#define COMMENT_MAX_COUNT 255

#define kRefreshUILoginNotificationKey @"kRefreshUILoginNotificationKey"
#define kRefreshUITaskInfoNotificationKey @"kRefreshUITaskInfoNotificationKey"
#define kMonitorNetworkingNotificationKey @"kMonitorNetworkingNotificationKey"

#pragma mark -
#pragma mark - UM事件统计
#define kNewsRealHotClick                        @"NewsRealHotClick"
#define kHomeSearchBarClick                      @"HomeSearchBarClick"
#define kHomeNewsChannelClick                    @"HomeNewsChannelClick"
#define kHomeVideoChannelClick                   @"kHomeVideoChannelClick"
#define kTaskCenterSignInClick                   @"TaskCenterSignInClick"
#define kTaskCenterOpenBoxClick                  @"TaskCenterOpenBoxClick"
#define kTaskCenterBingWXClick                   @"TaskCenterBingWXClick"
#define kTaskCenterInvitationRecruitClick        @"TaskCenterInvitationRecruitClick"
#define kMessageCenterClick                      @"MessageCenterClick"
#define kMineGoldClick                           @"MineGoldClick"
#define kMineBalanceClick                        @"MineBalanceClick"
#define kMineEarningRankClick                    @"MineEarningRankClick"

#pragma mark -
#pragma mark - Other
/***************************系统版本*****************************/

//获取手机系统的版本

#define HitoSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

//是否为iOS7及以上系统
#define HitoiOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

//是否为iOS8及以上系统
#define HitoiOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

//是否为iOS9及以上系统
#define HitoiOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)

//是否为iOS10及以上系统
#define HitoiOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

//是否为iOS11及以上系统
#define HitoiOS11 ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)



/***************************沙盒路径*****************************/

//沙盒路径
#define HitoHomePath NSHomeDirectory()

//获取沙盒 Document
#define HitoPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 Cache
#define HitoPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 temp
#define HitoPathTemp NSTemporaryDirectory()

/***************************打印日志*****************************/
//输出语句
#ifdef DEBUG
#   define LELog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else

#   define LELog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

//#ifdef DEBUG
//#define NSLog(fmt, ...) [ObjcLog logWithFile:__FILE__ function:__FUNCTION__ line:__LINE__ color:[UIColor whiteColor] unicodeToChinese:NO message:(fmt), ##__VA_ARGS__]
//#else
//#define NSLog(fmt, ...) nil
//#endif

/***************************系统高度*****************************/

//屏幕的宽高
#define SCREEN_WIDTH (CGRectGetWidth([UIScreen mainScreen].bounds))
#define SCREEN_HEIGHT (CGRectGetHeight([UIScreen mainScreen].bounds))

//比例宽和高(以6s为除数)
#define HitoActureHeight(height)  roundf(height/375.0 * SCREEN_WIDTH)
#define HitoActureWidth(Width)  roundf(Width/667.0 * SCREEN_HEIGHT)

//状态栏的高度
#define HitoStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

//导航栏的高度
#define HitoNavBarHeight 44.0

//iphoneX-SafeArea的高度
#define HitoSafeAreaHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

//分栏+iphoneX-SafeArea的高度
#define HitoTabBarHeight (49+HitoSafeAreaHeight)

//导航栏+状态栏的高度
#define HitoTopHeight (HitoStatusBarHeight + HitoNavBarHeight)


/***************************视图,类初始化*****************************/

//property属性快速声明

#define HitoPropertyString(s)      @property(nonatomic,copy)NSString * s

#define HitoPropertyNSInteger(s)   @property(nonatomic,assign)NSInteger s

#define HitoPropertyFloat(s)       @property(nonatomic,assign)float s

#define HitoPropertyLongLong(s)    @property(nonatomic,assign)long long s

#define HitoPropertyNSDictionary(s)@property(nonatomic,strong)NSDictionary * s

#define HitoPropertyNSArray(s)     @property(nonatomic,strong)NSArray * s

#define HitoPropertyNSMutableArray(s)    @property(nonatomic,strong)NSMutableArray * s


//获取视图宽高XY等信息
#define HitoviewH(view1) view1.frame.size.height

#define HitoviewW(view1) view1.frame.size.width

#define HitoviewX(view1) view1.frame.origin.x

#define HitoviewY(view1) view1.frame.origin.y

//获取self.view的宽高
#define HitoSelfViewW (self.view.frame.size.width)

#define HitoSelfViewH (self.view.frame.size.height)

///实例化
#define HitoViewAlloc(view,x,y,w,h) [[view alloc]initWithFrame:CGRectMake(x, y, w, h)]

#define HitoAllocInit(Controller,cName) Controller *cName = [[Controller alloc]init]





/***************************图片,颜色,字号*****************************/

//默认图片
#define HitoPlaceholderImage [UIImage imageNamed:@"XXX"]
//定义UIImage对象
#define HitoImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//基本颜色

#define HitoClearColor [UIColor clearColor]

#define HitoWhiteColor [UIColor whiteColor]

#define HitoBlackColor [UIColor blackColor]

#define HitoGrayColor [UIColor grayColor]

#define HitoGray2Color [UIColor lightGrayColor]

#define HitoBlueColor [UIColor blueColor]

#define HitoRedColor [UIColor redColor]

//主题颜色
#define kAppThemeColor [UIColor colorWithHexString:@"FFAF02"]
//主背景颜色
#define kAppBackgroundColor [UIColor colorWithHexString:@"FFFFFF"]//f1f1f1
//区部颜色
#define kAppSectionBackgroundColor [UIColor colorWithHexString:@"F5F5F5"]
//标注背景色
#define kAppMaskBackgroundColor [UIColor colorWithHexString:@"F6F6F6"]
//主标题颜色
#define kAppTitleColor [UIColor colorWithHexString:@"333333"] //font 13
//副标题颜色
#define kAppSubTitleColor [UIColor colorWithHexString:@"666666"] //font 12
//二级副标题
#define kAppLightTitleColor [UIColor colorWithHexString:@"aaaaaa"] //font 11

//蒙层黑色
#define kAppMaskOpaqueBlackColor HitoRGBA(0,0,0,0.4)

//图片预加载默认背景色
#define kAppLoadingPlaceholderImageColor [UIColor colorWithHexString:@"bfbfbf"]

///颜色 a代表透明度,1为不透明,0为透明
#define HitoRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

// rgb颜色转换（16进制->10进制）
#define HitoColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//分割线颜色
#define LineColor [UIColor colorWithHexString:@"E1E1E1"]//[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:0.7]

//加粗
#define HitoBoldSystemFontOfSize(FONTSIZE) [UIFont boldSystemFontOfSize:FONTSIZE]

//字号
#define HitoSystemFontOfSize(FONTSIZE) [UIFont systemFontOfSize:FONTSIZE]

#define HitoPFSCRegularOfSize(FONTSIZE) [UIFont fontWithName:@"PingFangSC-Regular" size:FONTSIZE]

#define HitoPFSCMediumOfSize(FONTSIZE) [UIFont fontWithName:@"PingFangSC-Medium" size:FONTSIZE]

#define HitoPFSCLightOfSize(FONTSIZE) [UIFont fontWithName:@"PingFangSC-Light" size:FONTSIZE]

#define HitoPFSCThinOfSize(FONTSIZE) [UIFont fontWithName:@"PingFangSC-Thin" size:FONTSIZE]


/***************************通知和本地存储*****************************/

//创建通知

#define HitoAddNotification(selectorName,key) [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectorName) name:key object:nil];

//发送通知

#define HitoSendNotification(key) [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];

//移除通知

#define HitoRemoveNotification(key) [[NSNotificationCenter defaultCenter]removeObserver:self name:key object:nil];

//本地化存储

//#define HitoUserDefaults(NSUserDefaults,defu) NSUserDefaults * defu = [NSUserDefaults standardUserDefaults];

#define HitoUserDefaults(value, key)  [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];



/***************************其他*****************************/

//主窗口

#define HitoApplication [UIApplication sharedApplication].keyWindow

//字符串拼接

#define HitoStringWithFormat(format,...)[NSString stringWithFormat:format,##__VA_ARGS__]

//GCD代码只执行一次
#define HitoDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

//弱引用
#define WEAKSELF  __weak __typeof(&*self)weakSelf = self;

#define STRONGSELF  __strong __typeof(&*weakSelf)strongSelf = weakSelf;

//成功标识
#define HitoSuccess @"success"

//失败标识
#define HitoFailure @"failure"

//loading
#define HitoRequestLoadingTitle @"请求中..."

//登录状态标识
#define HitoLoginSucTitle @"登录成功"
#define HitoLoginFaiTitle @"登录失败"

//网络状态标识
#define HitoFaiRequest @"请求失败"
#define HitoFaiNetwork @"网络不给力"

#define HitoDataFileCatalog @"LEData"

#define kLLH5_DownLoad_Html_Url @"downLoad.html"

#define kLLAppTestHttpURL @"http://img.bimg.126.net/photo/31kQlCGP44-34Q5yxvoqmw==/5770237022569104952.jpg"

#endif /* SysMarco_h */
