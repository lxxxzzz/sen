//
//  CreateDajianViewController.m
//  森
//
//  Created by Lee on 2017/5/26.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "CreateDajianViewController.h"
#import "TMListParentViewController.h"

@interface CreateDajianViewController () <SelectViewControllerDelegate>

@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) TextFieldItem *nameItem;
@property (nonatomic, strong) ArrowItem *areaItem;
@property (nonatomic, strong) TextFieldItem *budgetItem;
@property (nonatomic, strong) ArrowItem *dateItem;
@property (nonatomic, strong) TextViewItem *remarkItem;

@end

@implementation CreateDajianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    self.navigationItem.title = @"填写搭建信息";
    
    self.tableView.footerTitle = @"提交搭建信息";
    [self.tableView addTarget:self action:@selector(submit)];
}

- (void)loadData {
    self.nameItem = [TextFieldItem itemWithTitle:@"姓名"];
    self.nameItem.placeholder = @"请输入受访者姓名";
    self.nameItem.maxLength = 20;
    
    self.typeItem = [BaseItem itemWithTitle:@"类型"];
    self.typeItem.value = self.type.subTitle;
    self.phoneItem = [BaseItem itemWithTitle:@"手机号"];
    self.phoneItem.value = self.phone;
    self.areaItem = [ArrowItem itemWithTitle:@"区域" subTitle:nil required:YES];
    self.areaItem.value = USER.area_id;
    self.areaItem.disable = YES;
    self.areaItem.placeholder = USER.hotel_area;
    __weak typeof(self) weakSelf = self;
    
    self.budgetItem = [TextFieldItem itemWithTitle:@"预算" placeholder:@"请输入大概的预算范围" required:NO];
    self.dateItem = [ArrowItem itemWithTitle:@"时间" subTitle:nil required:NO];
    self.dateItem.placeholder = @"请输入大概的举办时间";
    self.dateItem.value = @0;
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
    self.remarkItem = [TextViewItem itemWithTitle:@"备注" value:@"" placeholder:@"请填写备注信息" height:88 required:NO];
    self.remarkItem.maxLength = 500;
    self.dataSource = @[self.nameItem, self.typeItem, self.phoneItem, self.areaItem, self.budgetItem, self.dateItem, self.remarkItem];
    [self.tableView reloadData];
}

- (void)submit {
    [SVProgressHUD showWithStatus:@"提交中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=createDaJian&debug=1",HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = TOKEN;
    parameters[@"order_type"] = self.type.value;
    parameters[@"order_phone"] = self.phone;
    parameters[@"order_area_hotel_type"] = @"1";
    parameters[@"order_area_hotel_id"] = self.areaItem.value;
    parameters[@"customer_name"] = self.nameItem.value;
    parameters[@"order_money"] = self.budgetItem.value;
    parameters[@"use_date"] = self.dateItem.value;
    parameters[@"order_desc"] = self.remarkItem.value;
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
                    [popVc setIndex:1];
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
    }];
}

- (void)getAreaList:(void(^)(NSArray <Option *>*options))handler {
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=orderHotelArea", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"hotel_area_type"] = @"1";
    parameters[@"access_token"] = TOKEN;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        [SVProgressHUD dismiss];
        if (result.success) {
            if ([result.data count]) {
                NSMutableArray *options = [NSMutableArray array];

                for (NSDictionary *dict in result.data[@"area_list"]) {
                    Option *option = [[Option alloc] init];
                    option.value = [dict objectForKey:@"area_id"];
                    option.title = [dict objectForKey:@"area_name"];
                    [options addObject:option];
                }
                
                if (handler) {
                    handler(options);
                }
            } else {
                if (handler) {
                    handler(@[]);
                }
            }
        } else {
            if (handler) {
                handler(@[]);
            }
        }
    } failure:^(NSError *error) {
        if (handler) {
            handler(@[]);
        }
        [SVProgressHUD dismiss];
    }];
}

@end
