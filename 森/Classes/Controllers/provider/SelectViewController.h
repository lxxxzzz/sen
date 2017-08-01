//
//  SelectViewController.h
//  森
//
//  Created by Lee on 17/4/9.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Option, SelectViewController;

@protocol SelectViewControllerDelegate <NSObject>

@optional
- (void)selectViewController:(SelectViewController *)viewController didSelectOptions:(NSArray <Option *>*)options;

@end

@interface SelectViewController : UIViewController

@property (nonatomic, strong) NSArray <Option *>*dataSource;
@property (nonatomic, copy) void(^didSelectOptionsBlock)(NSArray <Option *>*options);
@property (nonatomic, weak) id <SelectViewControllerDelegate> delegate;

@end
