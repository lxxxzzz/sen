//
//  HotelListCell.h
//  森
//
//  Created by Lee on 2017/5/22.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Hotel;
@interface HotelListCell : UITableViewCell

@property (nonatomic, strong) Hotel *hotel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
