//
//  InputCustomerViewController.h
//  森
//
//  Created by Lee on 17/3/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArrowItem;

@interface InputCustomerViewController : UIViewController

@property (nonatomic, strong) ArrowItem *type;
@property (nonatomic, copy) NSString *phone;

@end
