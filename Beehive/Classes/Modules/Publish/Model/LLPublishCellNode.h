//
//  LLPublishCellNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/3/8.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLPublishCellType) {
    LLPublishCellTypeRedMold = 0,    //红包类型选择
    LLPublishCellTypeTaskMold,       //红包任务类型
    LLPublishCellTypeInputTitle,     //输入标题
    LLPublishCellTypeImage,          //选择照片
    LLPublishCellTypeTaskName,       //任务名称
    LLPublishCellTypeTaskExplain,    //任务说明
    LLPublishCellTypeLinkAddress,    //链接地址输入
    LLPublishCellTypeLocation,       //选择位置
    LLPublishCellTypeRedAmount,      //红包金额
    LLPublishCellTypeRedCount,       //红包个数
    LLPublishCellTypePubDate,        //发布时间
    LLPublishCellTypeVisible,        //可见用户
    LLPublishCellTypeMore,           //展示更多
    LLPublishCellTypeAge,
    LLPublishCellTypeSex,
    LLPublishCellTypeHobbies,        //兴趣爱好
    LLPublishCellTypeIntro           //输入介绍
};

typedef NS_ENUM(NSInteger, LLPublishInputType) {
    LLPublishInputTypeSelect = 0, //选择类型
    LLPublishInputTypeInput,      //输入类型
};

@interface LLPublishCellNode : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *placeholder; //默认文案
@property (nonatomic, strong) NSString *inputText;   //选择之后的Text

@property (nonatomic, strong) NSMutableArray *uploadImageDatas; //图片Data

@property (nonatomic, assign) LLPublishCellType cellType; //发布功能类型
@property (nonatomic, assign) LLPublishInputType inputType; //输入功能类型

@property (nonatomic, assign) BOOL isMore; //是否展开更多

@property (nonatomic, assign) NSInteger redMold; //红包-0普通/1任务
@property (nonatomic, assign) NSInteger taskMold; //任务-0图片/1链接

@end

NS_ASSUME_NONNULL_END
