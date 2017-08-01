//
//  UIBarButtonItem+Extension.h
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName
                         highImageName:(NSString *)highImageName
                                target:(id)target
                                action:(SEL)action
                                 title:(NSString *)title;

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName
                         highImageName:(NSString *)highImageName
                                target:(id)target
                                action:(SEL)action;

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title
                            target:(id)target
                            action:(SEL)action;

@end
