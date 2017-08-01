//
//  ArrowItem.m
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ArrowItem.h"

@implementation ArrowItem

+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle required:(BOOL)required {
    ArrowItem *item = [self itemWithTitle:title required:required];
    item.subTitle = subTitle;
    return item;
}

@end
