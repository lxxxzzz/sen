//
//  PhotoSelectCell.h
//  森
//
//  Created by Lee on 2017/5/3.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoSelectCell;
@protocol PhotoSelectCellDelegate <NSObject>
@optional;
- (void)photoSelectCellHeightDidChange:(PhotoSelectCell *)cell height:(CGFloat)height;
- (void)photoSelectCellAdd:(PhotoSelectCell *)cell;
- (void)photoSelectCell:(PhotoSelectCell *)cell didSelectPhotos:(NSArray *)photos;
//- (void)photoSelectCell:(PhotoSelectCell *)cell deletePhoto:

@end

@interface PhotoSelectCell : UITableViewCell

@property (nonatomic, weak) id<PhotoSelectCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) BOOL editable;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (CGFloat)cellHeight;

@end
