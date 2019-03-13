//
//  LLCellOriginalContentView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/13.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLCellOriginalContentView.h"

@interface LLCellOriginalContentView ()

@property (nonatomic, strong) LLCellOriginalContentView *customView;

@end

@implementation LLCellOriginalContentView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        _customView = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        _customView.backgroundColor = self.backgroundColor;
        [self addSubview:_customView];
        [_customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setup {
    [super setup];
    self.backgroundColor = kAppSectionBackgroundColor;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = LineColor.CGColor;
}

@end
