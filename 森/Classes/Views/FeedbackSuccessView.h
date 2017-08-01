//
//  FeedbackSuccessView.h
//  森
//
//  Created by Lee on 17/4/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeedbackSuccessView;

@protocol FeedbackSuccessViewDelegate <NSObject>

@optional
- (void)feedbackSuccessViewDidClickClose:(FeedbackSuccessView *)view;

@end

@interface FeedbackSuccessView : UIView

@property (nonatomic, weak) id <FeedbackSuccessViewDelegate> delegate;

@end
