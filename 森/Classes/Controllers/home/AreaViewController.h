//
//  AreaViewController.h
//  森
//
//  Created by Lee on 2017/5/23.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AreaViewController, Option;
@protocol AreaViewControllerDelegate <NSObject>

@optional
- (void)areaViewController:(AreaViewController *)viewController didSelectArea:(Option *)area;

@end

@interface AreaViewController : UIViewController

@property (nonatomic, weak) id<AreaViewControllerDelegate> delegate;

@end
