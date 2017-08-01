//
//  BasePlainViewController.h
//  森
//
//  Created by Lee on 2017/5/26.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardView.h"
#import "ItemGroup.h"
#import "MultiCell.h"
#import "BaseItem.h"
#import "ArrowItem.h"
#import "TextViewItem.h"
#import "TextFieldItem.h"
#import "ButtonItem.h"
#import "Option.h"
#import "TableView.h"
#import "DateKeyboardView.h"
#import "UIBarButtonItem+Extension.h"
#import "NSString+Extension.h"
#import "HTTPTool.h"
#import "SelectViewController.h"
#import "Order.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <MJExtension.h>

@interface BasePlainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MultiCellDelegate>

@property (nonatomic, copy) void(^subHeaderAction)();
@property (nonatomic, strong) TableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) KeyboardView *keyboardView;
@property (nonatomic, strong) Order *order;
@property (nonatomic, strong) DateKeyboardView *dateKeyboardView;
@property (nonatomic, weak) MultiCell *firstResponderCell;

@end
