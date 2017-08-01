//
//  BaseListViewController.m
//  森
//
//  Created by Lee on 2017/5/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BaseListViewController.h"

@interface BaseListViewController () 


@end

@implementation BaseListViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self loadData];
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
- (void)loadData {
    //子类实现
}

#pragma mark 布局
- (void)setupSubviews {
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
    
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.refreshView];
    
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.mas_equalTo(45);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentControl.mas_bottom);
//        make.top.mas_equalTo(self.view.mas_top);
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Order *order = self.dataSource[indexPath.row];
    if (order.order_status == 1) {
        return 150;
    }
    return 179;
}

#pragma mark SegmentControlDelegate
- (void)segmentView:(SegmentControl *)segment didSelectIndex:(NSInteger)index {
    [self loadData];
}


#pragma mark - setter and getter
#pragma mark getter
- (SegmentControl *)segmentControl {
    if (_segmentControl == nil) {
        _segmentControl = [[SegmentControl alloc] init];
        _segmentControl.delegate = self;
    }
    return _segmentControl;
}

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
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _tableView;
}

- (RefreshView *)refreshView {
    if (_refreshView == nil) {
        _refreshView = [RefreshView refreshView];
        __weak typeof(self) weakSelf = self;
                
        [_refreshView setOnClickBlock:^{
            [weakSelf loadData];
        }];
    }
    return _refreshView;
}

@end
