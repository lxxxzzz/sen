//
//  DJSignViewController.h
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Order;

@interface DJSignViewController : UIViewController

@property (nonatomic, strong) Order *order;
@property (nonatomic, assign) BOOL editable;

@end
