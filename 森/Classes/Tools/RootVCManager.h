//
//  RootVCManager.h
//  森
//
//  Created by Lee on 17/3/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootVCManager : NSObject

+ (void)rootVc;

+ (void)bindingAccount:(BOOL)first;
+ (void)customerList;
+ (void)registerVc;

// 客资
//+ (void)tm_customerList;
+ (void)loginVc;
+ (void)testVc;

@end
