//
//  HostTool.m
//  森
//
//  Created by 小红李 on 2017/8/16.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HostTool.h"

@implementation HostTool

+ (void)debug:(BOOL)debug {
    [[NSUserDefaults standardUserDefaults] setBool:debug forKey:kURLKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isDebug {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kURLKey];
}

+ (NSString *)host {
    if ([self isDebug]) {
        return DEBUG_HOST;
    } else {
        return RELEASE_HOST;
    }
}


@end
