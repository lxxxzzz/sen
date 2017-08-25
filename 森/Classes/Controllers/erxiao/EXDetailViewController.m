//
//  EXDetailViewController.m
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "EXDetailViewController.h"
#import "EXPayListViewController.h"
#import "EXSignViewController.h"
#import "EXUpdatePayDateViewController.h"

@interface EXDetailViewController ()

@property (nonatomic, weak) UIButton *footerButton;
@property (nonatomic, weak) ArrowItem *handleItem;
@property (nonatomic, weak) TextViewItem *remarkItem;
@property (nonatomic, weak) ArrowItem *nextItem;
@property (nonatomic, weak) BaseItem *oldTimeItem;

@property (nonatomic, assign) NSTimeInterval sign_using_time; // 尾款时间
@property (nonatomic, assign) NSTimeInterval next_pay_time; // 中款时间

@end

@implementation EXDetailViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self setupNavigationItem];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(45, 0, SCREEN_WIDTH - 90, 50)];
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    button.backgroundColor = HEX(@"#178FE6");
    [button setTitleColor:HEX(@"#FFFFFF") forState:UIControlStateNormal];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.footerButton = button;
    [footer addSubview:button];
    button.hidden = YES;
    self.tableView.tableFooterView = footer;
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - Override

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"付款记录" target:self action:@selector(paylist)];
    self.navigationItem.title = @"搭建详情";
}

#pragma mark ACTION
- (void)paylist {
    EXPayListViewController *paylistVc = [[EXPayListViewController alloc] init];
    paylistVc.order_id = self.order.customerId;
    [self.navigationController pushViewController:paylistVc animated:YES];
}

#pragma mark 网络请求
- (void)submit {
    if ([self.handleItem.value isEqualToString:@"4"]) {
        // 更改尾款时间
        EXUpdatePayDateViewController *updateVc = [[EXUpdatePayDateViewController alloc] init];
        updateVc.oldTime = self.sign_using_time;
        updateVc.order_id = self.order.customerId;
        updateVc.editable = YES;
        [self.navigationController pushViewController:updateVc animated:YES];
    } else {
        // 跳转到签单页面
        EXSignViewController *signingVc = [[EXSignViewController alloc] init];
        signingVc.order = self.order;
        signingVc.editable = YES;
        signingVc.sign_type = self.handleItem.value;
        [self.navigationController pushViewController:signingVc animated:YES];
    }
}

- (void)subHeaderOnClick {
    if (self.subHeaderAction) {
        self.subHeaderAction();
    }
}

#pragma mark 网络请求
- (void)keziOrderFollowWithParameters:(NSDictionary *)parameters {
    __weak typeof(self) weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=dajianOrderFollow&debug=1", HOST];
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        if (result.success) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }
    } failure:^(NSError *error) {
        Log(@"%@",error);
    }];
}

- (void)loadData {
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=orderDaJianDetail&debug=1", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = TOKEN;
    parameters[@"order_id"] = self.order.customerId;
    @weakObj(self)
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        @strongObj(self)
        [SVProgressHUD dismiss];
        if (result.success) {
            NSDictionary *dict = result.data[@"order_item"];
            ItemGroup *group1 = [[ItemGroup alloc] init];
            NSTimeInterval use_date = [dict[@"use_date"] doubleValue];
            NSString *strDate = nil;
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"yyyy-MM-dd";
            if (use_date > 0) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:use_date];
                strDate = [fmt stringFromDate:date];
            }
            group1.items = @[[BaseItem itemWithTitle:@"姓名" value:dict[@"customer_name"] required:NO],
                             [BaseItem itemWithTitle:@"类型" value:@"布展" required:NO],
                             [TelephoneItem itemWithTitle:@"手机号" value:dict[@"order_phone"] click:^{
                                 NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"tel:%@",dict[@"order_phone"]];
                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                             }],
                             [BaseItem itemWithTitle:@"区域" value:dict[@"order_area_hotel_name"] required:YES],
                             [BaseItem itemWithTitle:@"预算" value:dict[@"order_money"] required:NO],
                             [BaseItem itemWithTitle:@"时间" value:strDate required:NO],
                             [BaseItem itemWithTitle:@"备注" value:dict[@"order_desc"] required:NO]];
            ItemGroup *group2 = [[ItemGroup alloc] init];
            __weak typeof(self) weakSelf = self;
            
            TextViewItem *remarkItem = [TextViewItem itemWithTitle:@"备注" value:@"" placeholder:@"请填写备注信息" height:88 required:NO];
            remarkItem.maxLength = 500;
            self.remarkItem = remarkItem;
            
            self.sign_using_time = [result.data[@"sign_using_time"] doubleValue];
            self.next_pay_time = [result.data[@"next_pay_time"] doubleValue];
            
            if (self.order.order_status == 1) {
                // 待处理
                self.footerButton.hidden = NO;
                group2.header = @"款项跟进";
                
                //1 中款 2尾款 3附加款 4尾款时间 5首款
                Option *option1 = [Option optionWithTitle:@"中款支付" value:@"1"];
                Option *option2 = [Option optionWithTitle:@"尾款支付" value:@"2"];
                Option *option3 = [Option optionWithTitle:@"附加款支付" value:@"3"];
                Option *option4 = [Option optionWithTitle:@"申请更改举办时间" value:@"4"];
                
                NSArray *dataSource;
                // 判断中款是否已支付
                NSInteger finish_middle = [result.data[@"finish_middle"] integerValue];
                if (finish_middle == 1) {
                    // 中款已经支付过了
                    dataSource = @[option2, option3, option4];
                } else {
                    // 未支付过中款
                    dataSource = @[option1, option3, option4];
                }
                
                Option *option = [dataSource firstObject];
                ArrowItem *handleItem = [ArrowItem itemWithTitle:@"操作" subTitle:nil required:NO];
                handleItem.textAlignment = NSTextAlignmentLeft;
                handleItem.subTitle = option.title;
                handleItem.value = option.value;
                
                BaseItem *oldTimeItem = [BaseItem itemWithTitle:@"原定时间" value:nil required:NO];
                if ([option.value isEqualToString:@"1"]) { // 默认不选的时间
                    oldTimeItem.value = [NSString stringWithTimeInterval:self.next_pay_time format:@"yyyy-MM-dd"];
                } else {
                    oldTimeItem.value = [NSString stringWithTimeInterval:self.sign_using_time format:@"yyyy-MM-dd"];
                }
                
                self.handleItem = handleItem;
                __weak typeof(handleItem) weakhandleItem = handleItem;
                handleItem.task = ^{
                    weakSelf.keyboardView.dataSource = dataSource;
                    [weakSelf.keyboardView show];
                    weakSelf.keyboardView.didFinishBlock = ^(Option *option){
                        weakhandleItem.subTitle = option.title;
                        weakhandleItem.value = option.value;
                        if ([option.value isEqualToString:@"1"]) {
                            // 中款支付
                            oldTimeItem.value = [NSString stringWithTimeInterval:self.next_pay_time format:@"yyyy-MM-dd"];
                            group2.items = @[weakhandleItem, oldTimeItem];
                        } else if ([option.value isEqualToString:@"2"]) {
                            // 尾款支付
                            oldTimeItem.value = [NSString stringWithTimeInterval:self.sign_using_time format:@"yyyy-MM-dd"];
                            group2.items = @[weakhandleItem, oldTimeItem];
                        } else if ([option.value isEqualToString:@"3"]) {
                            // 附加款
                            group2.items = @[weakhandleItem];
                            
                        } else if ([option.value isEqualToString:@"4"]) {
                            // 申请更改尾款时间
                            group2.items = @[weakhandleItem];
                        }
                        [weakSelf.tableView reloadData];
                    };
                };
                
                group2.items = @[handleItem, oldTimeItem];
            } else if (self.order.order_status == 5) {
                // 已驳回
                self.footerButton.hidden = YES;
                group2.header = @"审核进度";
                BaseItem *item = [BaseItem itemWithTitle:result.data[@"handle_note"]];
                group2.items = @[item];
                group2.subHeader = @"修改并重新提交";
                group2.subHeaderAction = ^{
                    if (self.order.erxiao_sign_type == 4) {
                        // 修改尾款时间
                        EXUpdatePayDateViewController *updateVc = [[EXUpdatePayDateViewController alloc] init];
                        updateVc.order_id = self.order.customerId;
                        updateVc.oldTime = self.sign_using_time;
                        updateVc.editable = YES;
                        [self.navigationController pushViewController:updateVc animated:YES];
                    } else {
                        EXSignViewController *signingVc = [[EXSignViewController alloc] init];
                        signingVc.order = weakSelf.order;
                        signingVc.editable = YES;
                        signingVc.sign_type = [NSString stringWithFormat:@"%ld", self.order.erxiao_sign_type];
                        [weakSelf.navigationController pushViewController:signingVc animated:YES];
                    }
                };
            }  else {
                self.footerButton.hidden = YES;
                group2.header = @"审核进度";
                BaseItem *item = [BaseItem itemWithTitle:result.data[@"handle_note"]];
                group2.items = @[item];
            }
            
            self.dataSource = @[group1, group2];
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

#pragma mark MultiCellDelegate
- (void)multiCell:(UITableViewCell *)cell valueDidChange:(id)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ItemGroup *group = self.dataSource[indexPath.section];
    BaseItem *item = group.items[indexPath.row];
    
    if ([item isKindOfClass:[ButtonItem class]]) {
        ButtonItem *buttonItem = (ButtonItem *)item;
        if (buttonItem.click) {
            buttonItem.click();
        }
    }
}

#pragma mark MultiCellDelegate
- (void)multiCellTextFieldBecomeFirstResponder:(MultiCell *)cell {
    self.firstResponderCell = cell;
}

#pragma mark - setter and getter
#pragma mark setter


@end
