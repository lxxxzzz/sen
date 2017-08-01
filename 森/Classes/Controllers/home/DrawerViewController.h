//
//  DrawerViewController.h
//  森
//
//  Created by Lee on 17/3/23.
//  Copyright © 2017年 Lee. All rights reserved.
//

#define SCREEN_W [[UIScreen mainScreen] bounds].size.width
#define SCREEN_H [[UIScreen mainScreen] bounds].size.height

#import <UIKit/UIKit.h>

@class DrawerViewController;
@protocol DrawerViewControllerDelegate <NSObject>

@optional
- (void)drawerViewController:(DrawerViewController *)viewController didScroll:(CGFloat)offset;

@end

@interface DrawerViewController : UIViewController
@property (nonatomic, weak) UIViewController *leftController;
@property (nonatomic, weak) UIViewController *centerController;
@property (nonatomic, weak) id <DrawerViewControllerDelegate> delegate;
- (instancetype)initWithLeftViewController:(UIViewController *)leftController
                      centerViewController:(UIViewController *)centerController;
- (void)openDrawerWithAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion;
- (void)closeDrawerWithAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

@end
