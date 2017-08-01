//
//  SelectCell.h
//  森
//
//  Created by Lee on 17/4/9.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Option;

@interface SelectCell : UITableViewCell

@property (nonatomic, strong) Option *option;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
