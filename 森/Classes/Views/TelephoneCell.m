//
//  TelephoneCell.m
//  森
//
//  Created by Lee on 2017/7/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "TelephoneCell.h"
#import "TelephoneItem.h"
#import <Masonry.h>

@interface TelephoneCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *callButton;
@property (nonatomic, strong) UIView *line1;

@end

static CGFloat const margin = 105;

@implementation TelephoneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.callButton];
        [self.contentView addSubview:self.line1];
        
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(1);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.callButton.mas_left).offset(-20);
        }];
        
        [self.callButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TelephoneCellID";
    TelephoneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TelephoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)call {
    if ([self.delegate respondsToSelector:@selector(telephoneCellDidCalling:)]) {
        [self.delegate telephoneCellDidCalling:self];
    }
}

- (void)setItem:(TelephoneItem *)item {
    _item = item;
    self.titleLabel.text = item.title;
    self.contentLabel.text = item.value;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _contentLabel.textColor = HEX(@"#939399");;
    }
    return _contentLabel;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEX(@"#EFEFF4");
    }
    return _line;
}

- (UIView *)line1 {
    if (_line1 == nil) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = HEX(@"#EBEBF0");
    }
    return _line1;
}

- (UIButton *)callButton {
    if (_callButton == nil) {
        _callButton = [[UIButton alloc] init];
        [_callButton setImage:IMAGE(@"phone") forState:UIControlStateNormal];
        [_callButton addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callButton;
}

@end
