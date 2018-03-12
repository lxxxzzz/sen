//
//  BaseParentOrderListViewController.m
//  森
//
//  Created by Lee on 2017/6/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BaseParentOrderListViewController.h"

@interface BaseParentOrderListViewController ()

@end

@implementation BaseParentOrderListViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentControl];
    
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.mas_equalTo(45);
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentControl.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.willAppearAction) {
        self.willAppearAction();
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [SVProgressHUD dismiss];
}

#pragma mark - 私有方法
#pragma mark 布局

#pragma mark 网络请求
- (void)reloadData {
    __block NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int i=0; i<self.childViewControllers.count; i++) {
        BaseOrderListViewController *baseVc = self.childViewControllers[i];
        NSString *status = [NSString stringWithFormat:@"%d", i + 1];
        
        __weak typeof(self) weakself = self;
        [self loadNewDataWithStatus:status orderPage:1 success:^(NSArray *orders, NSInteger maxCount) {
            baseVc.dataSource = [orders mutableCopy];
            [baseVc.tableView reloadData];
            
            [dict setObject:@(maxCount) forKey:status];
            weakself.segmentControl.badgeValue = dict;
        } failure:^{
            
        }];
    }
}

#pragma mark - delegate
#pragma mark SegmentControlDelegate
- (void)segmentView:(SegmentControl *)segment didSelectIndex:(NSInteger)index {
    [self.scrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        int index = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self.segmentControl scrollToIndex:index animated:YES];
    }
}

#pragma mark - setter and getter
- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    
    self.segmentControl.titles = titles;
    
    __weak typeof(self) weakself = self;
    
    __block NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int i=0; i<self.self.titles.count; i++) {
        BaseOrderListViewController *baseVc = [[BaseOrderListViewController alloc] init];
        baseVc.delegate = self;
        [self.scrollView addSubview:baseVc.view];
        [self addChildViewController:baseVc];
        [baseVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.scrollView.mas_left).offset(i * SCREEN_WIDTH);
            make.width.mas_equalTo(self.scrollView.mas_width);
            make.top.mas_equalTo(self.scrollView.mas_top);
            make.bottom.mas_equalTo(self.scrollView.mas_bottom);
            make.height.mas_equalTo(self.scrollView.mas_height);
            if (i == self.titles.count - 1) {
                make.right.mas_equalTo(self.scrollView.mas_right);
            }
        }];
        
        // 加载对应状态数据
        NSString *status = [NSString stringWithFormat:@"%d", i + 1];
        __weak typeof(baseVc) weakBaseVc = baseVc;
        void(^loadNewData)() = ^{
            weakBaseVc.order_page = 1;
            [weakBaseVc.tableView.mj_footer resetNoMoreData];
            
            [weakself loadNewDataWithStatus:status orderPage:1 success:^(NSArray *orders, NSInteger maxCount) {
                weakBaseVc.dataSource = [orders mutableCopy];
                [weakBaseVc.refreshView endRefresh];
                [baseVc.tableView.mj_header endRefreshing];

                [dict setObject:@(maxCount) forKey:status];
                
                weakself.segmentControl.badgeValue = dict;
                
                if (weakBaseVc.dataSource.count == maxCount) {
                    // 已加载全部数据
                    [weakBaseVc.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            } failure:^{
                
            }];
        };
        
        // 上拉加载更多
        void(^loadMoreData)() = ^{
            weakBaseVc.order_page ++;
            [weakself loadNewDataWithStatus:status orderPage:weakBaseVc.order_page success:^(NSArray *orders, NSInteger maxCount) {
                [weakBaseVc.dataSource addObjectsFromArray:orders];
                [baseVc.tableView.mj_footer endRefreshing];
                [weakBaseVc.tableView reloadData];
                if (weakBaseVc.dataSource.count == maxCount) {
                    // 已加载全部数据
                    [weakBaseVc.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } failure:^{
                if (weakBaseVc.order_page > 0) {
                    weakBaseVc.order_page --;
                }
                [baseVc.tableView.mj_footer endRefreshing];
                [weakBaseVc.tableView reloadData];
            }];
        };
        
        loadNewData();
        
        // 下拉刷新
        baseVc.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:loadNewData];
        // 加载更多
        baseVc.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:loadMoreData];
        
        // 刷新按钮点击事件
        [baseVc.refreshView setOnClickBlock:loadNewData];
    }
}


#pragma mark getter
- (SegmentControl *)segmentControl {
    if (_segmentControl == nil) {
        _segmentControl = [[SegmentControl alloc] init];
        _segmentControl.delegate = self;
    }
    return _segmentControl;
}

- (RefreshView *)refreshView {
    if (_refreshView == nil) {
        _refreshView = [RefreshView refreshView];
        __weak typeof(self) weakSelf = self;
        
        [_refreshView setOnClickBlock:^{
            [weakSelf reloadData];
        }];
    }
    return _refreshView;
}

@end
