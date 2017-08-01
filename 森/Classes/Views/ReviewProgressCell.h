//
//  ReviewProgressCell.h
//  森
//
//  Created by Lee on 2017/5/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReviewProgressCell;
@protocol ReviewProgressCellDelegate <NSObject>

@optional
- (void)reviewProgressButtonDidClick:(ReviewProgressCell *)cell;

@end

@interface ReviewProgressCell : UITableViewCell

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL showButton;
@property (nonatomic, weak) id <ReviewProgressCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
