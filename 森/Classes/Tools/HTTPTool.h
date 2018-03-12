//
//  HTTPTool.h
//  森
//
//  Created by Lee on 17/3/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPResult.h"

@interface HTTPTool : NSObject

//+ (void)GET:(NSString *)url
//    success:(void(^)(HTTPResult *result))success
//    failure:(void(^)(NSError *error))failure;
+ (void)GET:(NSString *)url
 parameters:(NSDictionary *)parameters
    success:(void(^)(HTTPResult *result))success
    failure:(void(^)(NSError *error))failure;

+ (void)POST:(NSString *)url
      parameters:(NSDictionary *)parameters
     success:(void(^)(HTTPResult *result))success
     failure:(void(^)(NSError *error))failure;

@end
