//
//  SegmentControl.h
//  森
//
//  Created by Lee on 17/3/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SegmentControl;

@protocol SegmentControlDelegate <NSObject>

@optional
- (void)segmentView:(SegmentControl *)segment didSelectIndex:(NSInteger)index;

@end

@interface SegmentControl : UIView

@property (nonatomic, strong) NSArray <NSString *>*titles;
@property (nonatomic, strong) NSDictionary *badgeValue;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGFloat leading;
@property (nonatomic, assign) CGFloat minMargin;
@property (nonatomic, weak) id<SegmentControlDelegate> delegate;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;


@end
