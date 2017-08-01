//
//  TelephoneCell.h
//  森
//
//  Created by Lee on 2017/7/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TelephoneItem, TelephoneCell;

@protocol TelephoneCellDelegate <NSObject>
@optional
- (void)telephoneCellDidCalling:(TelephoneCell *)cell;

@end

@interface TelephoneCell : UITableViewCell

@property (nonatomic, strong) TelephoneItem *item;
@property (nonatomic, weak) id <TelephoneCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
