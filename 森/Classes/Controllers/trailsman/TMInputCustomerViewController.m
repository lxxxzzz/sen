//
//  TMInputCustomerViewController.m
//  森
//
//  Created by Lee on 2017/4/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "TMInputCustomerViewController.h"
#import "ArrowItem.h"
#import "TextFieldItem.h"
#import "TableView.h"
#import "KeyboardView.h"
#import "Option.h"
#import "MultiCell.h"
#import "HTTPTool.h"
#import "HTTPResult.h"
#import "SelectViewController.h"
#import "DateKeyboardView.h"
#import "TextViewItem.h"
#import "TMListParentViewController.h"

#import <Masonry.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface TMInputCustomerViewController ()<UITableViewDelegate, UITableViewDataSource, SelectViewControllerDelegate, MultiCellDelegate>

@property (nonatomic, strong) TableView *tableView;
@property (nonatomic, strong) NSArray <BaseItem *>*dataSource;
@property (nonatomic, strong) KeyboardView *keyboardView;
@property (nonatomic, strong) DateKeyboardView *dateKeyboardView;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSArray *hotels;
@property (nonatomic, weak) MultiCell *firstResponderCell;

@property (nonatomic, strong) BaseItem *typeItem;
@property (nonatomic, strong) TextFieldItem *nameItem;
@property (nonatomic, strong) ArrowItem *hotelItem;
@property (nonatomic, strong) ArrowItem *areaItem;
@property (nonatomic, strong) TextFieldItem *countItem;
@property (nonatomic, strong) TextFieldItem *moneyItem;
@property (nonatomic, strong) ArrowItem *dateItem;
@property (nonatomic, strong) TextViewItem *descItem;

@end

@implementation TMInputCustomerViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
    
    [self setupNotifacation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.keyboardView hidden];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    Log(@"%s",__func__);
}

#pragma mark - Override

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.title = @"填写客资信息";
}

- (void)setupNotifacation {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    CGRect kbRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat btnY = CGRectGetMaxY(self.firstResponderCell.frame) + 64;
    Log(@"%f  %f",kbRect.origin.y, btnY);
    
    if (kbRect.origin.y < btnY) {
        CGFloat difference = ABS(btnY - kbRect.origin.y);
        [self.tableView setContentOffset:CGPointMake(0, difference) animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)noti {
    [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
}

#pragma mark 布局
- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark 网络请求
- (void)submitCustomerInfo {
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:@"提交中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=createKeZi",HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"order_type"] = self.type.value;
    parameters[@"order_phone"] = self.phone;
    parameters[@"access_token"] = TOKEN;
    parameters[@"order_area_hotel_type"] = self.areaItem.value;
    parameters[@"order_area_hotel_id"] = self.hotelItem.value;
    parameters[@"customer_name"] = self.nameItem.value;
    parameters[@"desk_count"] = self.countItem.value;
    parameters[@"use_date"] = @([self.dateItem.value integerValue]);
    parameters[@"order_money"] = self.moneyItem.value;
    parameters[@"order_desc"] = self.descItem.value;
    __weak typeof(self) weakSelf = self;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@", result);
        [SVProgressHUD dismiss];
        if (result.success) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *controllers = self.navigationController.viewControllers;
                TMListParentViewController *popVc;
                for (UIViewController *vc in controllers) {
                    if ([vc isKindOfClass:[TMListParentViewController class]]) {
                        popVc = (TMListParentViewController *)vc;
                        break;
                    }
                }
                if (popVc) {
                    [popVc setIndex:0];
                    [weakSelf.navigationController popToViewController:popVc animated:YES];
                } else {
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            });
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
        Log(@"%@", error);
    }];
}

- (void)getAreaInfoWithType:(NSString *)type completion:(void(^)(NSArray <Option *>*options))completion{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=orderHotelArea", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"hotel_area_type"] = type;
    parameters[@"access_token"] = TOKEN;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        [SVProgressHUD dismiss];
        if (result.success) {
            if ([result.data count]) {
                NSMutableArray *options = [NSMutableArray array];
                if ([type isEqualToString:@"2"]) {
                    for (NSDictionary *dict in result.data[@"hotel_list"]) {
                        Option *option = [[Option alloc] init];
                        option.value = [dict objectForKey:@"hotel_id"];
                        option.title = [dict objectForKey:@"hotel_name"];
                        [options addObject:option];
                    }
                } else {
                    for (NSDictionary *dict in result.data[@"area_list"]) {
                        Option *option = [[Option alloc] init];
                        option.value = [dict objectForKey:@"area_id"];
                        option.title = [dict objectForKey:@"area_name"];
                        [options addObject:option];
                    }
                }
                if (completion) {
                    completion(options);
                }
            } else {
                if (completion) {
                    completion(@[]);
                }
            }
        } else {
            if (completion) {
                completion(nil);
            }
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(nil);
        }
        [SVProgressHUD dismiss];
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
    if (!cell.delegate) cell.delegate = self;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseItem *item = self.dataSource[indexPath.row];
    if ([item isKindOfClass:[TextViewItem class]]) {
        TextViewItem *textViewItem = (TextViewItem *)item;
        return textViewItem.height;
    }
    return 44;
}

#pragma mark SelectViewControllerDelegate
- (void)selectViewController:(SelectViewController *)viewController didSelectOptions:(NSArray<Option *> *)options {
    
}

#pragma mark MultiCellDelegate
- (void)multiCellTextFieldBecomeFirstResponder:(MultiCell *)cell {
    self.firstResponderCell = cell;
}

- (void)multiCell:(UITableViewCell *)cell didBeyondLength:(NSInteger)length title:(NSString *)title {
    NSString *error = [NSString stringWithFormat:@"%@最多只能输入%ld个字", title, length];
    [SVProgressHUD showErrorWithStatus:error];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    [self.view endEditing:YES];
    
    //    [self.keyboardView hiden];
}

#pragma mark - setter and getter
#pragma mark getter
- (TableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[TableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.footerTitle = @"提交客资信息";
        [_tableView addTarget:self action:@selector(submitCustomerInfo)];
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        self.nameItem = [TextFieldItem itemWithTitle:@"姓名"];
        self.nameItem.placeholder = @"请输入受访者姓名";
        self.nameItem.maxLength = 20;
        
        self.typeItem = [BaseItem itemWithTitle:@"类型"];
        self.typeItem.value = self.type.subTitle;
        BaseItem *phoneItem = [BaseItem itemWithTitle:@"手机号"];
        phoneItem.value = self.phone;
        
        Log(@"%@",[User sharedUser]);
        self.hotelItem = [ArrowItem itemWithTitle:@"酒店" subTitle:nil required:YES];
        self.hotelItem.value = [User sharedUser].hotel_id;
        self.hotelItem.placeholder = [User sharedUser].hotel_name;
        self.hotelItem.disable = YES;
        self.areaItem = [ArrowItem itemWithTitle:@"指定位置" subTitle:nil required:YES];
        self.areaItem.value = @"2";
        self.areaItem.placeholder = @"指定酒店";
        self.areaItem.disable = YES;
        
        __weak typeof(self) weakSelf = self;
        self.countItem = [TextFieldItem itemWithTitle:@"桌数" placeholder:@"请输入预计需要的桌数" keyboardType:UIKeyboardTypeNumberPad required:NO];
        self.moneyItem = [TextFieldItem itemWithTitle:@"预算" placeholder:@"请输入大概的预算范围" required:NO];
        self.dateItem = [ArrowItem itemWithTitle:@"时间" subTitle:nil required:NO];
        self.dateItem.placeholder = @"请输入大概的举办时间";
        __weak typeof(self.dateItem) weakDate = self.dateItem;
        self.dateItem.task = ^{
            [weakSelf.dateKeyboardView show];
            weakSelf.dateKeyboardView.didSelectDate = ^(NSDate *date){
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"YYYY-MM-dd";
                weakDate.subTitle = [dateFormatter stringFromDate:date];//该方法用于从日期对象返回日期字符串
                weakDate.value = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
                [weakSelf.tableView reloadData];
            };
        };
        self.descItem = [TextViewItem itemWithTitle:@"备注" value:@"" placeholder:@"请填写备注信息" height:88 required:NO];
        self.descItem.maxLength = 500;
        _dataSource = @[weakSelf.nameItem, weakSelf.typeItem, phoneItem, weakSelf.areaItem, weakSelf.hotelItem, weakSelf.countItem, weakSelf.moneyItem, weakSelf.dateItem, weakSelf.descItem];
    }
    return _dataSource;
}

- (KeyboardView *)keyboardView {
    if (_keyboardView == nil) {
        _keyboardView = [[KeyboardView alloc] init];
    }
    return _keyboardView;
}

- (DateKeyboardView *)dateKeyboardView {
    if (_dateKeyboardView == nil) {
        _dateKeyboardView = [[DateKeyboardView alloc] init];
    }
    return _dateKeyboardView;
}

@end
