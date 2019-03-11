//
//  LLMapAddressSearchTitleView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/11.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLMapAddressSearchChooseCityBlock) (void);
typedef void(^LLMapAddressSearchTextBlock) (NSString *text);

@interface LLMapAddressSearchTitleView : LLView

@property (nonatomic, strong) IBOutlet UILabel *cityLabel;
@property (nonatomic, strong) IBOutlet UITextField *textField;

@property (nonatomic, copy) LLMapAddressSearchChooseCityBlock chooseCityBlock;
@property (nonatomic, copy) LLMapAddressSearchTextBlock searchTextBlock;

@end

NS_ASSUME_NONNULL_END
