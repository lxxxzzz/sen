//
//  CustomerDetailViewController.m
//  森
//
//  Created by Lee on 17/4/9.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "MultiCell.h"
#import "BaseItem.h"
#import "HTTPTool.h"
#import "ItemGroup.h"
#import "NSString+Extension.h"
#import "LogViewController.h"
#import "UIBarButtonItem+Extension.h"

#import <SVProgressHUD.h>
#import <Masonry.h>

@interface CustomerDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *workflow;

@end

@implementation CustomerDetailViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
    
    [self getDetailData];
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - Override

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.title = @"客资详情";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"跟进日志" target:self action:@selector(log)];
    self.navigationItem.title = @"客资详情";
}

#pragma mark ACTION
- (void)log {
    LogViewController *logVc = [[LogViewController alloc] init];
    logVc.order_id = self.order_id;
    [self.navigationController pushViewController:logVc animated:YES];
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - 网络请求
- (void)getDetailData {
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=orderKeZiDetail", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = TOKEN;
    parameters[@"order_id"] = self.order_id;
    parameters[@"detail_type"] = @"1";
    @weakObj(self)
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        @strongObj(self)
        [SVProgressHUD dismiss];
        Log(@"%@   %@",result,TOKEN);
        if (result.success) {
 
            NSDictionary *dict = result.data[@"order_item"];
            ItemGroup *group1 = [[ItemGroup alloc] init];
            NSTimeInterval use_date = [dict[@"use_date"] doubleValue];
            NSString *strDate = nil;
            if (use_date > 0) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:use_date];
                NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
                fmt.dateFormat = @"yyyy-MM-dd";
                strDate = [fmt stringFromDate:date];
            }
            
            NSString *type;
            if ([dict[@"order_type"] integerValue] == 1) {
                type = @"婚宴";
            } else if ([dict[@"order_type"] integerValue] == 2) {
                type = @"会务";
            } else if ([dict[@"order_type"] integerValue] == 3) {
                type = @"团宴\\宝宝宴";
            }
            
            NSString *hotelType;
            NSString *hotelTitle;
            if ([dict[@"order_area_hotel_type"] integerValue] == 1) {
                hotelType = @"指定区域";
                hotelTitle = @"区域";
            } else if ([dict[@"order_area_hotel_type"] integerValue] == 2) {
                hotelType = @"指定酒店";
                hotelTitle = @"酒店";
            }
            group1.items = @[[BaseItem itemWithTitle:@"姓名" value:dict[@"customer_name"] required:NO],
                                [BaseItem itemWithTitle:@"类型" value:type required:NO],
                                [BaseItem itemWithTitle:@"手机号" value:dict[@"order_phone"] required:NO],
                                [BaseItem itemWithTitle:@"指定位置" value:hotelType required:YES],
                                [BaseItem itemWithTitle:hotelTitle value:dict[@"order_area_hotel_name"] required:YES],
                                [BaseItem itemWithTitle:@"桌数" value:dict[@"desk_count"] required:NO],
                                [BaseItem itemWithTitle:@"预算" value:dict[@"order_money"] required:NO],
                                [BaseItem itemWithTitle:@"时间" value:strDate required:NO],
                                [BaseItem itemWithTitle:@"备注" value:dict[@"order_desc"] required:NO]];
            ItemGroup *group2 = [[ItemGroup alloc] init];
            group2.header = @"审核信息";
            group2.header = @"处理状态";
            NSString *handle_note = result.data[@"handle_note"];
            NSTimeInterval timeInterval = [result.data[@"handle_time"] doubleValue];
            NSString *followDate = [NSString stringWithTimeInterval:timeInterval format:@"yyyy-MM-dd"];
            group2.items = @[[BaseItem itemWithTitle:@"处理进度" value:handle_note required:NO],
                             [BaseItem itemWithTitle:@"处理时间" value:followDate required:NO]];
            self.dataSource = @[group1, group2];
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemGroup *group = self.dataSource[indexPath.section];
    MultiCell *cell = [MultiCell cellWithTableView:tableView];
    cell.item = group.items[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    return group.header;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    if (group.header) return 50;
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    if (group.header) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 50)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
        label.text = group.header;
        [header addSubview:label];
        return header;
    }
    return nil;
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
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


@end
