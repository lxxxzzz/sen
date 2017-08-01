//
//  DropdownMenu.h
//  森
//
//  Created by Lee on 2017/7/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropdownMenu, Option;

@protocol DropdownMenuDelegate <NSObject>

@optional
- (void)dropdownMenu:(DropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (CGFloat)dropdownMenu:(DropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component;
- (NSString *)dropdownMenu:(DropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (NSString *)dropdownMenu:(DropdownMenu *)dropdownMenu titleForComponent:(NSInteger)component;
- (void)dropdownMenu:(DropdownMenu *)dropdownMenu didSelectOption:(Option *)option;

@end

@protocol DropdownMenuDataSource <NSObject>

@required
- (NSInteger)dropdownMenu:(DropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component;

@optional
- (NSInteger)numberOfComponentsInDropdownMenu:(DropdownMenu *)dropdownMenu;

@end

@interface DropdownMenu : UIView

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, weak) id <DropdownMenuDelegate> delegate;
@property (nonatomic, weak) id <DropdownMenuDataSource> dataSource;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) Option *selectedOption;
- (instancetype)initWithItems:(NSArray *)items;







@end
