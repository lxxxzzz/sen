//
//  DateKeyboardView.h
//  森
//
//  Created by Lee on 17/4/9.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateKeyboardView : UIControl

@property (nonatomic, copy) void(^didSelectDate)(NSDate *date);
- (void)show;
- (void)hidden;

@end
