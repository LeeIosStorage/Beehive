//
//  LLCollectionListNode.h
//  Beehive
//
//  Created by yilunzheluo on 2019/4/4.
//  Copyright © 2019 Leejun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLCollectionListNode : NSObject

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *DataId;
@property (nonatomic, strong) NSString *ImgUrl;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSArray *ImgUrls;
@property (nonatomic, assign) int LookCount;
@property (nonatomic, assign) int GoodsCount;
@property (nonatomic, assign) int CommentCount;
@property (nonatomic, assign) int ConvertCount;

@end

NS_ASSUME_NONNULL_END
