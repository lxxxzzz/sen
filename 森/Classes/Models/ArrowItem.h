//
//  ArrowItem.h
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BaseItem.h"

@interface ArrowItem : BaseItem

@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) BOOL disable;
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) void(^task)();
+ (instancetype)itemWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                     required:(BOOL)required;

@end
