//
//  UserCell.h
//  森
//
//  Created by Lee on 17/4/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserItem;

@interface UserCell : UITableViewCell

@property (nonatomic, strong) UserItem *userItem;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
