//
//  DropdownButton.h
//  森
//
//  Created by Lee on 2017/7/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropdownButton;
@protocol DropdownButtonDelegate <NSObject>
- (void)dropdownButton:(DropdownButton *)button didSelect:(BOOL)selected;
@end

@interface DropdownButton : UIControl

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *indicatorImage;

@property (nonatomic, weak) id <DropdownButtonDelegate> delegate;

@end
