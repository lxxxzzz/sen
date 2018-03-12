//
//  CustomerListViewController.m
//  森
//
//  Created by Lee on 17/3/23.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "CustomerListViewController.h"
#import "DrawerViewController.h"
#import "CheckCustomerViewController.h"
#import "SegmentControl.h"
#import "HTTPTool.h"
#import "Order.h"
#import "OrderCell.h"
#import "CustomerDetailViewController.h"

#import "UIBarButtonItem+Extension.h"

#import <Masonry.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <MJRefresh.h>

@interface CustomerListViewController () <SegmentControlDelegate>

@property (nonatomic, strong) UILabel *addCustomerLabel;
@property (nonatomic, strong) UIButton *addCustomerBtn;
//@property (nonatomic, strong) SegmentControl *segmentControl;
//@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation CustomerListViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
    
    self.titles = @[@"跟进中", @"待结算", @"已结算", @"已取消"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置状态栏文字颜色为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
//    [self reloadData];
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.title = @"客资列表";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"icons_adding_white" highImageName:@"icons_adding_white" target:self action:@selector(addCustomer)];
}

#pragma mark Action
- (void)addCustomer {
    CheckCustomerViewController *checkVc = [[CheckCustomerViewController alloc] init];
    [self.navigationController pushViewController:checkVc animated:YES];
}

- (void)userInfo {
    UINavigationController *nav = (UINavigationController *)self.parentViewController;
    if ([nav.parentViewController isKindOfClass:[DrawerViewController class]]) {
        DrawerViewController *drawerVc = (DrawerViewController *)nav.parentViewController;
        [drawerVc openDrawerWithAnimated:YES completion:nil];
    }
}

#pragma mark 网络请求
- (void)loadNewDataWithStatus:(NSString *)status orderPage:(NSInteger)page success:(void (^)(NSArray *,NSInteger))success failure:(void (^)())failure {
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=orderKeZiList", HOST];
    NSDictionary *parameters = @{
                                 @"access_token" : TOKEN,
                                 @"order_status" : status,
                                 @"order_page"   : @(page)
                                 };
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        if (result.success) {
            NSArray *order_list = result.data[@"order_list"];
            NSInteger maxCount = [result.data[@"count"] integerValue];
            if (order_list.count) {
                NSMutableArray *orders = [NSMutableArray array];
                for(int i=0;i < order_list.count;i++) {
                    NSDictionary *dict = order_list[i];
                    Order *order = [Order mj_objectWithKeyValues:dict];
                    order.type = OrderTypeKezi;
                    if (order.order_status == 1) {
                        order.status = OrderStatusGenjinzhong;
                    } else if (order.order_status == 2) {
                        order.status = OrderStatusDaijiesuan;
                    } else if (order.order_status == 3) {
                        order.status = OrderStatusYijiesuan;
                    } else if (order.order_status == 4) {
                        order.status = OrderStatusYiquxiao;
                    }
                    [orders addObject:order];
                }
                
                if (success) {
                    success(orders, maxCount);
                }
            } else {
                if (success) {
                    success(@[], 0);
                }
            }
        } else {
            if (success) {
                success(@[], 0);
            }
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

#pragma mark 布局
- (void)setupSubviews {
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
    
    [self.view addSubview:self.addCustomerLabel];
    [self.view addSubview:self.addCustomerBtn];
    
    [self.addCustomerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.addCustomerBtn.mas_top).offset(-21);
    }];
    
    [self.addCustomerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(45);
        make.right.mas_equalTo(self.view.mas_right).offset(-45);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - delegate
#pragma mark BaseOrderListViewControllerDelegate
- (void)baseOrderListViewController:(BaseOrderListViewController *)viewController didSelectOrder:(Order *)order {
    CustomerDetailViewController *detailVc = [[CustomerDetailViewController alloc] init];
    detailVc.order_id = order.customerId;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - setter and getter
#pragma mark getter
- (UIButton *)addCustomerBtn {
    if (_addCustomerBtn == nil) {
        _addCustomerBtn = [[UIButton alloc] init];
        _addCustomerBtn.titleLabel.font = FONT(14);
        _addCustomerBtn.backgroundColor = HEX(@"#178FE6");
        _addCustomerBtn.layer.cornerRadius = 4;
        _addCustomerBtn.layer.masksToBounds = YES;
        [_addCustomerBtn setTitle:@"添加客资信息" forState:UIControlStateNormal];
        [_addCustomerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addCustomerBtn addTarget:self action:@selector(addCustomer) forControlEvents:UIControlEventTouchUpInside];
        _addCustomerBtn.hidden = YES;
    }
    return _addCustomerBtn;
}

- (UILabel *)addCustomerLabel {
    if (_addCustomerLabel == nil) {
        _addCustomerLabel = [[UILabel alloc] init];
        _addCustomerLabel.text = @"一份客资，一份收入";
        _addCustomerLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _addCustomerLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
        _addCustomerLabel.hidden = YES;
    }
    return _addCustomerLabel;
}


@end
