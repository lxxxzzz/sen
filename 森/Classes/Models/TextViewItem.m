//
//  TextViewItem.m
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "TextViewItem.h"

@implementation TextViewItem

+ (instancetype)itemWithTitle:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder height:(CGFloat)height required:(BOOL)required {
    TextViewItem *item = [self itemWithTitle:title value:value required:required];
    item.placeholder = placeholder;
    item.height = height;
    return item;
}

@end
