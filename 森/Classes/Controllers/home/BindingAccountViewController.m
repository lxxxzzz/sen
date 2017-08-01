//
//  BindingAccountViewController.m
//  森
//
//  Created by Lee on 2017/5/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BindingAccountViewController.h"
#import "CustomerListViewController.h"
#import "UserViewController.h"
#import "DrawerViewController.h"
#import "RootVCManager.h"
#import "HTTPTool.h"

#import "ItemGroup.h"
#import "MultiCell.h"
#import "SwitchItem.h"
#import "TextFieldItem.h"
#import "ArrowItem.h"
#import "Option.h"
#import "KeyboardView.h"

#import <SVProgressHUD.h>
#import <Masonry.h>

@interface BindingAccountViewController () <UITableViewDelegate, UITableViewDataSource, MultiCellDelegate>

@property (nonatomic, strong) UIButton *ignoreBtn;
@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;

@property (nonatomic, copy) NSString *alipay;
@property (nonatomic, strong) ArrowItem *accountTypeItem;
@property (nonatomic, strong) TextFieldItem *bankItem;
@property (nonatomic, strong) TextFieldItem *userNameItem;
@property (nonatomic, strong) TextFieldItem *accountItem;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <ItemGroup *>*dataSource;
@property (nonatomic, strong) KeyboardView *keyboardView;

@end

@implementation BindingAccountViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.keyboardView hidden];
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - Override
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.title = @"设定个人信息";
    if (self.isFirst) {
        self.rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    } else {
        self.rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    }

    [self.rightButtonItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateDisabled];
    
    self.rightButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = self.rightButtonItem;
}

#pragma mark Action
- (void)next {
    __weak typeof(self) weakself = self;
    [SVProgressHUD showWithStatus:@"保存中..."];
    // 存储支付宝账号，发送网络请求
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=user&f=alipayBind", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if ([self.accountTypeItem.value isEqualToString:@"1"]) {
        // 1、支付宝
        parameters[@"alipay"] = self.alipay;
    } else {
        parameters[@"bank_name"] = self.bankItem.value;
        parameters[@"bank_user"] = self.userNameItem.value;
        parameters[@"bank_account"] = self.accountItem.value;
    }
    
    parameters[@"access_token"] = TOKEN;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        if (result.success) {
            
            if ([weakself.accountTypeItem.value isEqualToString:@"1"]) {
                // 1、支付宝
                parameters[@"alipay"] = weakself.alipay;
                [User sharedUser].alipay_account = weakself.alipay;
                [User sharedUser].bank_name = nil;
                [User sharedUser].bank_user = nil;
                [User sharedUser].bank_account = nil;
            } else {
                [User sharedUser].alipay_account = nil;
                [User sharedUser].bank_name = weakself.bankItem.value;
                [User sharedUser].bank_user = weakself.userNameItem.value;
                [User sharedUser].bank_account = weakself.accountItem.value;
            }
            
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [RootVCManager rootVc];
            });
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

- (void)save {
    __weak typeof(self) weakself = self;
    [SVProgressHUD showWithStatus:@"保存中..."];
    // 存储支付宝账号，发送网络请求
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=user&f=alipayBind", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if ([self.accountTypeItem.value isEqualToString:@"1"]) {
        // 1、支付宝
        parameters[@"alipay"] = self.alipay;
    } else {
        parameters[@"bank_name"] = self.bankItem.value;
        parameters[@"bank_user"] = self.userNameItem.value;
        parameters[@"bank_account"] = self.accountItem.value;
    }
    
    parameters[@"access_token"] = TOKEN;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        if (result.success) {
            
            if ([weakself.accountTypeItem.value isEqualToString:@"1"]) {
                // 1、支付宝
                parameters[@"alipay"] = weakself.alipay;
                [User sharedUser].alipay_account = weakself.alipay;
                [User sharedUser].bank_name = nil;
                [User sharedUser].bank_user = nil;
                [User sharedUser].bank_account = nil;
            } else {
                [User sharedUser].alipay_account = nil;
                [User sharedUser].bank_name = weakself.bankItem.value;
                [User sharedUser].bank_user = weakself.userNameItem.value;
                [User sharedUser].bank_account = weakself.accountItem.value;
            }
            
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"%@",[NSThread currentThread]);
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

- (void)jump {
    [RootVCManager rootVc];
}

- (void)textFieldDidChange:(UITextField *)textField {
    self.rightButtonItem.enabled = textField.hasText;
}

- (void)checkStatus {
    BOOL enable = YES;
    for (ItemGroup *group in _dataSource) {
        for (BaseItem *item in group.items) {
            Log(@"%@  %d   %@",item.title, item.isRequired, item.value);
            if (item.isRequired) {
                if (item.value == nil || [item.value length] == 0) {
                    enable = NO;
                }
            }
        }
    }
    self.rightButtonItem.enabled = enable;
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
    
    if (self.isFirst) {
        UIButton *jump = [UIButton buttonWithType:UIButtonTypeCustom];
        jump.titleLabel.font = FONT(12);
        [jump setTitle:@"暂不设置，以后再说" forState:UIControlStateNormal];
        [jump setTitleColor:RGB(35, 145, 227) forState:UIControlStateNormal];
        [jump addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:jump];
        
        [jump mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-30);
        }];
    }
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
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 23.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    return group.footer;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ItemGroup *group = self.dataSource[indexPath.section];
    BaseItem *item = group.items[indexPath.row];
    if ([item isKindOfClass:[ArrowItem class]]) {
        ArrowItem *arrowItem = (ArrowItem *)item;
        if (arrowItem.task) {
            arrowItem.task();
        }
    }
}

#pragma mark MultiCellDelegate
- (void)multiCell:(UITableViewCell *)cell valueDidChange:(id)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ItemGroup *group = self.dataSource[indexPath.section];
    BaseItem *item = group.items[indexPath.row];
    
    if ([item isKindOfClass:[SwitchItem class]]) {
        SwitchItem *switchItem = (SwitchItem *)item;
        switchItem.value = value;
        
        [[NSUserDefaults standardUserDefaults] setBool:[switchItem.value boolValue] forKey:switchItem.title];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        item.value = value;
    }
}

#pragma mark - setter and getter
#pragma mark getter
- (NSArray *)dataSource {
    if (_dataSource == nil) {
        __weak typeof(self) weakSelf = self;
        ItemGroup *group1 = [[ItemGroup alloc] init];
        
        TextFieldItem *alipay = [TextFieldItem itemWithTitle:@"支付宝" placeholder:@"请输入支付宝账号" required:YES];
        alipay.textAlignment = NSTextAlignmentRight;
        alipay.valueDidChange = ^(id value){
            weakSelf.alipay = value;
            weakSelf.rightButtonItem.enabled = [value length];
        };
        
        // 开户银行
        self.bankItem = [TextFieldItem itemWithTitle:@"开户银行" placeholder:@"请输入开户行名称" required:YES];
        self.bankItem.textAlignment = NSTextAlignmentRight;
        self.bankItem.valueDidChange = ^(id value){
            [weakSelf checkStatus];
        };
        
        self.userNameItem = [TextFieldItem itemWithTitle:@"开户名" placeholder:@"请输入开户名" required:YES];
        self.userNameItem.textAlignment = NSTextAlignmentRight;
        self.userNameItem.valueDidChange = ^(id value){
            [weakSelf checkStatus];
        };
        
        self.accountItem = [TextFieldItem itemWithTitle:@"开户行账号" placeholder:@"请输入开户账号" required:YES];
        self.accountItem.textAlignment = NSTextAlignmentRight;
        self.accountItem.valueDidChange = ^(id value){
            [weakSelf checkStatus];
        };
        
        self.accountTypeItem = [ArrowItem itemWithTitle:@"设定收款类型" subTitle:nil required:NO];
        NSArray <Option *>*options = @[[Option optionWithTitle:@"支付宝账号" value:@"1"],
                                       [Option optionWithTitle:@"银行卡账号" value:@"2"]];
        self.accountTypeItem.textAlignment = NSTextAlignmentRight;
        if (ALIPAY_ACCOUNT) {
            // 有阿里账号
            self.accountTypeItem.value = options[0].value;
            self.accountTypeItem.subTitle = options[0].title;
            
            alipay.value = ALIPAY_ACCOUNT;
        } else if (BANK_ACCOUNT) {
            // 有设定银行卡号
            self.accountTypeItem.value = options[1].value;
            self.accountTypeItem.subTitle = options[1].title;
            self.accountItem.value = BANK_ACCOUNT;
            
            self.bankItem.value = [User sharedUser].bank_name;
            
            self.userNameItem.value = [User sharedUser].bank_user;
            
            self.accountItem.value = [User sharedUser].bank_account;
            
        } else {
            // 啥都没有
            self.accountTypeItem.value = options[0].value;
            self.accountTypeItem.subTitle = options[0].title;
        }
        
        __weak typeof(self.accountTypeItem) weakAccountTypeItem = self.accountTypeItem;
        self.accountTypeItem.task = ^{
            weakSelf.keyboardView.dataSource = options;
            
            if ([weakSelf.accountTypeItem.value isEqualToString:@"1"]) {
                // 支付宝账号
                // 设定默认选择为支付宝
                weakSelf.keyboardView.selectedOption = options[0];
            } else {
                // 银行卡
                // 设定默认选择为银行卡
                weakSelf.keyboardView.selectedOption = options[1];
            }
            
            [weakSelf.keyboardView show];
            weakSelf.keyboardView.didFinishBlock = ^(Option *option){
                weakAccountTypeItem.subTitle = option.title;
                weakAccountTypeItem.value = option.value;
                if ([option.value isEqualToString:@"1"]) {
                    // 支付宝账号
                    group1.items = @[weakAccountTypeItem, alipay];
                } else {
                    // 银行卡账号
                    group1.items = @[weakAccountTypeItem, weakSelf.bankItem, weakSelf.userNameItem, weakSelf.accountItem];
                }
                // 
                [weakSelf checkStatus];
                [weakSelf.tableView reloadData];
            };
        };
        
        if ([self.accountTypeItem.value isEqualToString:@"1"]) {
            // 支付宝账号
            group1.items = @[weakSelf.accountTypeItem, alipay];
        } else {
            // 银行卡
            group1.items = @[weakSelf.accountTypeItem, self.bankItem, self.userNameItem, self.accountItem];
        }
        
        
        group1.footer = @"只有绑定账号，才能提成哦";
        
        _dataSource = @[group1];
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

- (KeyboardView *)keyboardView {
    if (_keyboardView == nil) {
        _keyboardView = [[KeyboardView alloc] init];
    }
    return _keyboardView;
}

@end
