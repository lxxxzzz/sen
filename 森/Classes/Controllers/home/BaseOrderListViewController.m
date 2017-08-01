//
//  BaseOrderListViewController.m
//  森
//
//  Created by Lee on 2017/6/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BaseOrderListViewController.h"

@interface BaseOrderListViewController ()


@end

@implementation BaseOrderListViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.order_page = 1;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - 私有方法

#pragma mark 网络请求
#pragma mark 布局
- (void)setupSubviews {
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.refreshView];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [self.refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(162, 35));
    }];
}

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (OrderCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCell *cell = [OrderCell cellWithTableView:tableView];
    cell.order = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Order *order = self.dataSource[indexPath.row];
    if (order.order_status == 1) {
        return 150;
    }
    return 179;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Order *order = self.dataSource[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(baseOrderListViewController:didSelectOrder:)]) {
        [self.delegate baseOrderListViewController:self didSelectOrder:order];
    }
}

- (void)orderCellBtnDidClick:(OrderCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ([self.delegate respondsToSelector:@selector(baseOrderListViewController:orderCellBtnDidClick:)]) {
        [self.delegate baseOrderListViewController:self orderCellBtnDidClick:self.dataSource[indexPath.row]];
    }
}

#pragma mark - setter and getter
-(void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    
    if (dataSource.count) {
        self.tableView.hidden = NO;
        self.refreshView.hidden = YES;
    } else {
        self.tableView.hidden = YES;
        self.refreshView.hidden = NO;
    }
    [self.tableView reloadData];
}

#pragma mark getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 173;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _tableView;
}

- (RefreshView *)refreshView {
    if (_refreshView == nil) {
        _refreshView = [RefreshView refreshView];
    }
    return _refreshView;
}

@end
