//
//  UserItem.m
//  森
//
//  Created by Lee on 2017/4/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "UserItem.h"

@implementation UserItem

+ (instancetype)userItemWithTitle:(NSString *)title image:(NSString *)image task:(void (^)())task {
    UserItem *item = [[self alloc] init];
    item.title = title;
    item.image = image;
    item.task = task;
    return item;
}

+ (instancetype)userItemWithTitle:(NSString *)title image:(NSString *)image destVc:(Class)destVc {
    UserItem *item = [[self alloc] init];
    item.title = title;
    item.image = image;
    item.destVc = destVc;
    return item;
}

@end
