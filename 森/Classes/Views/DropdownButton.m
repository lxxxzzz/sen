//
//  DropdownButton.m
//  森
//
//  Created by Lee on 2017/7/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "DropdownButton.h"
#import <Masonry.h>

@interface DropdownButton ()
@property (nonatomic, strong) UIView *backView;

@end

@implementation DropdownButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.indicatorImage];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backView.mas_left);
            make.top.mas_equalTo(self.backView.mas_top);
            make.bottom.mas_equalTo(self.backView.mas_bottom);
            make.right.mas_equalTo(self.indicatorImage.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.backView.mas_centerY);
        }];
        [self.indicatorImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.backView.mas_centerY);
            make.right.mas_equalTo(self.backView.mas_right);
        }];
        
        [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)onClick {
    self.selected = !self.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(dropdownButton:didSelect:)]) {
        [self.delegate dropdownButton:self didSelect:self.isSelected];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorImage.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            self.titleLabel.textColor = HEX(@"#178FE6");
            self.indicatorImage.image = IMAGE(@"up_1");
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorImage.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.titleLabel.textColor = HEX(@"#313133");
            self.indicatorImage.image = IMAGE(@"down");
        }];
    }
}

- (UIImageView *)indicatorImage {
    if (_indicatorImage == nil) {
        _indicatorImage = [[UIImageView alloc] init];
        _indicatorImage.image = IMAGE(@"down");
        _indicatorImage.userInteractionEnabled = NO;
    }
    return _indicatorImage;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
        _titleLabel.userInteractionEnabled = NO;
        
    }
    return _titleLabel;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.userInteractionEnabled = NO;
    }
    return _backView;
}

@end
