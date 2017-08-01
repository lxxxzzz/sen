//
//  HotelCell.h
//  森
//
//  Created by Lee on 2017/6/1.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Room;

@interface HotelCell : UITableViewCell

@property (nonatomic, strong) Room *room;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
