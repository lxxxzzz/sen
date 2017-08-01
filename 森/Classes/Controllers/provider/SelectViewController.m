//
//  SelectViewController.m
//  森
//
//  Created by Lee on 17/4/9.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "SelectViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "SelectCell.h"
#import "Option.h"
#import "SelectHeaderView.h"
#import <Masonry.h>
#import <SVProgressHUD.h>

@interface SelectViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SelectHeaderView *headerView;

@end

@implementation SelectViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.title = @"填写客资信息";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"确定" target:self action:@selector(confirm)];
}

- (void)confirm {
    NSMutableArray *options = [NSMutableArray array];
    for (Option *option in self.dataSource) {
        if (option.isSelected) {
            [options addObject:option];
        }
    }
    
    if (self.didSelectOptionsBlock) {
        self.didSelectOptionsBlock(options);
    }
    
    if ([self.delegate respondsToSelector:@selector(selectViewController:didSelectOptions:)]) {
        [self.delegate selectViewController:self didSelectOptions:options];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 布局
- (void)setupSubviews {
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (SelectCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectCell *cell = [SelectCell cellWithTableView:tableView];
    cell.option = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Option *option = self.dataSource[indexPath.row];
    
    if (self.headerView.count >= 3 && !option.isSelected) {
        [SVProgressHUD showErrorWithStatus:@"最多只能选3个"];
        return;
    }

    option.selected = !option.isSelected;
    
    NSInteger count = 0;
    for (Option *o in self.dataSource) {
        if (o.isSelected) {
            count++;
        }
    }

    self.headerView.count = count;
    
    [tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - setter and getter
#pragma mark getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
//        _tableView.tableHeaderView = self.headerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (SelectHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[SelectHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    }
    return _headerView;
}

@end
