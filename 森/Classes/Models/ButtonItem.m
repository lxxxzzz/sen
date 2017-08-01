//
//  ButtonItem.m
//  森
//
//  Created by Lee on 2017/5/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ButtonItem.h"

@implementation ButtonItem

+ (instancetype)itemWithTitle:(NSString *)title image:(NSString *)image value:(id)value click:(void (^)())click {
    ButtonItem *item = [[self alloc] init];
    item.image = image;
    item.title = title;
    item.value = value;
    item.click = click;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title text:(NSString *)text value:(id)value click:(void (^)())click {
    ButtonItem *item = [[self alloc] init];
    item.text = text;
    item.title = title;
    item.value = value;
    item.click = click;
    return item;
}

@end
