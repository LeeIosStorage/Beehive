//
//  LLMapAddressSearchTitleView.m
//  Beehive
//
//  Created by yilunzheluo on 2019/3/11.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLMapAddressSearchTitleView.h"

@implementation LLMapAddressSearchTitleView

- (void)setup {
    [super setup];
    self.textField.delegate = self;
}

- (IBAction)chooseCityAction:(id)sender {
    if (self.chooseCityBlock) {
        self.chooseCityBlock();
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        return false;
    }
    //    if (!string.length && range.length > 0) {
    //        return true;
    //    }
    NSString *oldString = [textField.text copy];
    NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
    if (self.searchTextBlock) {
        self.searchTextBlock(newString);
    }
    return true;
}

@end
