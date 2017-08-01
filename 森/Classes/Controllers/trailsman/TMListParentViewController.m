//
//  TMListParentViewController.m
//  森
//
//  Created by Lee on 2017/5/16.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "TMListParentViewController.h"
#import "TMCustomerListViewController.h"
#import "DrawerViewController.h"
#import "Dropdown.h"
#import "TMCheckCustomerViewController.h"
#import "DJListViewController.h"
#import "CheckDajianViewController.h"

#import "UIBarButtonItem+Extension.h"


@interface TMListParentViewController () <DropdownDelegate>


@end

@implementation TMListParentViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupChildVc];

    [self setupNavigationItem];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - Override

#pragma mark - 私有方法
- (void)setupNavigationItem {
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"客资信息", @"搭建信息"]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(selectItemAtIndex:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    self.segmentedControl = segmentedControl;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"icons_adding_white" highImageName:@"icons_adding_white" target:self action:@selector(addCustomer)];
}

- (void)setupChildVc {
    TMCustomerListViewController *listVc = [[TMCustomerListViewController alloc] init];
    [self addChildViewController:listVc];

    DJListViewController *dajianVc = [[DJListViewController alloc] init];
    [self addChildViewController:dajianVc];
    
    [self setIndex:0];
}

#pragma mark ACTION
#pragma mark Action
- (void)addCustomer {
    Dropdown *dropdown = [[Dropdown alloc] initWithFrame:self.view.bounds];
    dropdown.dataSource = @[@"新建客资信息", @"新建搭建信息"];
    dropdown.delegate = self;
    [dropdown show];
}

- (void)userInfo {
    UINavigationController *nav = (UINavigationController *)self.parentViewController;
    if ([nav.parentViewController isKindOfClass:[DrawerViewController class]]) {
        DrawerViewController *drawerVc = (DrawerViewController *)nav.parentViewController;
        [drawerVc openDrawerWithAnimated:YES completion:nil];
    }
}

- (void)selectItemAtIndex:(UISegmentedControl *)segementedControl {
    [self setIndex:segementedControl.selectedSegmentIndex];
}

- (void)setIndex:(NSInteger)index {
    self.segmentedControl.selectedSegmentIndex = index;
    UIViewController *vc = self.childViewControllers[index];
    CGRect rect = self.view.bounds;
    vc.view.frame = rect;
    [self.view addSubview:vc.view];
}

#pragma mark DropdownDelegate
- (void)dropdown:(Dropdown *)dropdown didSelectIndex:(NSInteger)index {
    if (index == 0) {
        // 新建客资信息
        TMCheckCustomerViewController *checkVc = [[TMCheckCustomerViewController alloc] init];
        [self.navigationController pushViewController:checkVc animated:YES];
        
    } else if (index == 1) {
        CheckDajianViewController *checkVc = [[CheckDajianViewController alloc] init];
        [self.navigationController pushViewController:checkVc animated:YES];
    }
    
    self.segmentedControl.selectedSegmentIndex = index;
}

@end
