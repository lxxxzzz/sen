//
//  HTTPTool.m
//  森
//
//  Created by Lee on 17/3/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HTTPTool.h"
#import "RootVCManager.h"
#import <AFNetworking.h>

@implementation HTTPTool

+ (void)GET:(NSString *)url success:(void (^)(HTTPResult *))success failure:(void (^)(NSError *))failure {
    [self GET:url parameters:nil success:success failure:failure];
}

+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(HTTPResult *))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
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

@end
