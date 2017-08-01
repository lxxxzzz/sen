//
//  Dropdown.h
//  森
//
//  Created by Lee on 17/3/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Dropdown;

@protocol DropdownDelegate <NSObject>

@optional
- (void)dropdown:(Dropdown *)dropdown didSelectIndex:(NSInteger)index;
- (void)dropdown:(Dropdown *)dropdown didSelectItem:(NSString *)str;

@end

@interface Dropdown : UIControl

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) id <DropdownDelegate> delegate;
@property (nonatomic, copy) void(^didSelectBlock)(NSInteger index, NSString *str);
@property (nonatomic, assign, getter=isOpen) BOOL open;

- (void)show;
- (void)hidden;
- (void)showInView:(UIView *)view;

@end
