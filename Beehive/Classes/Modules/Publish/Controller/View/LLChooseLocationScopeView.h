//
//  LLChooseLocationScopeView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/12.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import "LLView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LLChooseLocationViewChooseCityBlock) (void);
typedef void(^LLChooseLocationViewChooseScopeBlock) (NSInteger index);

@interface LLChooseLocationScopeView : LLView

@property (nonatomic, weak) IBOutlet UILabel *addressLabel;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) LLChooseLocationViewChooseCityBlock chooseCityBlock;
@property (nonatomic, copy) LLChooseLocationViewChooseScopeBlock chooseScopeBlock;

@end

NS_ASSUME_NONNULL_END
