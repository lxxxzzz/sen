//
//  EXDetailParentViewController.m
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "EXDetailParentViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "Order.h"
#import "LogViewController.h"
#import "EXDetailViewController.h"
#import "EXSignViewController.h"
#import "EXUpdatePayDateViewController.h"
#import "EXPayListViewController.h"

@interface EXDetailParentViewController ()

@end

@implementation EXDetailParentViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupChildVc];
    
    [self setupNavigationItem];
    
    Log(@"%@",TOKEN);
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - Override

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"付款记录" target:self action:@selector(paylist)];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"搭建详情", @"合同审核"]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(selectItemAtIndex:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    [self selectItemAtIndex:segmentedControl];
    
}

- (void)setupChildVc {
    EXDetailViewController *detailVc = [[EXDetailViewController alloc] init];
    detailVc.order = self.order;
    [self addChildViewController:detailVc];
    
    if (self.order.erxiao_sign_type == 4) {
        // 修改尾款时间
        EXUpdatePayDateViewController *updateVc = [[EXUpdatePayDateViewController alloc] init];
        updateVc.order_id = self.order.customerId;
        updateVc.editable = NO;
        [self addChildViewController:updateVc];
    } else {
        // 其他
        EXSignViewController *signingVc = [[EXSignViewController alloc] init];
        signingVc.editable = NO;
        signingVc.order = self.order;
        [self addChildViewController:signingVc];
    }
    
}

#pragma mark ACTION
- (void)paylist {
    EXPayListViewController *paylistVc = [[EXPayListViewController alloc] init];
    paylistVc.order_id = self.order.customerId;
    [self.navigationController pushViewController:paylistVc animated:YES];
}

- (void)selectItemAtIndex:(UISegmentedControl *)segementedControl {
    UIViewController *vc = self.childViewControllers[segementedControl.selectedSegmentIndex];
    CGRect rect = self.view.bounds;
    rect.origin.y = 0;
    vc.view.frame = rect;
    [self.view addSubview:vc.view];
}


@end
