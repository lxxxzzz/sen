//
//  UpdatePasswordViewController.m
//  森
//
//  Created by Lee on 2017/5/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "TableView.h"
#import "BaseItem.h"
#import "TextFieldItem.h"
#import "MultiCell.h"
#import "UIBarButtonItem+Extension.h"
#import "HTTPTool.h"

#import <Masonry.h>
#import <SVProgressHUD.h>

@interface UpdatePasswordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TableView *tableView;
@property (nonatomic, strong) NSArray <BaseItem *>*dataSource;

@end

@implementation UpdatePasswordViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - Override

#pragma mark - 私有方法
#pragma mark 初始化设置
- (void)setupNavigationItem {
    self.navigationItem.title = @"修改密码";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"确定" target:self action:@selector(updatePassword)];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark Action
- (void)updatePassword {
    // 校验
    BaseItem *oldPassword = self.dataSource[0];
    BaseItem *newPassword = self.dataSource[1];
    BaseItem *confirmNewPassword = self.dataSource[2];
    if ([oldPassword.value length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
        return;
    }
    
    if ([newPassword.value length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }
    
    if ([confirmNewPassword.value length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请再次输入新密码"];
        return;
    }
    
    if (![confirmNewPassword.value isEqualToString:newPassword.value]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"修改中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=feedback&f=accountEdit&debug=1", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = TOKEN;
    parameters[@"old_password"] = oldPassword.value;
    parameters[@"password"] = newPassword.value;
    parameters[@"re_password"] = confirmNewPassword.value;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        [SVProgressHUD dismiss];
        if (result.success) {
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (MultiCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultiCell *cell = [MultiCell cellWithTableView:tableView];
    cell.item = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

#pragma mark - setter and getter
#pragma mark getter
- (TableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[TableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        TextFieldItem *oldPassword = [TextFieldItem itemWithTitle:@"原密码" placeholder:@"请输入密码" required:NO];
        oldPassword.secureTextEntry = YES;
        TextFieldItem *newPassword = [TextFieldItem itemWithTitle:@"新密码" placeholder:@"请输入新密码" required:NO];
        newPassword.secureTextEntry = YES;
        TextFieldItem *confirmNewPassword = [TextFieldItem itemWithTitle:@"确认新密码" placeholder:@"请再次输入新密码" required:NO];
        confirmNewPassword.secureTextEntry = YES;
        _dataSource = @[oldPassword, newPassword, confirmNewPassword];
    }
    return _dataSource;
}

@end
