//
//  EXUpdatePayDateViewController.h
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BaseMultiViewController.h"

@interface EXUpdatePayDateViewController : BaseMultiViewController

@property (nonatomic, assign) NSTimeInterval oldTime;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, copy) NSString *order_id;

@end
