//
//  TelephoneItem.h
//  森
//
//  Created by Lee on 2017/7/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BaseItem.h"

@interface TelephoneItem : BaseItem

@property (nonatomic, copy) void(^click)();

+ (instancetype)itemWithTitle:(NSString *)title value:(id)value click:(void (^)())click;

@end
