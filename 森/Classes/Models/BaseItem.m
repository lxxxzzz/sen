//
//  BaseItem.m
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BaseItem.h"

@implementation BaseItem

+ (instancetype)itemWithTitle:(NSString *)title value:(id)value required:(BOOL)required {
    BaseItem *item = [[self alloc] init];
    item.title = title;
    item.required = required;
    item.value = value;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title required:(BOOL)required {
    return [self itemWithTitle:title value:nil required:required];
}

+ (instancetype)itemWithTitle:(NSString *)title {
    return [self itemWithTitle:title required:NO];
}

- (void)setValue:(NSString *)value {
    if ([value isKindOfClass:NSClassFromString(@"NSNumber")]) {
        _value = [NSString stringWithFormat:@"%@", value];
    } else {
        _value = value;
    }
    
    if (self.valueDidChange) {
        self.valueDidChange(value);
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"title:%@   value:%@",self.title,self.value];
}

@end
