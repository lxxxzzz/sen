//
//  KeyboardView.h
//  森
//
//  Created by Lee on 17/4/7.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Option;

@interface KeyboardView : UIControl

@property (nonatomic, strong) NSArray <Option *>*dataSource;
@property (nonatomic, copy) void(^didFinishBlock)(Option *option);
@property (nonatomic, strong) Option *selectedOption;
- (void)show;
- (void)hidden;

@end
