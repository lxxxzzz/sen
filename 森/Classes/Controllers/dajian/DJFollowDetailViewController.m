//
//  DJFollowDetailViewController.m
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "DJFollowDetailViewController.h"
#import "LogViewController.h"
#import "DJSignViewController.h"
#import "DJLogViewController.h"
#import "BaseParentOrderListViewController.h"

@interface DJFollowDetailViewController ()

@property (nonatomic, weak) UIButton *footerButton;
@property (nonatomic, weak) ArrowItem *typeItem;
@property (nonatomic, weak) TextViewItem *remarkItem;
@property (nonatomic, weak) ArrowItem *nextItem;
//@property (nonatomic, weak) MultiCell *firstResponderCell;

@end

@implementation DJFollowDetailViewController

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
    [button setTitle:@"提交凭证" forState:UIControlStateNormal];
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
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"跟进日志" target:self action:@selector(log)];
    self.navigationItem.title = @"搭建详情";
}

#pragma mark ACTION
- (void)log {
    DJLogViewController *logVc = [[DJLogViewController alloc] init];
    logVc.order_id = self.order.customerId;
    [self.navigationController pushViewController:logVc animated:YES];
}

#pragma mark 网络请求
- (void)submit {
    if ([self.typeItem.value isEqualToString:@"1"]) {
        // 确认签单
        DJSignViewController *signingVc = [[DJSignViewController alloc] init];
        signingVc.editable = YES;
        signingVc.order = self.order;
        [self.navigationController pushViewController:signingVc animated:YES];
    } else if ([self.typeItem.value isEqualToString:@"2"]) {
        // 信息有效
        if (self.remarkItem.value == nil || [self.remarkItem.value length] == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写备注信息"];
            return;
        }
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"access_token"] = TOKEN;
        parameters[@"user_dajian_order_id"] = self.order.customerId;
        parameters[@"user_order_status"] = @"1";
        parameters[@"follow_time"] = [NSString stringWithFormat:@"%ld",(int)[NSDate date].timeIntervalSince1970 + [self.nextItem.value integerValue] * 24 * 60 * 60];
        parameters[@"follow_desc"] = self.remarkItem.value;
        [self keziOrderFollowWithParameters:parameters];
    } else if ([self.typeItem.value isEqualToString:@"3"]) {
        // 信息无效
        if (self.remarkItem.value == nil || [self.remarkItem.value length] == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写备注信息"];
            return;
        }
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"access_token"] = TOKEN;
        parameters[@"user_dajian_order_id"] = self.order.customerId;
        parameters[@"user_order_status"] = @"2";
        parameters[@"follow_time"] = @([NSDate date].timeIntervalSince1970);
        parameters[@"follow_desc"] = self.remarkItem.value;
        [self keziOrderFollowWithParameters:parameters];
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
                if ([parameters[@"user_order_status"] isEqualToString:@"2"]) {
                    // 信息无效时，返回默认选择到已取消
                    NSArray *controllers = self.navigationController.viewControllers;
                    BaseParentOrderListViewController *listVc;
                    for (UIViewController *vc in controllers) {
                        if ([vc isKindOfClass:[BaseParentOrderListViewController class]]) {
                            listVc = (BaseParentOrderListViewController *)vc;
                            break;
                        }
                    }
                    // 5是已取消
                    listVc.segmentControl.selectedIndex = 5;
                }
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
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        [SVProgressHUD dismiss];
        if (result.success) {
            NSDictionary *dict = result.data[@"order_item"];
            ItemGroup *group1 = [[ItemGroup alloc] init];
            NSTimeInterval use_date = [dict[@"use_date"] doubleValue];
            NSString *strDate = nil;
            if (use_date > 0) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dict[@"use_date"] doubleValue]];
                NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
                fmt.dateFormat = @"yyyy-MM-dd";
                strDate = [fmt stringFromDate:date];
            }
            
            group1.items = @[[BaseItem itemWithTitle:@"姓名" value:dict[@"customer_name"] required:NO],
                             [BaseItem itemWithTitle:@"类型" value:@"布展" required:NO],
//                             [BaseItem itemWithTitle:@"类型" value:dict[@"order_type"] required:NO],
                             [TelephoneItem itemWithTitle:@"手机号" value:dict[@"order_phone"] click:^{
                                 NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"tel:%@",dict[@"order_phone"]];
                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                             }],
                             [BaseItem itemWithTitle:@"区域" value:dict[@"order_area_hotel_name"] required:NO],
                             [BaseItem itemWithTitle:@"预算" value:dict[@"order_money"] required:NO],
                             [BaseItem itemWithTitle:@"时间" value:strDate required:NO],
                             [BaseItem itemWithTitle:@"备注" value:dict[@"order_desc"] required:NO]];
            ItemGroup *group2 = [[ItemGroup alloc] init];
            __weak typeof(self) weakSelf = self;
            
            TextViewItem *remarkItem = [TextViewItem itemWithTitle:@"备注" value:@"" placeholder:@"请填写备注信息" height:88 required:YES];
            remarkItem.maxLength = 500;
            self.remarkItem = remarkItem;
            
            if (self.order.order_status == 1) {
                // 待处理
                self.footerButton.hidden = NO;
                group2.header = @"信息跟进";
                
                ArrowItem *nextItem = [ArrowItem itemWithTitle:@"下次跟进" subTitle:nil required:NO];
                
                
                NSMutableArray <Option *>*options = [NSMutableArray array];
                for (int i=1; i<=30; i++) {
                    NSString *title = [NSString stringWithFormat:@"%d天后", i];
                    NSString *value = [NSString stringWithFormat:@"%d", i];
                    Option *option = [Option optionWithTitle:title value:value];
                    [options addObject:option];
                }
                
                /*
                Option *nextOption1 = [Option optionWithTitle:@"1天后" value:@"1"];
                Option *nextOption2 = [Option optionWithTitle:@"2天后" value:@"2"];
                Option *nextOption3 = [Option optionWithTitle:@"3天后" value:@"3"];
                Option *nextOption4 = [Option optionWithTitle:@"4天后" value:@"4"];
                Option *nextOption5 = [Option optionWithTitle:@"5天后" value:@"5"];
                Option *nextOption6 = [Option optionWithTitle:@"6天后" value:@"6"];
                Option *nextOption7 = [Option optionWithTitle:@"7天后" value:@"7"];
                Option *nextOption8 = [Option optionWithTitle:@"8天后" value:@"8"];
                Option *nextOption9 = [Option optionWithTitle:@"9天后" value:@"9"];
                Option *nextOption10 = [Option optionWithTitle:@"10天后" value:@"10"];
                 */
                nextItem.subTitle = [options firstObject].title;
                nextItem.value = [options firstObject].value;
                nextItem.textAlignment = NSTextAlignmentRight;
                self.nextItem = nextItem;
                __weak typeof(nextItem) weaknext = nextItem;
                nextItem.task = ^{
                    weakSelf.keyboardView.dataSource = options;
                    [weakSelf.keyboardView show];
                    weakSelf.keyboardView.didFinishBlock = ^(Option *option){
                        weaknext.subTitle = option.title;
                        weaknext.value = option.value;
                        [weakSelf.tableView reloadData];
                    };
                };
                
                ArrowItem *typeItem = [ArrowItem itemWithTitle:@"类型" subTitle:nil required:NO];
                Option *option1 = [Option optionWithTitle:@"确认签单" value:@"1"];
                Option *option2 = [Option optionWithTitle:@"信息有效" value:@"2"];
                Option *option3 = [Option optionWithTitle:@"信息无效" value:@"3"];
                typeItem.subTitle = option1.title;
                typeItem.value = option1.value;
                typeItem.textAlignment = NSTextAlignmentRight;
                
                self.typeItem = typeItem;
                __weak typeof(typeItem) weaktype = typeItem;
                typeItem.task = ^{
                    weakSelf.keyboardView.dataSource = @[option1, option2, option3];
                    [weakSelf.keyboardView show];
                    weakSelf.keyboardView.didFinishBlock = ^(Option *option){
                        weaktype.subTitle = option.title;
                        weaktype.value = option.value;
                        if ([option.value isEqualToString:@"1"]) {
                            // 确认签单
                            group2.items = @[weaktype];
                            [weakSelf.footerButton setTitle:@"提交凭证" forState:UIControlStateNormal];
                        } else if ([option.value isEqualToString:@"2"]) {
                            // 信息有效
                            group2.items = @[weaktype, nextItem, remarkItem];
                            [weakSelf.footerButton setTitle:@"提交" forState:UIControlStateNormal];
                        } else if ([option.value isEqualToString:@"3"]) {
                            // 信息无效
                            group2.items = @[weaktype, remarkItem];
                            [weakSelf.footerButton setTitle:@"提交" forState:UIControlStateNormal];
                        }
                        [weakSelf.tableView reloadData];
                    };
                };
                
                group2.items = @[typeItem];
            } else if (self.order.order_status == 2) {
                // 待审核
                self.footerButton.hidden = YES;
                group2.header = @"审核进度";
                BaseItem *item = [BaseItem itemWithTitle:result.data[@"handle_note"]];
                group2.items = @[item];
            } else if (self.order.order_status == 3) {
                // 待结算
                self.footerButton.hidden = YES;
                group2.header = @"审核进度";
                BaseItem *item = [BaseItem itemWithTitle:result.data[@"handle_note"]];
                group2.items = @[item];
            } else if (self.order.order_status == 4) {
                // 已结算
                self.footerButton.hidden = YES;
                group2.header = @"审核进度";
                BaseItem *item = [BaseItem itemWithTitle:result.data[@"handle_note"]];
                group2.items = @[item];
            } else if (self.order.order_status == 5) {
                // 已驳回
                self.footerButton.hidden = YES;
                group2.header = @"审核进度";
                BaseItem *item = [BaseItem itemWithTitle:result.data[@"handle_note"]];
                group2.items = @[item];
                group2.subHeader = @"修改并重新提交";
                group2.subHeaderAction = ^{
                    DJSignViewController *signingVc = [[DJSignViewController alloc] init];
                    signingVc.editable = YES;
                    signingVc.order = self.order;
                    [weakSelf.navigationController pushViewController:signingVc animated:YES];
                };
            } else if (self.order.order_status == 6) {
                // 已取消
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
- (void)setTypeItem:(ArrowItem *)typeItem {
    _typeItem = typeItem;
    
    if ([typeItem.value isEqualToString:@"1"]) {
        [self.footerButton setTitle:@"提交凭证" forState:UIControlStateNormal];
    } else if ([typeItem.value isEqualToString:@"2"]) {
        [self.footerButton setTitle:@"提交" forState:UIControlStateNormal];
    } else if ([typeItem.value isEqualToString:@"3"]) {
        [self.footerButton setTitle:@"提交" forState:UIControlStateNormal];
    }
}

@end
