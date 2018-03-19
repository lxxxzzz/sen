//
//  User.m
//  森
//
//  Created by Lee on 17/3/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "User.h"

@implementation User

static User *_instance;

//+ (void)load {
//    [self sharedUser];
//}

+ (instancetype)sharedUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        _instance = [[self alloc] init];
        _instance.account = [defaults objectForKey:@"account"];
        _instance.nike_name = [defaults objectForKey:@"nike_name"];
        _instance.access_token = [defaults objectForKey:@"access_token"];
        _instance.alipay_account = [defaults objectForKey:@"alipay_account"];
        _instance.user_type = [defaults integerForKey:@"user_type"];
        _instance.hotel_id = [defaults objectForKey:@"hotel_id"];
        _instance.hotel_name = [defaults objectForKey:@"hotel_name"];
        _instance.bank_account = [defaults objectForKey:@"bank_account"];
        _instance.area_id = [defaults objectForKey:@"area_id"];
        _instance.hotel_area = [defaults objectForKey:@"hotel_area"];
        _instance.bank_name = [defaults objectForKey:@"bank_name"];
        _instance.bank_user = [defaults objectForKey:@"bank_user"];
        _instance.zfb_name = [defaults objectForKey:@"zfb_name"];
        });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

+ (instancetype)userWithDict:(NSDictionary *)dict {
    User *user = [[self alloc] init];
    _instance.nike_name = dict[@"nike_name"];
    _instance.access_token = dict[@"access_token"];
    _instance.user_type = [dict[@"user_type"] integerValue];
    _instance.alipay_account = dict[@"alipay_account"];
    _instance.hotel_id = dict[@"hotel_id"];
    _instance.hotel_name = dict[@"hotel_name"];
    _instance.bank_account = dict[@"bank_account"];
    _instance.area_id = dict[@"area_id"];
    _instance.hotel_area = dict[@"hotel_area"];
    _instance.bank_user = dict[@"bank_user"];
    _instance.bank_name = dict[@"bank_name"];
    _instance.zfb_name = dict[@"zfb_name"];
    [self saveToSandbox];
    return user;
}

+ (void)logout {
    _instance.nike_name = nil;
    _instance.access_token = nil;
    _instance.user_type = -1;
    _instance.alipay_account = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"account"];
    [defaults removeObjectForKey:@"nike_name"];
    [defaults removeObjectForKey:@"access_token"];
    [defaults removeObjectForKey:@"user_type"];
    [defaults removeObjectForKey:@"alipay_account"];
    [defaults removeObjectForKey:@"hotel_id"];
    [defaults removeObjectForKey:@"hotel_name"];
    [defaults removeObjectForKey:@"bank_account"];
    [defaults removeObjectForKey:@"area_id"];
    [defaults removeObjectForKey:@"hotel_area"];
    [defaults removeObjectForKey:@"bank_user"];
    [defaults removeObjectForKey:@"bank_name"];
    [defaults removeObjectForKey:@"zfb_name"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserDidLogoutNotification object:nil];
}

+ (BOOL)online {
    return _instance.access_token.length;
}

+ (void)saveToSandbox {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_instance.account forKey:@"account"];
    [defaults setObject:_instance.nike_name forKey:@"nike_name"];
    [defaults setObject:_instance.access_token forKey:@"access_token"];
    [defaults setInteger:_instance.user_type forKey:@"user_type"];
    [defaults setObject:_instance.alipay_account forKey:@"alipay_account"];
    [defaults setObject:_instance.hotel_id forKey:@"hotel_id"];
    [defaults setObject:_instance.hotel_name forKey:@"hotel_name"];
    [defaults setObject:_instance.bank_account forKey:@"bank_account"];
    [defaults setObject:_instance.area_id forKey:@"area_id"];
    [defaults setObject:_instance.hotel_area forKey:@"hotel_area"];
    [defaults setObject:_instance.bank_user forKey:@"bank_user"];
    [defaults setObject:_instance.bank_name forKey:@"bank_name"];
    [defaults setObject:_instance.zfb_name forKey:@"zfb_name"];
    [defaults synchronize];
}

- (void)setAccount:(NSString *)account {
    _account = account;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_instance.account forKey:@"account"];
    [defaults synchronize];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"nike_name = %@\n  access_token = %@\n  user_type = %ld\n  alipay_account=%@\n  hotel_id=%@\n  hotel_name=%@\n bank_account=%@\n",self.nike_name,self.access_token,self.user_type,self.alipay_account,self.hotel_id,self.hotel_name,self.bank_account];
}


@end
