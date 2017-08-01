//
//  SelectCell.m
//  森
//
//  Created by Lee on 17/4/9.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "SelectCell.h"
#import "Option.h"
#import <Masonry.h>

@interface SelectCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *indicator;
@property (nonatomic, strong) UIView *line;

@end

@implementation SelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.indicator];
        [self.contentView addSubview:self.line];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-27);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SelectCell";
    SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setOption:(Option *)option {
    _option = option;
    
    self.titleLabel.text = option.title;
    self.indicator.hidden = !option.isSelected;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _titleLabel;
}

- (UIImageView *)indicator {
    if (_indicator == nil) {
        _indicator = [[UIImageView alloc] init];
        _indicator.image = IMAGE(@"icon-checkmark");
    }
    return _indicator;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEX(@"#EBEBF0");
    }
    return _line;
}

@end
