//
//  UIBarButtonItem+Extension.m
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action title:(NSString *)title {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    // 设置按钮的尺寸为背景图片的尺寸
    [button sizeToFit];
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action {
    return [self itemWithImageName:imageName highImageName:highImageName target:target action:action title:nil];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 设置按钮的尺寸为背景图片的尺寸
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
