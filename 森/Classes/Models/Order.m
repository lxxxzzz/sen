//
//  Order.m
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "Order.h"

@implementation Order

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"customerId" : @"id"};
}

@end
