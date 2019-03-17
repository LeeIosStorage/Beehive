//
//  WYCommonUtils.m
//  XWAPP
//
//  Created by hys on 2018/5/15.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "WYCommonUtils.h"
#import "UIImageView+WebCache.h"
#import "UIImage+LEAdd.h"
#import <AdSupport/AdSupport.h>
#import <JMRoundedCorner/UIView+RoundedCorner.h>
#import <CoreImage/CoreImage.h>

#define DAY_SECOND 60*60*24

@implementation WYCommonUtils

+ (float)widthWithText:(NSString *)text font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    float titleLabelWidth = [text sizeWithAttributes:attributes].width;
    return titleLabelWidth;
}

+ (CGSize)sizeWithAttributedText:(NSString *)text lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font width:(float)width{
    
    NSUInteger length = [text length];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    [attrString addAttributes:attributes range:NSMakeRange(0, length)];
    //NSStringDrawingUsesFontLeading 不需要这个属性
    CGSize textSize = [attrString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return textSize;
}

+ (NSAttributedString *)getAttributedStringWithString:(NSString*)string lineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment{
    NSUInteger length = [string length];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = lineSpacing;
    style.alignment = alignment;
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    return attrString;
}

#pragma mark -
#pragma mark - 富文本
+(NSMutableAttributedString *)stringToColorAndFontAttributeString:(NSString *)text range:(NSRange)range font:(UIFont *)font color:(UIColor *)color{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    if (color) {
        [attStr addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:range];
    }
    if (font) {
        [attStr addAttribute:NSFontAttributeName
                       value:font
                       range:range];
    }
    if (color && font) {
        NSDictionary *attributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:color};
        [attStr addAttributes:attributes range:range];
    }
    return attStr;
}

#pragma mark -
#pragma mark - Time
static NSDateFormatter *s_dateFormatterOFUS = nil;
static bool dateFormatterOFUSInvalid;
+ (NSDate *)dateFromUSDateString:(NSString *)string{
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    @synchronized(self){
        if (s_dateFormatterOFUS == nil || dateFormatterOFUSInvalid) {
            s_dateFormatterOFUS = [[NSDateFormatter alloc] init];
            [s_dateFormatterOFUS setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [s_dateFormatterOFUS setLocale:usLocale];
            dateFormatterOFUSInvalid = NO;
        }
    }
    
    NSDateFormatter *dateFormatter = s_dateFormatterOFUS;
    NSDate *date = nil;
    @synchronized(dateFormatter){
        @try{
            date = [dateFormatter dateFromString:string];
        }
        @catch (NSException *exception){
            dateFormatterOFUSInvalid = YES;
        }
    }
    return date;
}

+ (NSString *)dateDiscriptionFromNowBk:(NSDate *)date{
    NSString *timestamp = nil;
    NSDate *nowDate = [NSDate date];
    if (date == nil) {
        return @"";
    }
    int distance = [nowDate timeIntervalSinceDate:date];
    if (distance < 0) {
        distance = 0;
    }
    NSCalendar *calender = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    NSDateComponents *compsNow = [calender components:unitFlags fromDate:nowDate];
    
//    NSDateComponents *tempComps = [calender components:unitFlags fromDate:nowDate toDate:date options:NSCalendarWrapComponents];
    
    if (distance > 0) {
        if (distance < 60) {
            timestamp = [NSString stringWithFormat:@"刚刚"];
        }else if (distance < 60*60) {
            timestamp = [NSString stringWithFormat:@"%d%@",distance/60,@"分钟前"];
        }else if (distance < DAY_SECOND){
            timestamp = [NSString stringWithFormat:@"%d%@",distance/(60*60),@"小时前"];
        }else if (distance < DAY_SECOND*9){
            timestamp = [NSString stringWithFormat:@"%d%@",distance/(DAY_SECOND),@"天前"];
        }else{
            if (comps.year == compsNow.year) {
                timestamp = [NSString stringWithFormat:@"%d月%d日", (int)comps.month, (int)comps.day];
            }else{
                timestamp = [NSString stringWithFormat:@"%04d.%02d.%02d %02d:%02d", (int)comps.year, (int)comps.month, (int)comps.day, (int)comps.hour, (int)comps.minute];
            }
        }
    }else{
        timestamp = [NSString stringWithFormat:@"%04d.%02d.%02d %02d:%02d", (int)comps.year, (int)comps.month, (int)comps.day, (int)comps.hour, (int)comps.minute];
    }
    
    return timestamp;
}

+ (NSString*)dateDiscriptionFromDate:(NSDate*)date{
    NSString *_timestamp = nil;
    NSDate* nowDate = [NSDate date];
    if (date == nil) {
        return @"";
    }
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    NSDateComponents *compsNow = [calender components:unitFlags fromDate:nowDate];
    
    if (comps.year == compsNow.year){
        _timestamp = [NSString stringWithFormat:@"%02d/%02d %02d:%02d", (int)comps.month, (int)comps.day, (int)comps.hour, (int)comps.minute];
    } else {
        _timestamp = [NSString stringWithFormat:@"%04d/%02d/%02d %02d:%02d", (int)comps.year, (int)comps.month, (int)comps.day, (int)comps.hour, (int)comps.minute];
    }
    
    return _timestamp;
}

+ (NSString*)dateYearToDayDiscriptionFromDate:(NSDate*)date{
    NSString *_timestamp = nil;
    if (date == nil) {
        return @"";
    }
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    
    _timestamp = [NSString stringWithFormat:@"%04d-%02d-%02d", (int)comps.year, (int)comps.month, (int)comps.day];
    
    return _timestamp;
}

+ (NSString*)dateYearToSecondDiscriptionFromDate:(NSDate*)date{
    NSString *_timestamp = nil;
    if (date == nil) {
        return @"";
    }
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    
    _timestamp = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d", (int)comps.year, (int)comps.month, (int)comps.day, (int)comps.hour, (int)comps.minute,(int)comps.second];
    
    return _timestamp;
}

+ (NSString*)dateHourToMinuteDiscriptionFromDate:(NSDate*)date{
    
    NSString *_timestamp = nil;
    if (date == nil) {
        return @"";
    }
    NSCalendar * calender = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    
    _timestamp = [NSString stringWithFormat:@"%02d:%02d", (int)comps.hour, (int)comps.minute];
    
    return _timestamp;
    
}

+ (NSString*)dateDayToDayDiscriptionFromDate:(NSDate*)date{
    
    NSString *timestamp = nil;
    NSDate *nowDate = [NSDate date];
    if (date == nil) {
        return @"";
    }
    int distance = [nowDate timeIntervalSinceDate:date];
    if (distance < 0) {
        distance = 0;
    }
    NSCalendar *calender = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    NSDateComponents *compsNow = [calender components:unitFlags fromDate:nowDate];
    
    if (distance > 0) {
        if (distance < DAY_SECOND) {
            if (comps.day == compsNow.day){
                timestamp = @"今天";
            }else timestamp = @"昨天";
            
        }else{
            timestamp = [NSString stringWithFormat:@"%d月%d日", (int)comps.month, (int)comps.day];
        }
    }else{
        timestamp = [NSString stringWithFormat:@"%d月%d日", (int)comps.month, (int)comps.day];
    }
    
    return timestamp;
}

+ (int)getAgeWithBirthdayDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *birth = [dateFormatter stringFromDate:date];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    
    //当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSLog(@"currentDate %@ birthDay %@",currentDateStr,birth);
    NSTimeInterval time = [currentDate timeIntervalSinceDate:birthDay];
    int age = ((int)time)/(3600*24*365);
    NSLog(@"year %d",age);
    return age;
}

+ (NSString *)secondChangToDateString:(NSString *)dateStr {
    
    if (dateStr.length == 0) {
        return @"";
    }
    
    long long time = [dateStr longLongValue];
    int hour = (int)time/(60*60);
    int minute = (time/60)%60;
    int second = time%60;
    
    NSString *ts = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute,second];
    return ts;
}

+(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime{
    
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    long long totalMilliseconds = interval*1000;
    return totalMilliseconds;
    
}

#pragma mark -
#pragma mark - Other
+ (void)setImageWithURL:(NSURL *)url setImage:(UIImageView *)imageView setbitmapImage:(UIImage *)bitmapImage{
    imageView.backgroundColor = kAppLoadingPlaceholderImageColor;
    
    if (![url isEqual:[NSNull null]]) {
        
        __block BOOL isBig = NO;
        [imageView sd_setImageWithURL:url placeholderImage:bitmapImage options:SDWebImageRetryFailed  progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
            if(expectedSize / 1024 > 400) {
                //如果图片过大,处理一下
                isBig = YES;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!isBig) {
                if (image && cacheType == SDImageCacheTypeNone) {
                    imageView.alpha = 0.0;
                    [UIView transitionWithView:imageView
                                      duration:1.0
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                                        [imageView setImage:image];
                                        imageView.alpha = 1.0;
                                    } completion:NULL];
                }
            } else {
                imageView.alpha = 0.0;
                [UIView transitionWithView:imageView
                                  duration:1.0
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    if(image.images.count >= 2) {
                                        [imageView setImage:image];
                                    } else {
                                        //UIImage *image = [self ima];
                                        [imageView setImage:[image imageCompressForTargetSize:imageView.size]];
                                    }
                                    
                                    imageView.alpha = 1.0;
                                } completion:NULL];
                
            }
        }];
    }else{
        [imageView sd_setImageWithURL:nil];
        [imageView setImage:bitmapImage];
    }
}

+ (void)setImageWithURL:(NSURL *)url setImageView:(UIImageView *)imageView setbitmapImage:(UIImage *)bitmapImage radius:(CGFloat)radius{
    
    if (bitmapImage) {
        bitmapImage = [bitmapImage jm_imageWithRoundedCornersAndSize:CGSizeMake(radius*2, radius*2) andCornerRadius:radius];;
    }
    if (!url || [url isEqual:[NSNull null]]) {
        [imageView setImage:bitmapImage];
    }
    
    __weak UIImageView *weakImageView = imageView;
    [imageView setImageWithURL:url placeholder:bitmapImage options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image) {
            [weakImageView jm_setCornerRadius:25 withImage:image];
        }else{
            [weakImageView setImage:bitmapImage];
        }
    }];
}

+(NSDictionary *)getParamDictFromUrl:(NSURL *)url{
    
    NSURLComponents* urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    
    NSMutableDictionary<NSString *, NSString *>* queryParams = [NSMutableDictionary<NSString *, NSString *> new];
    for (NSURLQueryItem* queryItem in [urlComponents queryItems])
    {
        if (queryItem.value == nil)
        {
            continue;
        }
        [queryParams setObject:queryItem.value forKey:queryItem.name];
    }
    return queryParams;
}

+(NSString *)numberFormatWithNum:(int)num{
    NSString *numStr = [NSString stringWithFormat:@"%d",num];
    if (num > 0) {
        if (num >= 10000) {
            float f = num/10000.0;
            numStr = [NSString stringWithFormat:@"%.1f万",f];
        }
    }
    return numStr;
}

#pragma mark -
#pragma mark - 动画
//👍
+ (void)popOutsideWithDuration:(NSTimeInterval)duration view:(UIView *)view{
    
    view.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            view.transform = CGAffineTransformMakeScale(1.7f, 1.7f); // 放大
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            view.transform = CGAffineTransformMakeScale(0.8f, 0.8f); // 放小
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            view.transform = CGAffineTransformMakeScale(1.0f, 1.0f); //恢复原样
        }];
    } completion:nil];
}

+ (void)popInsideWithDuration:(NSTimeInterval)duration view:(UIView *)view{
    
    view.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 2.0 animations: ^{
            view.transform = CGAffineTransformMakeScale(0.7f, 0.7f); // 放小
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations: ^{
            view.transform = CGAffineTransformMakeScale(1.0f, 1.0f); //恢复原样
        }];
    } completion:nil];
}

+ (void)addShadowWithView:(UIView *)view mode:(NSInteger)mode size:(CGSize)size{
    
    UIColor *colorOne = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:0.7];
    UIColor *colorTwo = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    if (mode == 0) {
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(0, 1);
    }else if (mode == 1){
        gradient.startPoint = CGPointMake(0, 1);
        gradient.endPoint = CGPointMake(0, 0);
//        colors = [NSArray arrayWithObjects:(id)colorTwo.CGColor, colorOne.CGColor, nil];
    }
    gradient.colors = colors;
    gradient.frame = CGRectMake(0, 0, size.width, size.height);
    [view.layer insertSublayer:gradient atIndex:0];
}

#pragma mark - string 比较
+ (BOOL)isEqualWithUserId:(NSString *)uid{
    if ([[uid description] isEqualToString:[[LELoginUserManager userID] description]]) {
        return YES;
    }
    return NO;
}

#pragma mark - 设备标识
+ (NSString *)UUIDString{
    
//    if (![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
//        return nil;
//    }
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return advertisingId;
}

#pragma mark - common
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
        NSInteger index = ((UITabBarController *)nextResponder).selectedIndex;
        UINavigationController *nav = [(UITabBarController *)nextResponder viewControllers][index];
        nextResponder = [nav.viewControllers lastObject];
    }
    result = nextResponder;
    
    return result;
}

+ (UIImage *)getHDQRImgWithString:(NSString *)str size:(CGSize)size {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    //将所需尽心转为UTF8的数据，并设置给filter
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    /*
     * L: 7%
     * M: 15%
     * Q: 25%
     * H: 30%
     */
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    //拿到二维码图片，此时的图片不是很清晰，需要二次加工
    CIImage *outPutImage = [filter outputImage];
    if (size.width == 0 || size.height == 0) {
        size.width = 200;
        size.height = 200;
    }
    return [WYCommonUtils getHDImgWithCIImage:outPutImage size:size];
}

/**
 调整二维码清晰度
 
 @param img 模糊的二维码图片
 @param size 二维码的宽高
 @return 清晰的二维码图片
 */
+ (UIImage *)getHDImgWithCIImage:(CIImage *)img size:(CGSize)size {
    
    //二维码的颜色
    UIColor *pointColor = [UIColor blackColor];
    //背景颜色
    UIColor *backgroundColor = [UIColor whiteColor];
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage", img,
                             @"inputColor0", [CIColor colorWithCGColor:pointColor.CGColor],
                             @"inputColor1", [CIColor colorWithCGColor:backgroundColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

+ (UIImage *)cutImageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, true, UIScreen.mainScreen.scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotImage;
}

+ (void)callTelephone:(NSString *)phone {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]] options:@{} completionHandler:nil];
}

@end
