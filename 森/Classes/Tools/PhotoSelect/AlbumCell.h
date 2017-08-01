//
//  AlbumCell.h
//  森
//
//  Created by Lee on 2017/5/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Album;

@interface AlbumCell : UITableViewCell

@property (nonatomic, strong) Album *album;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
