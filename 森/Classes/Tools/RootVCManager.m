//
//  RootVCManager.m
//  森
//
//  Created by Lee on 17/3/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "RootVCManager.h"
#import "CustomerListViewController.h"
#import "UserViewController.h"
#import "DrawerViewController.h"
#import "BindingAccountViewController.h"
#import "UserItem.h"
#import "UserInfoViewController.h"
#import "FeedbackViewController.h"
#import "TMCustomerListViewController.h"
#import "LoginViewController.h"
#import "UpdatePasswordViewController.h"
#import "UserInfoViewController.h"
#import "TMCustomerListViewController.h"

#import "OrderSignViewController.h"

#import "TMListParentViewController.h"
#import "HotelListViewController.h"
#import "NavigationViewController.h"

@implementation RootVCManager

+ (void)rootVc {
    HotelListViewController *centerVc = [[HotelListViewController alloc] init];
    NavigationViewController *centerNav = [[NavigationViewController alloc] initWithRootViewController:centerVc];
    UserViewController *leftVc = [[UserViewController alloc] init];
    DrawerViewController *drawerController = [[DrawerViewController alloc] initWithLeftViewController:leftVc centerViewController:centerNav];
    [UIApplication sharedApplication].keyWindow.rootViewController = drawerController;
}

+ (void)bindingAccount:(BOOL)first {
    BindingAccountViewController *bindingVc = [[BindingAccountViewController alloc] init];
    bindingVc.first = first;
    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:bindingVc];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

+ (void)customerList {
    CustomerListViewController *centerVc = [[CustomerListViewController alloc] init];
    NavigationViewController *centerNav = [[NavigationViewController alloc] initWithRootViewController:centerVc];
    UserViewController *leftVc = [[UserViewController alloc] init];
    leftVc.dataSource = @[[UserItem userItemWithTitle:@"个人中心" image:@"icon-success" destVc:[UserInfoViewController class]],
                          [UserItem userItemWithTitle:@"用户反馈" image:@"icon-success" destVc:[FeedbackViewController class]]];
    DrawerViewController *drawerController = [[DrawerViewController alloc] initWithLeftViewController:leftVc centerViewController:centerNav];
    [UIApplication sharedApplication].keyWindow.rootViewController = drawerController;
}

//+ (void)tm_customerList {
//    TMListParentViewController *centerVc = [[TMListParentViewController alloc] init];
//    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerVc];
//    UserViewController *leftVc = [[UserViewController alloc] init];
//    leftVc.dataSource = @[[UserItem userItemWithTitle:@"信息提供" image:@"icon-success" destVc:[TMCustomerListViewController class]],
//                          [UserItem userItemWithTitle:@"信息跟进" image:@"icon-success" destVc:[TMCustomerTrackingViewController class]],
//                          [UserItem userItemWithTitle:@"个人中心" image:@"icon-success" destVc:[UserInfoViewController class]],
//                          [UserItem userItemWithTitle:@"修改密码" image:@"icon-success" destVc:[UpdatePasswordViewController class]],
//                          [UserItem userItemWithTitle:@"用户反馈" image:@"icon-success" destVc:[FeedbackViewController class]]];
//    DrawerViewController *drawerController = [[DrawerViewController alloc] initWithLeftViewController:leftVc centerViewController:centerNav];
//    [UIApplication sharedApplication].keyWindow.rootViewController = drawerController;
//}

+ (void)registerVc {
//    [UIApplication sharedApplication].keyWindow.rootViewController = [[RegisterViewController alloc] init];
}

+ (void)loginVc {
    [UIApplication sharedApplication].keyWindow.rootViewController = [[LoginViewController alloc] init];
}

+ (void)testVc {
    [UIApplication sharedApplication].keyWindow.rootViewController = [[OrderSignViewController alloc] init];
}

@end
