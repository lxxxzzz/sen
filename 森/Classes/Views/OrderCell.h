//
//  OrderCell.h
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Order, OrderCell;

@protocol OrderCellDelegate <NSObject>

@optional
- (void)orderCellBtnDidClick:(OrderCell *)cell;

@end

@interface OrderCell : UITableViewCell

@property (nonatomic, strong) Order *order;
@property (nonatomic, weak) id <OrderCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
