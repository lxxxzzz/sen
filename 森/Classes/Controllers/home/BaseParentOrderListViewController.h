//
//  BaseParentOrderListViewController.h
//  森
//
//  Created by Lee on 2017/6/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentControl.h"
#import "Order.h"
#import "EXDetailViewController.h"
#import "EXDetailParentViewController.h"
#import "BaseOrderListViewController.h"
#import "SegmentControl.h"
#import "RefreshView.h"

@protocol BaseParentOrderListViewControllerProtocol <NSObject>

@required
- (void)loadDataWithStatus:(NSString *)status completion:(void(^)(NSArray *orders))completion;
- (void)loadNewDataWithStatus:(NSString *)status orderPage:(NSInteger)page success:(void(^)(NSArray *orders, NSInteger maxCount))success failure:(void(^)())failure;

@end

@interface BaseParentOrderListViewController : UIViewController <UIScrollViewDelegate, SegmentControlDelegate, BaseOrderListViewControllerDelegate, BaseParentOrderListViewControllerProtocol>

@property (nonatomic, strong) SegmentControl *segmentControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) NSArray <NSString *>*titles;
@property (nonatomic, copy) void(^backAction)();
@property (nonatomic, copy) void(^willAppearAction)();

- (void)reloadData;

@end
