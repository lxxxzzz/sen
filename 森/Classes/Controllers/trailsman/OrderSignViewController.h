//
//  OrderSignViewController.h
//  森
//
//  Created by Lee on 2017/5/26.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Order;

@interface OrderSignViewController : UIViewController

@property (nonatomic, strong) Order *order;
@property (nonatomic, assign) BOOL editable;

@end
