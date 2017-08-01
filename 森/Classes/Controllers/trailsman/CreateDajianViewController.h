//
//  CreateDajianViewController.h
//  森
//
//  Created by Lee on 2017/5/26.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BasePlainViewController.h"

@interface CreateDajianViewController : BasePlainViewController

@property (nonatomic, strong) ArrowItem *type;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, strong) BaseItem *phoneItem;
@property (nonatomic, strong) BaseItem *typeItem;

@end
