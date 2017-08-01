//
//  Log.m
//  森
//
//  Created by Lee on 2017/5/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "Log.h"

@implementation Log

- (NSString *)title {
    if (self.user_order_status == 1) {
        if (self.order_follow_time) {
            return @"下次跟进";
        } else {
            return @"有效";
        }
    } else if (self.user_order_status == 1) {
        return @"无效";
    } else {
        return @"签单";
    }
}

@end
