//
//  NavigationViewController.m
//  森
//
//  Created by Lee on 2017/7/15.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

+ (void)initialize {
    [self setupBarButtonItemStyle];
    
    [self setupNavigationBarStyle];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        //denglu1
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [self itemWithImageName:@"icons_back_white" highImageName:@"icons_back_white" target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController hidesBottomBar:(BOOL)hide animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = hide;
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [self itemWithImageName:@"icons_back_white" highImageName:@"icons_back_white" target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}

+ (void)setupBarButtonItemStyle {
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1/1.0];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    // 去除返回按钮文字
    //    [appearance setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

+ (void)setupNavigationBarStyle {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    // 背景颜色
    navigationBar.barTintColor = RGB(35, 145, 227);
    // 返回按钮文字
    navigationBar.tintColor = HEX(@"#FFFFFF");
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"PingFangSC-Medium" size:17];;
    [navigationBar setTitleTextAttributes:textAttrs];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    // 设置按钮的尺寸为背景图片的尺寸
    [button sizeToFit];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
