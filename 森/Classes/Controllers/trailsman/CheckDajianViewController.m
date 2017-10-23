//
//  CheckDajianViewController.m
//  森
//
//  Created by Lee on 2017/5/26.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "CheckDajianViewController.h"
#import "CreateDajianViewController.h"

@interface CheckDajianViewController ()

@property (nonatomic, strong) TextFieldItem *phone;
@property (nonatomic, strong) ArrowItem *type;

@end

@implementation CheckDajianViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    
    self.tableView.footerTitle = @"立即验证";
    [self.tableView addTarget:self action:@selector(checkDajian)];
    
    [self setupNavigationItem];
}

- (void)loadData {
    self.type = [ArrowItem itemWithTitle:@"类型" required:NO];
    Option *option1 = [Option optionWithTitle:@"布展" value:@"1"];
    self.type.subTitle = option1.title;
    self.type.value = option1.value;
    __weak typeof(self) weakSelf = self;
    __weak typeof(self.type) weaktype = self.type;
    self.type.task = ^{
        weakSelf.keyboardView.dataSource = @[option1];
        [weakSelf.keyboardView show];
        weakSelf.keyboardView.didFinishBlock = ^(Option *option){
            weaktype.subTitle = option.title;
            weaktype.value = option.value;
            [weakSelf.tableView reloadData];
        };
    };
    self.phone = [TextFieldItem itemWithTitle:@"手机号" placeholder:@"请输入受访者的手机号" keyboardType:UIKeyboardTypeNumberPad required:YES];
    self.dataSource = @[self.type, self.phone];
    [self.tableView reloadData];
}

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.title = @"验证搭建信息";
}

#pragma mark Action
- (void)checkDajian {
    [self.view endEditing:YES];
    if (self.phone.value == nil) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    NSString *error = [self.phone.value validMobile];
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
        return;
    }
    [SVProgressHUD showWithStatus:@"验证中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=validatePhoneDaJianOrderType&debug=1", HOST];
    //    1婚宴 2会务 3宝宝宴
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"order_type"] = self.type.value;
    parameters[@"order_phone"] = self.phone.value;
    parameters[@"access_token"] = TOKEN;
    __weak typeof(self) weakSelf = self;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        [SVProgressHUD dismiss];
        if (result.success) {
            CreateDajianViewController *inputVc = [[CreateDajianViewController alloc] init];
            inputVc.phone = self.phone.value;
            inputVc.type = self.type;
            [weakSelf.navigationController pushViewController:inputVc animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

@end
