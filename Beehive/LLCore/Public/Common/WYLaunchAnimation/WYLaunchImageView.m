//
//  WYLaunchImageView.m
//  WangYu
//
//  Created by XuLei on 16/2/18.
//  Copyright © 2016年 KID. All rights reserved.
//

#import "WYLaunchImageView.h"

@interface WYLaunchImageView ()

@property (nonatomic, weak) UIImageView *adImageView;

@end

@implementation WYLaunchImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [self initWithFrame:frame]) {
        [self addAdImageView];
        [self addSingleTapGesture];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super initWithImage:image]) {
        [self addAdImageView];
        [self addSingleTapGesture];
    }
    return self;
}

- (void)addAdImageView {
    self.backgroundColor = UIColor.whiteColor;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = true;
    [self addSubview:imageView];
    _adImageView = imageView;
}

- (void)addSingleTapGesture {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGesture:)];
    [self addGestureRecognizer:singleTap];
}

#pragma mark - setter
- (void)setURLString:(NSString *)URLString {
    _URLString = URLString;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //异步操作
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];
        if (!data) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新
            _adImageView.alpha = 1.0;
            _adImageView.image = [UIImage imageWithData:data];
//            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                _adImageView.alpha = 1.0;
//            } completion:nil];
        });
    });
}

#pragma mark - action
- (void)singleTapGesture:(UITapGestureRecognizer *)recognizer {
    if (self.clickedImageURLHandle) {
        self.clickedImageURLHandle(self.URLString);
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hidden == NO && _adImageView.alpha > 0 && CGRectContainsPoint(_adImageView.frame, point)) {
        return self;
    }
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _adImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

@end
