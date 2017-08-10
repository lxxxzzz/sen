//
//  LogViewController.m
//  森
//
//  Created by Lee on 2017/5/31.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "LogViewController.h"

#import "Log.h"
#import "LogCell.h"
#import "HTTPTool.h"
#import <MJExtension.h>
#import <Masonry.h>
#import <SVProgressHUD.h>

@interface LogViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation LogViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
    
    [self getLog];
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - Override

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.title = @"跟进日志";
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.messageLabel];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark 网络请求
- (void)getLog {
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=keziOrderFollowList", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = TOKEN;
    parameters[@"user_kezi_order_id"] = self.order_id;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        [SVProgressHUD dismiss];
        if (result.success) {
            if ([result.data count]) {
                self.messageLabel.hidden = YES;
                self.tableView.hidden = NO;
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in result.data) {
                    Log *log = [Log mj_objectWithKeyValues:dict];
                    [array addObject:@[log]];
                }
                self.dataSource = array;
                [self.tableView reloadData];
            } else {
                self.messageLabel.hidden = NO;
                self.tableView.hidden = YES;
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataSource[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogCell *cell = [LogCell cellWithTableView:tableView];
    NSArray *array = self.dataSource[indexPath.section];
    cell.log = array[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - setter and getter
#pragma mark getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 159;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = @"暂无具体信息";
        _messageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        _messageLabel.hidden = YES;
        _messageLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _messageLabel;
}


@end
