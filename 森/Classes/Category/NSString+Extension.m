//
//  NSString+Extension.m
//  森
//
//  Created by Lee on 17/3/22.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (BOOL)isPureInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

- (BOOL)isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (CGSize)sizeWithText:(CGSize)constrained font:(UIFont *)font {
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [self boundingRectWithSize:constrained
                                     options:
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                  attributes:attribute
                                     context:nil].size;
    
    return size;
}

- (NSString *)validMobile {
    if (self.length < 11) {
        // 必须是11位
        return @"手机号码不合法";
    } else {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(173)|(18[0,1,9]))\\d{8}$";
        NSString *phone = @"^((1))\\d{10}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:self];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:self];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:self];
        NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone];
        BOOL isMatch4 = [pred4 evaluateWithObject:self];
        
//        if (isMatch1 || isMatch2 || isMatch3) {
        if (isMatch4) {
            return nil;
        } else {
            return @"手机号码不合法";
        }
    }
    return nil;
}

+ (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = format;
    return [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

+ (NSString *)nowDateWithTimeFormat:(NSString *)format {
    return [self stringWithTimeInterval:[NSDate date].timeIntervalSince1970 format:format];
}

@end
