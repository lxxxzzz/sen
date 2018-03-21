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
#define APP_TIME [NSString stringWithFormat:@"%.0f", [NSDate date].timeIntervalSince1970]

@implementation HTTPTool

+ (void)GET:(NSString *)url success:(void (^)(HTTPResult *))success failure:(void (^)(NSError *))failure {
    [self GET:url parameters:nil success:success failure:failure];
}

+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(HTTPResult *))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [self manager];
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    
    AFHTTPSessionManager *manager = [self manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (AFHTTPSessionManager *)manager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:APP_DEVICE forHTTPHeaderField:@"APP-DEVICE"];
    [manager.requestSerializer setValue:APP_TIME forHTTPHeaderField:@"APP-TIME"];
    [manager.requestSerializer setValue:[self sign] forHTTPHeaderField:@"APP-SIGN"];
    [manager.requestSerializer setValue:@"1.0" forHTTPHeaderField:@"version"];
    return manager;
}

+ (NSString *)sign {
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", kSignKey, APP_DEVICE, APP_TIME];
    return [NSString md5:sign];
}


@end
