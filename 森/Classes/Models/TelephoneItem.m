//
//  TelephoneItem.m
//  森
//
//  Created by Lee on 2017/7/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "TelephoneItem.h"

@implementation TelephoneItem

+ (instancetype)itemWithTitle:(NSString *)title value:(id)value click:(void (^)())click {
    TelephoneItem *item = [[self alloc] init];
    item.title = title;
    item.value = value;
    item.click = click;
    return item;
}

@end
