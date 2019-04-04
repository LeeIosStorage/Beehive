//
//  LLBadgeNumberView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/4/4.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLBadgeNumberView.h"

@interface LLBadgeNumberView ()

@property (nonatomic, strong) UILabel *labNum;

@end

@implementation LLBadgeNumberView

- (void)setup {
    [super setup];
    self.hidden = true;
    self.backgroundColor = kAppThemeColor;
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = true;
    
    [self addSubview:self.labNum];
    [self.labNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.width.mas_greaterThanOrEqualTo(10);
    }];
}

- (void)setBadge:(int)number {
    if (number <= 0) {
        self.hidden = true;
        return;
    }
    self.hidden = false;
    self.labNum.text = [NSString stringWithFormat:@"%d",number];
}

- (UILabel *)labNum {
    if (!_labNum) {
        _labNum = [[UILabel alloc] init];
        _labNum.textColor = UIColor.whiteColor;
        _labNum.font = [FontConst PingFangSCRegularWithSize:8];
//        _labNum.minimumScaleFactor = 0.1;
        _labNum.textAlignment = NSTextAlignmentCenter;
    }
    return _labNum;
}

@end
