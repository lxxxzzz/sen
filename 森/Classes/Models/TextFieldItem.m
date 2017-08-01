//
//  TextFieldItem.m
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "TextFieldItem.h"

@implementation TextFieldItem

+ (instancetype)itemWithTitle:(NSString *)title placeholder:(NSString *)placeholder required:(BOOL)required {
    return [self itemWithTitle:title placeholder:placeholder keyboardType:UIKeyboardTypeDefault required:required];
}

+ (instancetype)itemWithTitle:(NSString *)title placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType required:(BOOL)required {
    return [self itemWithTitle:title maxLength:0 placeholder:placeholder keyboardType:keyboardType required:required];
}

+ (instancetype)itemWithTitle:(NSString *)title maxLength:(NSInteger)maxLength placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType required:(BOOL)required {
    TextFieldItem *item = [self itemWithTitle:title required:required];
    item.placeholder = placeholder;
    item.maxLength = maxLength;
    item.keyboardType = keyboardType;

    return item;
}

@end
