//
//  UserInfoViewController.m
//  森
//
//  Created by Lee on 17/3/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "UserInfoViewController.h"
#import "HTTPTool.h"
#import "BaseItem.h"
#import "TextFieldItem.h"
#import "SwitchItem.h"
#import "MultiCell.h"
#import "ItemGroup.h"
#import "BindingAccountViewController.h"

#import <Masonry.h>
#import <SVProgressHUD.h>

@interface UserInfoViewController () <UITableViewDelegate, UITableViewDataSource, MultiCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <ItemGroup *>*dataSource;

@property (nonatomic, copy) NSString *alipay;
@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;

@property (nonatomic, copy) void(^subHeaderAction)();

@property (nonatomic, strong) BaseItem *totalMoneyItem;
@property (nonatomic, strong) BaseItem *receiveMoneyItem;
@property (nonatomic, strong) BaseItem *unreceiveMoneyItem;
@property (nonatomic, strong) BaseItem *accountItem;
@property (nonatomic, strong) ItemGroup *group1;
@property (nonatomic, strong) SwitchItem *sync;

@end

@implementation UserInfoViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

#pragma mark - Override
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 私有方法
#pragma mark

- (void)setupNavigationItem {
    self.navigationItem.title = @"个人信息";
}

#pragma mark Action
- (void)save {
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=user&f=alipayBind", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"alipay"] = self.alipay;
    parameters[@"access_token"] = TOKEN;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        if (result.success) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

- (void)saveSync {
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=feedback&f=autoType", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *auto_type = [self.sync.value integerValue] == 1 ? @"2" : @"1";
    parameters[@"auto_type"] = auto_type;
    parameters[@"access_token"] = TOKEN;
    __weak typeof(self) weakself = self;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        if (result.success) {
            [SVProgressHUD showSuccessWithStatus:@"更新成功"];
            [[NSUserDefaults standardUserDefaults] setBool:[weakself.sync.value boolValue] forKey:weakself.sync.title];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

- (void)subHeaderOnClick {
    if (self.subHeaderAction) {
        self.subHeaderAction();
    }
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

#pragma mark - 网络请求
- (void)loadData {
    [SVProgressHUD showWithStatus:@"加载中..."];
    __weak typeof(self) weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=feedback&f=wallet&debug=1", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = TOKEN;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        [SVProgressHUD dismiss];
        if (result.success) {
            weakself.totalMoneyItem.value = [NSString stringWithFormat:@"￥%@", result.data[@"my_money"][@"all"]];
            weakself.receiveMoneyItem.value = [NSString stringWithFormat:@"￥%@", result.data[@"my_money"][@"pay"]];
            weakself.unreceiveMoneyItem.value = [NSString stringWithFormat:@"￥%@", result.data[@"my_money"][@"unpay"]];
            NSString *auto_type = result.data[@"auto_type"];
//            weakself.sync.value =
            // 1是关闭  2是打开
            if (![auto_type isKindOfClass:[NSNull class]]) {
                if ([auto_type isEqualToString:@"1"]) {
                    weakself.sync.value = @(0);
                } else {
                    weakself.sync.value = @(1);
                }
            }
            
            [[NSUserDefaults standardUserDefaults] setBool:[weakself.sync.value boolValue] forKey:weakself.sync.title];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (result.data[@"my_account"][@"bank_account"] && [result.data[@"my_account"][@"bank_account"] length]) {
                // 开户银行
                BaseItem *bankNameItem = [BaseItem itemWithTitle:@"开户银行" value:result.data[@"my_account"][@"bank_name"] required:NO];
                bankNameItem.textAlignment = NSTextAlignmentRight;
                // 开户名
                BaseItem *userNameItem = [BaseItem itemWithTitle:@"开户名" value:result.data[@"my_account"][@"bank_user"] required:NO];
                userNameItem.textAlignment = NSTextAlignmentRight;
                // 银行卡号
                BaseItem *accountItem = [BaseItem itemWithTitle:@"银行卡" value:result.data[@"my_account"][@"bank_account"] required:NO];
                accountItem.textAlignment = NSTextAlignmentRight;
                
                [User sharedUser].bank_account = accountItem.value;
                [User sharedUser].bank_name = bankNameItem.value;
                [User sharedUser].bank_user = userNameItem.value;
                [User sharedUser].alipay_account = nil;
                
                weakself.group1.items = @[bankNameItem, userNameItem, accountItem];
//                weakself.accountItem.title = @"银行卡";
//                weakself.accountItem.value = result.data[@"my_account"][@"bank_account"];
            } else {
                BaseItem *accountItem = [BaseItem itemWithTitle:@"支付宝" value:result.data[@"my_account"][@"alipay"] required:NO];
                accountItem.textAlignment = NSTextAlignmentRight;
                weakself.group1.items = @[accountItem];
                
                [User sharedUser].bank_account = nil;
                [User sharedUser].bank_name = nil;
                [User sharedUser].bank_user = nil;
                [User sharedUser].alipay_account = accountItem.value;
                [User sharedUser].zfb_name = result.data[@"my_account"][@"zfb_name"];
//                weakself.accountItem.title = @"支付宝";
//                weakself.accountItem.value = result.data[@"my_account"][@"alipay"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
        [weakself.tableView reloadData];
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

- (MultiCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultiCell *cell = [MultiCell cellWithTableView:tableView];
    ItemGroup *group = self.dataSource[indexPath.section];
    cell.item = group.items[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    if (group.header) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 36)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 36)];
        titleLabel.text = group.header;
        titleLabel.font = FONT(13);
        titleLabel.textColor = HEX(@"939399");
        [headerView addSubview:titleLabel];
        
        if (group.subHeader) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = FONT(13);
            [button setTitle:group.subHeader forState:UIControlStateNormal];
            [button sizeToFit];
            CGRect rect = button.frame;
            rect.origin.x = self.view.frame.size.width - rect.size.width - 10;
            rect.origin.y = 0;
            rect.size.height = 36;
            button.frame = rect;
            [button setTitleColor:HEX(@"3399ff") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(subHeaderOnClick) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:button];
            self.subHeaderAction = group.subHeaderAction;
        }
        return headerView;
    }
    return nil;
}

#pragma mark MultiCellDelegate
- (void)multiCell:(UITableViewCell *)cell valueDidChange:(id)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ItemGroup *group = self.dataSource[indexPath.section];
    BaseItem *item = group.items[indexPath.row];
    
    if ([item isKindOfClass:[SwitchItem class]]) {
        SwitchItem *switchItem = (SwitchItem *)item;
        switchItem.value = value;
        
        [self saveSync];
    } else {
        item.value = value;
    }
}

#pragma mark - setter and getter
#pragma mark getter
- (NSArray *)dataSource {
    if (_dataSource == nil) {
        __weak typeof(self) weakSelf = self;
        self.totalMoneyItem = [BaseItem itemWithTitle:@"总佣金" value:@"" required:NO];
        self.totalMoneyItem.textAlignment = NSTextAlignmentRight;
        self.receiveMoneyItem = [BaseItem itemWithTitle:@"已发放" value:@"" required:NO];
        self.receiveMoneyItem.textAlignment = NSTextAlignmentRight;
        self.unreceiveMoneyItem = [BaseItem itemWithTitle:@"未发放" value:@"" required:NO];
        self.unreceiveMoneyItem.textAlignment = NSTextAlignmentRight;
        ItemGroup *group0 = [[ItemGroup alloc] init];
        group0.header = @"我的佣金";
        group0.items = @[self.totalMoneyItem, self.receiveMoneyItem, self.unreceiveMoneyItem];
        
        self.accountItem = [BaseItem itemWithTitle:@"" value:@"" required:NO];
        self.accountItem.textAlignment = NSTextAlignmentRight;
        self.group1 = [[ItemGroup alloc] init];
        self.group1.subHeader = @"设定收款账号";
        self.group1.subHeaderAction = ^{
            BindingAccountViewController *bindingVc = [[BindingAccountViewController alloc] init];
            bindingVc.bindVCDidPop = ^{
                [weakSelf loadData];
            };
            [weakSelf.navigationController pushViewController:bindingVc animated:YES];
        };
//        self.group1.items = @[self.accountItem];
        self.group1.header = @"收款账号";
        
        self.sync = [SwitchItem itemWithTitle:@"接收客资同步信息"];
        self.sync.value = @([[NSUserDefaults standardUserDefaults] boolForKey:self.sync.title]);
        
        
        ItemGroup *group2 = [[ItemGroup alloc] init];
        group2.header = @"设定信息同步";
        group2.items = @[self.sync];
        
        if ([User sharedUser].user_type == 4) {
            _dataSource = @[group0, self.group1, group2];
        } else {
            _dataSource = @[group0, self.group1];
        }
    }
    return _dataSource;
}

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

@end
