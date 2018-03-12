//
//  HTTPTool.m
//  森
//
//  Created by Lee on 17/3/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HTTPTool.h"
#import "RootVCManager.h"
#import "NSString+Sign.h"
#import <AFNetworking.h>

#define APP_DEVICE [UIDevice currentDevice].identifierForVendor.UUIDString
#define APP_TIME @((int)[NSDate date].timeIntervalSince1970)

@implementation HTTPTool

+ (void)GET:(NSString *)url success:(void (^)(HTTPResult *))success failure:(void (^)(NSError *))failure {
    [self GET:url parameters:nil success:success failure:failure];
}

+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(HTTPResult *))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSMutableDictionary *param = [parameters mutableCopy];
    param[@"APP-DEVICE"] = APP_DEVICE;
    param[@"APP-TIME"] = APP_TIME;
    param[@"APP-SIGN"] = [NSString md5:[NSString stringWithFormat:@"sen%@%@",APP_DEVICE, APP_TIME]];
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HTTPResult *result = [HTTPResult resultWithDict:responseObject];
        if (result.status == 997) {
            // 登录过期
            [User logout];
        }
        if (success) {
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(HTTPResult *))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSMutableDictionary *param = [parameters mutableCopy];
    param[@"APP-DEVICE"] = APP_DEVICE;
    param[@"APP-TIME"] = APP_TIME;
    param[@"APP-SIGN"] = [NSString md5:[NSString stringWithFormat:@"sen%@%@",APP_DEVICE, APP_TIME]];
    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HTTPResult *result = [HTTPResult resultWithDict:responseObject];
        if (result.status == 997) {
            // 登录过期
            [User logout];
        }
        if (success) {
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
