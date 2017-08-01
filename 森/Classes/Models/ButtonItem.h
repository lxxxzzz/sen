//
//  ButtonItem.h
//  森
//
//  Created by Lee on 2017/5/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BaseItem.h"

@interface ButtonItem : BaseItem

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void(^click)();
+ (instancetype)itemWithTitle:(NSString *)title image:(NSString *)image value:(id)value click:(void (^)())click;
+ (instancetype)itemWithTitle:(NSString *)title text:(NSString *)text value:(id)value click:(void (^)())click;

@end
