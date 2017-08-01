//
//  Paylist2Cell.h
//  森
//
//  Created by Lee on 2017/7/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayList;
@interface Paylist2Cell : UITableViewCell

@property (nonatomic, strong) PayList *paylist;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
