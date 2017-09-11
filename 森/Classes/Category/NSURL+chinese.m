//
//  NSURL+chinese.m
//  森
//
//  Created by 小红李 on 2017/8/14.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "NSURL+chinese.h"
#import <objc/message.h>

@implementation NSURL (chinese)

+ (void)load {
//    Method m1 = class_getClassMethod(self, @selector(URLWithString:));
//    Method m2 = class_getClassMethod(self, @selector(xx_URLWithString:));
//    method_exchangeImplementations(m1, m2);
}

+ (instancetype)xx_URLWithString:(NSString *)url {
    if (url == nil || [url isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    NSString *encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self URLWithString:encodedString];
}

@end
