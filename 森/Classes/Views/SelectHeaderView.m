//
//  SelectHeaderView.m
//  森
//
//  Created by Lee on 17/4/9.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "SelectHeaderView.h"
#import <Masonry.h>

@interface SelectHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation SelectHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.count = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.countLabel];
        [self addSubview:self.line];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(self.countLabel.mas_right);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }
    return self;
}

- (void)setCount:(NSInteger)count {
    _count = count;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld / 3", count]];
    [str addAttribute:NSForegroundColorAttributeName value:HEX(@"#178FE6") range:NSMakeRange(0, 1)];
    [str addAttribute:NSForegroundColorAttributeName value:HEX(@"#313133") range:NSMakeRange(1, str.length - 1)];
    self.countLabel.attributedText = str;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"已选酒店";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _titleLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _countLabel.textColor = HEX(@"#178FE6");
    }
    return _countLabel;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEX(@"#EBEBF0");
    }
    return _line;
}

@end
