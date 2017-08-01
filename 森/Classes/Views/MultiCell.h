//
//  MultiCell.h
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseItem, MultiCell;

@protocol MultiCellDelegate <NSObject>

@optional
- (void)multiCellTextFieldBecomeFirstResponder:(MultiCell *)cell;
//- (void)multiCell:(UITableViewCell *)cell becomeFirstResponder:(BOOL)flag;
- (void)multiCell:(UITableViewCell *)cell didBeyondLength:(NSInteger)length title:(NSString *)title;
- (void)multiCell:(UITableViewCell *)cell valueDidChange:(id)value;

@end

@interface MultiCell : UITableViewCell

@property (nonatomic, strong) BaseItem *item;
@property (nonatomic, weak) id <MultiCellDelegate> delegate;
@property (nonatomic, assign) BOOL readOnly;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)becomeFirstResponder;

@end
