//
//  EXSignViewController.h
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Order;
@interface EXSignViewController : UIViewController

@property (nonatomic, strong) Order *order;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, copy) NSString *sign_type;

@end
