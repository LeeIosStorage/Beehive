//
//  LLHomeNoticeCell.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/26.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLHomeNoticeCell.h"

@implementation LLHomeNoticeCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.imgIcon];
    self.imgIcon.left = 10;
    self.imgIcon.top = 14;
    self.imgIcon.size = CGSizeMake(15, 15);
//    self.imgIcon.frame = CGRectMake(10, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(15, 15));
//    }];
//
    [self addSubview:self.labTitle];
    self.labTitle.left = self.imgIcon.right + 8;
    self.labTitle.width = SCREEN_WIDTH - 110;
    self.labTitle.height = 20;
    self.labTitle.centerY = self.imgIcon.centerY;
    
//    self.labTitle.frame = CGRectMake(10, 12, 300, 20);
//    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.imgIcon.mas_right).offset(8);
//        make.centerY.equalTo(self);
//        make.right.equalTo(self).offset(-10);
//    }];
}

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
        _imgIcon.image = [UIImage imageNamed:@"1_0_1.10"];
    }
    return _imgIcon;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.textColor = kAppTitleColor;
        _labTitle.font = [FontConst PingFangSCRegularWithSize:13];
    }
    return _labTitle;
}

@end
