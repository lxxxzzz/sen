//
//  EXPayListViewController.m
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "EXPayListViewController.h"
#import "HTTPTool.h"
#import "PayList.h"
#import "PayListCell.h"
#import "Paylist2Cell.h"
#import "Option.h"
#import "ItemGroup.h"
#import <MJExtension.h>
#import <Masonry.h>

@interface EXPayListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation EXPayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"付款记录";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [self loadData];
}

- (void)loadData {
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=dajianOrderSignOtherList&debug=1", HOST];
    NSDictionary *parameters = @{
                                 @"access_token" : TOKEN,
                                 @"user_dajian_order_id" : self.order_id
                                 };
    self.dataSource = @[];
    [self.tableView reloadData];
    __weak typeof(self) weakself = self;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        if (result.success) {
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in result.data[@"sign_list"]) {
                PayList *paylist = [PayList mj_objectWithKeyValues:dict];
                ItemGroup *group = [[ItemGroup alloc] init];
                group.items = @[paylist];
                // 1 中款 2尾款 3附加款 4尾款时间 5首款
                if (paylist.sign_type == 1) {
                    group.header = @"中款明细与凭证";
                } else if (paylist.sign_type == 2) {
                    group.header = @"尾款明细与凭证";
                } else if (paylist.sign_type == 3) {
                    group.header = @"附加款明细与凭证";
                } else if (paylist.sign_type == 4) {
                    group.header = @"修改尾款时间";
                    paylist.order_sign_pic = @[];
                } else if (paylist.sign_type == 5) {
                    group.header = @"首款明细与凭证";
                }
                [temp addObject:group];
            }
            self.dataSource = temp;
        }
        [weakself.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemGroup *group = self.dataSource[indexPath.section];
    PayList *paylist = group.items[indexPath.row];
    if (paylist.sign_type == 5) {
        // 首付款
        PayListCell *cell = [PayListCell cellWithTableView:tableView];
        cell.paylist = paylist;
        return cell;
    }
    
    Paylist2Cell *cell = [Paylist2Cell cellWithTableView:tableView];
    cell.paylist = paylist;
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}
    
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    return group.header;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    ItemGroup *group = self.dataSource[indexPath.section];
//    PayList *paylist = group.items[indexPath.row];
//    if (paylist.sign_type == 5) {
//        // 首付款
//        return 463;
//    }
//    return 44;
//}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 463;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _tableView;
}

@end
