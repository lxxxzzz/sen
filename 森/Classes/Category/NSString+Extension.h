//
//  NSString+Extension.h
//  森
//
//  Created by Lee on 17/3/22.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (BOOL)isPureInt;
- (BOOL)isPureFloat;
- (CGSize)sizeWithText:(CGSize)constrained font:(UIFont *)font;
- (NSString *)validMobile;
+ (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format;
+ (NSString *)nowDateWithTimeFormat:(NSString *)format;

@end
