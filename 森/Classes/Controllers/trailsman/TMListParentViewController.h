//
//  TMListParentViewController.h
//  森
//
//  Created by Lee on 2017/5/16.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMListParentViewController : UIViewController

@property (nonatomic, weak) UISegmentedControl *segmentedControl;
- (void)setIndex:(NSInteger)index;

@end
