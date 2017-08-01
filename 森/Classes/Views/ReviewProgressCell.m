//
//  ReviewProgressCell.m
//  森
//
//  Created by Lee on 2017/5/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ReviewProgressCell.h"
#import <Masonry.h>

@interface ReviewProgressCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ReviewProgressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.button];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        }];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ReviewProgressCell";
    ReviewProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ReviewProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)buttonOnClick {
    if ([self.delegate respondsToSelector:@selector(reviewProgressButtonDidClick:)]) {
        [self.delegate reviewProgressButtonDidClick:self];
    }
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.label.text = content;
}

- (void)setShowButton:(BOOL)showButton {
    _showButton = showButton;
//    if (showButton) {
//        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
//            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
//            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
//        }];
//        
//        [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.label.mas_bottom).offset(10);
//            make.left.mas_equalTo(self.label.mas_left);
//            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
//        }];
//    } else {
//        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
//            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
//            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
//            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
//        }];
//        
//        [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
//        }];
//    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _label.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
        _label.numberOfLines = 0;
    }
    return _label;
}

- (UIButton *)button {
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = FONT(14);
        [_button setTitle:@"修改并重新提交" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithRed:0/255.0 green:118/255.0 blue:255/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
