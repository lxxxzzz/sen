//
//  AppDelegate.m
//  森
//
//  Created by Lee on 17/3/22.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"
#import "RootVCManager.h"
#import "PhotoManager.h"

#import <SVProgressHUD.h>
#import <UMMobClick/MobClick.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
//    [SVProgressHUD setBackgroundColor:HEX(@"#F7F7F7")];
    [SVProgressHUD setBackgroundColor:RGBA(0, 0, 0, 0.6)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    
    [RootVCManager rootVc];
    
    /*
    NSString *rootViewControllerKey = [[NSUserDefaults standardUserDefaults] objectForKey:kRootViewControllerKey];
    if ([rootViewControllerKey isEqualToString:NSStringFromClass([RegisterViewController class])]) {
        if (TOKEN) {
            [RootVCManager tm_customerList];
        } else {
            [RootVCManager loginVc];
        }
    } else {
        if (TOKEN) {
            [RootVCManager customerList];
        } else {
            [RootVCManager registerVc];
        }
    }
     */
    
    // 相册相关设置
    [[PhotoManager manager] setOptions:DefaultControllerOptionsCameraRoll];
    [[PhotoManager manager] setMaxSelectCount:8];
    
    // 友盟统计
    UMConfigInstance.appKey = @"595486fe4ad15672e9000310";
    UMConfigInstance.ChannelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
