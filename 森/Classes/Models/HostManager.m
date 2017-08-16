//
//  HostManager.m
//  森
//
//  Created by 小红李 on 2017/8/16.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HostManager.h"

@implementation HostManager

static HostManager *_instance;

+ (void)load {
    [self manager];
}

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
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

- (void)debug:(BOOL)debug {
    [[NSUserDefaults standardUserDefaults] setBool:debug forKey:kURLKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isDebug {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kURLKey];
}

- (NSString *)host {
    if ([self isDebug]) {
        return DEBUG_HOST;
    } else {
        return RELEASE_HOST;
    }
}

@end
