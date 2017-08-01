//
//  GZDetailParentViewController.m
//  森
//
//  Created by Lee on 2017/5/31.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "GZDetailParentViewController.h"

#import "UIBarButtonItem+Extension.h"
#import "Order.h"
#import "LogViewController.h"
#import "GZDetailViewController.h"
#import "OrderSignViewController.h"

@interface GZDetailParentViewController ()

@end

@implementation GZDetailParentViewController

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
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"跟进日志" target:self action:@selector(log)];
    if (self.order.order_status == 0) {
        self.navigationItem.title = @"客资详情";
    } else {
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"客资信息", @"合同审核"]];
        segmentedControl.selectedSegmentIndex = 0;
        [segmentedControl addTarget:self action:@selector(selectItemAtIndex:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = segmentedControl;
        [self selectItemAtIndex:segmentedControl];
    }
}

- (void)setupChildVc {
    GZDetailViewController *detailVc = [[GZDetailViewController alloc] init];
    detailVc.order = self.order;
    [self addChildViewController:detailVc];
    
    OrderSignViewController *signingVc = [[OrderSignViewController alloc] init];
    signingVc.editable = NO;
    signingVc.order = self.order;
    [self addChildViewController:signingVc];
}

#pragma mark ACTION
- (void)log {
    LogViewController *logVc = [[LogViewController alloc] init];
    logVc.order_id = self.order.customerId;
    [self.navigationController pushViewController:logVc animated:YES];
}

- (void)selectItemAtIndex:(UISegmentedControl *)segementedControl {
    UIViewController *vc = self.childViewControllers[segementedControl.selectedSegmentIndex];
    CGRect rect = self.view.bounds;
    rect.origin.y = 0;
    vc.view.frame = rect;
    [self.view addSubview:vc.view];
}

@end
