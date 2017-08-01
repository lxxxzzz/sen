//
//  HTTPResult.m
//  森
//
//  Created by Lee on 17/3/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HTTPResult.h"

@implementation HTTPResult

- (BOOL)success {
//    return self.status == 200 && ([self.message isEqualToString:@"请求成功"] || [self.message isEqualToString:@"success"]);
    return self.status == 1000;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Result====>\n status = %ld \n message = %@ \n data = %@ \n", self.status, self.message, self.data];
}

+ (instancetype)resultWithDict:(NSDictionary *)dict {
    HTTPResult *result = [[self alloc] init];
    result.status = [dict[@"status"] integerValue];
    result.message = dict[@"message"];
    result.data = dict[@"data"];
    return result;
}

@end
