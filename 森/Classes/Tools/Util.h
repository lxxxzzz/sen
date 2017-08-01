//
//  Util.h
//  森
//
//  Created by Lee on 2017/5/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Photo;

@interface Util : NSObject

+ (void)uploadImages:(NSArray *)images
             isAsync:(BOOL)isAsync
             success:(void(^)(NSArray *urls))success
             failure:(void(^)(NSError *error))failure;

@end
