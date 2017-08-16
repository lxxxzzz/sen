//
//  HostManager.h
//  森
//
//  Created by 小红李 on 2017/8/16.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostManager : NSObject

@property (nonatomic, copy) NSString *host;
- (BOOL)isDebug;
- (void)debug:(BOOL)debug;

@end
