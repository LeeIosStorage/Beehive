//
//  LLChooseLocationScopeView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/12.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLChooseLocationScopeView.h"

@interface LLChooseLocationScopeView ()

@property (nonatomic, weak) IBOutlet UIView *scopeView;

@end

@implementation LLChooseLocationScopeView

- (void)setup {
    [super setup];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    for (int i = 0 ; i < 7; i ++) {
        NSInteger index = i + 10;
        UIView *sup = [self viewWithTag:index];
        for (id obj in sup.subviews) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imgView = (UIImageView *)obj;
                imgView.highlighted = false;
                if (_currentIndex == i) {
                    imgView.highlighted = true;
                }
            }
        }
    }
}

- (IBAction)chooseCityAction:(id)sender {
    if (self.chooseCityBlock) {
        self.chooseCityBlock();
    }
}

- (IBAction)chooseScopeAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    UIView *supView = btn.superview;
    [self setCurrentIndex:supView.tag - 10];
    if (self.chooseScopeBlock) {
        self.chooseScopeBlock(_currentIndex);
    }
}

@end
