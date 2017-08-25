//
//  EXUpdatePayDateViewController.m
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "EXUpdatePayDateViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "NSString+Extension.h"
#import "EXListViewController.h"

@interface EXUpdatePayDateViewController ()

@property (nonatomic, strong) BaseItem *timeItem;
@property (nonatomic, strong) BaseItem *oldTimeItem;

@end

@implementation EXUpdatePayDateViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationItem];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    __weak typeof(self) weakSelf = self;
    ItemGroup *group = [[ItemGroup alloc] init];
    group.header = @"申请时间";

    if (self.editable) {
        ArrowItem *timeItem = [ArrowItem itemWithTitle:@"申请时间" subTitle:nil required:NO];
        timeItem.placeholder = @"请选择申请时间";
        __weak typeof(timeItem) weakNewTimeItem = timeItem;
        timeItem.task = ^{
            [weakSelf.dateKeyboardView show];
            weakSelf.dateKeyboardView.didSelectDate = ^(NSDate *date){
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"YYYY-MM-dd";
                weakNewTimeItem.subTitle = [dateFormatter stringFromDate:date];//该方法用于从日期对象返回日期字符串
                weakNewTimeItem.value = [NSString stringWithFormat:@"%d",(int)[date timeIntervalSince1970]];
                [weakSelf.tableView reloadData];
            };
        };
        self.timeItem = timeItem;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(45, 0, SCREEN_WIDTH - 90, 50)];
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.backgroundColor = HEX(@"#178FE6");
        [button setTitleColor:HEX(@"#FFFFFF") forState:UIControlStateNormal];
        [button setTitle:@"提交审核" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:button];
        self.tableView.tableFooterView = footer;
        
    } else {
        self.timeItem = [BaseItem itemWithTitle:@"申请时间" value:@(self.oldTime) required:NO];
    }
    
    [self loadData];
    
    NSString *oldDate = [NSString stringWithTimeInterval:self.oldTime format:@"yyyy-MM-dd"];
    self.oldTimeItem = [BaseItem itemWithTitle:@"原时间" value:oldDate required:NO];
    
    group.items = @[
                    self.oldTimeItem,
                    self.timeItem
                    ];
    self.dataSource = @[group];
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - Override

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.title = @"申请修改举办时间";
}

- (void)loadData {
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=dajianOrderOtherSignDetail&debug=1", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = TOKEN;
    parameters[@"user_dajian_order_id"] = self.order_id;
    @weakObj(self)
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        @strongObj(self)
        if (result.success) {
            if ([result.data isKindOfClass:[NSDictionary class]]) {
                
//                NSTimeInterval first_input_content = [result.data[@"first_input_content"] doubleValue];
//                self.oldTimeItem.value = [NSString stringWithTimeInterval:first_input_content format:@"yyyy-MM-dd"];
                
                if (self.oldTime == 0) {
                    self.oldTimeItem.value = result.data[@"first_input_content"];
                }
               
                NSTimeInterval second_input_content = [result.data[@"second_input_content"] doubleValue];
                self.timeItem.value = [NSString stringWithTimeInterval:second_input_content format:@"yyyy-MM-dd"];
                
                
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark Action
- (void)submit {
    if (self.timeItem.value == nil || self.timeItem.value == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择申请时间"];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=dajianOrderSignOther&debug=1", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = TOKEN;
    // 4是修改尾款时间
    parameters[@"sign_type"] = @"4";
    parameters[@"user_dajian_order_id"] = self.order_id;
    parameters[@"order_time"] = @([self.timeItem.value integerValue]);
    Log(@"%@   \n%@",parameters, url);
    @weakObj(self);
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        @strongObj(self)
        if (result.success) {
            [SVProgressHUD showSuccessWithStatus:@"签单成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *controllers = self.navigationController.viewControllers;
                UIViewController *popVc;
                for (UIViewController *vc in controllers) {
                    if ([vc isKindOfClass:[EXListViewController class]]) {
                        popVc = vc;
                        break;
                    }
                }
                if (popVc) {
                    [self.navigationController popToViewController:popVc animated:YES];
                } else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            });
        } else {
            [SVProgressHUD showErrorWithStatus:@"签单失败"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}



@end
