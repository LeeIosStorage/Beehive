//
//  LLMultipleSelectedPickerView.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/10.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJToolBar;

@interface LLMultipleSelectedPickerView : UIView

typedef void(^MultipleDoneHandler)(NSArray *selectedIndexs, NSArray *selectedValues);
typedef void(^MultipleSelectedHandler)(NSArray *selectedValues);
typedef void(^BtnAction)();

@property (strong, nonatomic, readonly) ZJToolBar *toolBar;

- (instancetype)initWithToolBarText:(NSString *)toolBarText withDefaultIndexs: (NSArray *)defaultIndexs withData:(NSArray<NSString *> *)data withValueDidChangedHandler:(MultipleSelectedHandler)valueDidChangeHandler cancelAction:(BtnAction)cancelAction doneAction: (MultipleDoneHandler)doneAction;

@end
