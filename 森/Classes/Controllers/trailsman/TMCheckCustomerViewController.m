//
//  TMCheckCustomerViewController.m
//  森
//
//  Created by Lee on 2017/4/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "TMCheckCustomerViewController.h"
#import "Dropdown.h"
#import "HTTPTool.h"

#import "NSString+Extension.h"

#import <Masonry.h>
#import <SVProgressHUD.h>

#import "MultiCell.h"

#import "ArrowItem.h"
#import "TextFieldItem.h"
#import "TableView.h"
#import "KeyboardView.h"
#import "Option.h"

#import "TMInputCustomerViewController.h"

@interface TMCheckCustomerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) KeyboardView *keyboardView;
@end

@implementation TMCheckCustomerViewController

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

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.title = @"验证客资信息";
}

#pragma mark Action
- (void)checkCustomer {
    [self.view endEditing:YES];
    TextFieldItem *phone = self.dataSource[1];
    ArrowItem *type = self.dataSource[0];
    if (phone.value == nil) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    NSString *error = [phone.value validMobile];
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
        return;
    }
    [SVProgressHUD showWithStatus:@"验证中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=validatePhoneOrderType", HOST];
    //    1婚宴 2会务 3宝宝宴
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"order_type"] = type.value;
    parameters[@"order_phone"] = phone.value;
    parameters[@"access_token"] = TOKEN;
    __weak typeof(self) weakSelf = self;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        [SVProgressHUD dismiss];
        if (result.success) {
            TMInputCustomerViewController *inputVc = [[TMInputCustomerViewController alloc] init];
            inputVc.phone = phone.value;
            inputVc.type = type;
            [weakSelf.navigationController pushViewController:inputVc animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

#pragma mark 布局
- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BaseItem *item = self.dataSource[indexPath.row];
    if ([item isKindOfClass:[ArrowItem class]]) {
        ArrowItem *arrowItem = (ArrowItem *)item;
        if (arrowItem.task) {
            arrowItem.task();
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    
    //    [self.keyboardView hiden];
}

#pragma mark - setter and getter
#pragma mark getter
- (TableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[TableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.footerTitle = @"立即验证";
        _tableView.rowHeight = 44;
        [_tableView addTarget:self action:@selector(checkCustomer)];
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        ArrowItem *type = [ArrowItem itemWithTitle:@"类型" required:NO];
        Option *option1 = [Option optionWithTitle:@"婚宴" value:@"1"];
        Option *option2 = [Option optionWithTitle:@"会务" value:@"2"];
        Option *option3 = [Option optionWithTitle:@"团宴\\宝宝宴" value:@"3"];
        type.subTitle = option1.title;
        type.value = option1.value;
        __weak typeof(self) weakSelf = self;
        __weak typeof(type) weaktype = type;
        type.task = ^{
            weakSelf.keyboardView.dataSource = @[option1, option2, option3];
            [weakSelf.keyboardView show];
            weakSelf.keyboardView.didFinishBlock = ^(Option *option){
                weaktype.subTitle = option.title;
                weaktype.value = option.value;
                [weakSelf.tableView reloadData];
            };
        };
        TextFieldItem *phone = [TextFieldItem itemWithTitle:@"手机号" placeholder:@"请输入受访者的手机号" keyboardType:UIKeyboardTypeNumberPad required:YES];
        _dataSource = @[type, phone];
    }
    return _dataSource;
}

- (KeyboardView *)keyboardView {
    if (_keyboardView == nil) {
        _keyboardView = [[KeyboardView alloc] init];
    }
    return _keyboardView;
}

@end
