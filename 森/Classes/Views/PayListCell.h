//
//  PayListCell.h
//  森
//
//  Created by Lee on 2017/6/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayList;

@interface PayListCell : UITableViewCell

@property (nonatomic, strong) PayList *paylist;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
