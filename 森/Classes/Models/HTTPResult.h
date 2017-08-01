//
//  HTTPResult.h
//  森
//
//  Created by Lee on 17/3/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPResult : NSObject

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) id data;
@property (nonatomic, assign) BOOL success;

+ (instancetype)resultWithDict:(NSDictionary *)dict;

@end
