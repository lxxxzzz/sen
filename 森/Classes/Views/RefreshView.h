//
//  RefreshView.h
//  森
//
//  Created by Lee on 2017/6/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RefreshView;
@protocol RefreshViewDelegate <NSObject>

@required
- (void)refreshViewDidClick:(RefreshView *)refreshView;

@end

@interface RefreshView : UIControl

@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) id <RefreshViewDelegate> delegate;
@property (nonatomic, copy) void(^onClickBlock)();
+ (instancetype)refreshView;
- (void)endRefresh;

@end
