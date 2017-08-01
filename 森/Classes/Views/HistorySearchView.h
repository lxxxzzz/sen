//
//  HistorySearchView.h
//  森
//
//  Created by Lee on 2017/7/30.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HistorySearchView;

@protocol HistorySearchViewDelegate <NSObject>

@optional
- (void)historySearchViewClearHistorySearchKeywords:(HistorySearchView *)view;
- (void)historySearchView:(HistorySearchView *)view selectedKeyword:(NSString *)keyword;

@end

@interface HistorySearchView : UIView

@property (nonatomic, strong) NSArray *keywords;
@property (nonatomic, weak) id <HistorySearchViewDelegate> delegate;

@end
