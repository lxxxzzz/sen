//
//  NSString+Sign.m
//  qyuedai
//
//  Created by 小红李 on 2017/11/15.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "NSString+Sign.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Sign)

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
