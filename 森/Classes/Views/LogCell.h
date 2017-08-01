//
//  LogCell.h
//  森
//
//  Created by Lee on 2017/4/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Log;

@interface LogCell : UITableViewCell

@property (nonatomic, strong) Log *log;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
