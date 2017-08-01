//
//  UserItem.h
//  森
//
//  Created by Lee on 2017/4/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) void(^task)();
@property (nonatomic, strong) Class destVc;

+ (instancetype)userItemWithTitle:(NSString *)title image:(NSString *)image task:(void(^)())task;
+ (instancetype)userItemWithTitle:(NSString *)title image:(NSString *)image destVc:(Class)destVc;

@end
