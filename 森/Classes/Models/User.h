//
//  User.h
//  森
//
//  Created by Lee on 17/3/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    alipay_account = 1234,
	hotel_name = 电台松江酒店,
	area_id = 40,
	hotel_area = 松江区,
	hotel_id = 85,
	user_type = 4,
	access_token = 6fabe705bac7d052ca2a674dca53a162,
	bank_account = ,
	nike_name
 */

@interface User : NSObject

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *nike_name;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *alipay_account;
@property (nonatomic, copy) NSString *bank_account;
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *bank_user;
@property (nonatomic, assign) NSInteger user_type;
@property (nonatomic, copy) NSString *hotel_id;
@property (nonatomic, copy) NSString *hotel_name;
@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *hotel_area;

+ (instancetype)userWithDict:(NSDictionary *)dict;
+ (instancetype)sharedUser;
+ (void)logout;
+ (BOOL)online;

@end
