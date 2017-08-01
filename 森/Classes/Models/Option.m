//
//  Option.m
//  森
//
//  Created by Lee on 17/4/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "Option.h"

@implementation Option

+ (instancetype)optionWithTitle:(NSString *)title value:(NSString *)value {
    Option *option = [[self alloc] init];
    option.title = title;
    option.value = value;
    return option;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"title:%@  value:%@", self.title, self.value];
}

@end
