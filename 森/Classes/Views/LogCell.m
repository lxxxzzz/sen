//
//  LogCell.m
//  森
//
//  Created by Lee on 2017/4/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "LogCell.h"
#import "Log.h"
#import "NSString+Extension.h"
#import <Masonry.h>

@interface LogCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleDateLabel;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UILabel *remarkTitleLabel;
@property (nonatomic, strong) UILabel *remarkContentLabel;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UILabel *remarkDateTitleLabel;
@property (nonatomic, strong) UILabel *remarkDateValueLabel;

@end

@implementation LogCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.titleDateLabel];
    [self.contentView addSubview:self.remarkTitleLabel];
    [self.contentView addSubview:self.remarkContentLabel];
    [self.contentView addSubview:self.remarkDateTitleLabel];
    [self.contentView addSubview:self.remarkDateValueLabel];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.line2];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_equalTo(80);
    }];
    
    [self.remarkTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line1.mas_left);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(15);
        make.width.mas_equalTo(self.titleLabel.mas_width);
    }];
    
    [self.remarkDateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line2.mas_left);
        make.top.mas_equalTo(self.line2.mas_bottom).offset(15);
        make.width.mas_equalTo(self.titleLabel.mas_width);
    }];
    
    [self.titleDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_top);
        make.left.mas_equalTo(self.remarkContentLabel.mas_left);
        
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
    

    
    [self.remarkContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.remarkTitleLabel.mas_right).offset(10);
        make.top.mas_equalTo(self.remarkTitleLabel.mas_top);
        make.right.mas_equalTo(self.line1.mas_right);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line1.mas_left);
        make.height.mas_equalTo(self.line1.mas_height);
        make.right.mas_equalTo(self.line1.mas_right);
        make.top.mas_equalTo(self.remarkTitleLabel.mas_bottom).offset(15);
    }];
    

    
    [self.remarkDateValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.remarkContentLabel.mas_left);
        make.top.mas_equalTo(self.remarkDateTitleLabel.mas_top);
        make.right.mas_equalTo(self.line2.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
    }];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"logCell";
    LogCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setLog:(Log *)log {
    _log = log;
    self.titleLabel.text = log.title;
    if (log.order_follow_time) self.titleDateLabel.text = [NSString stringWithTimeInterval:log.order_follow_time format:@"yyyy-MM-dd"];
    self.remarkContentLabel.text = log.order_follow_desc;
    self.remarkDateValueLabel.text = [NSString stringWithTimeInterval:log.order_follow_create_time format:@"yyyy-MM-dd hh:mm:ss"];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _titleLabel;
}

- (UILabel *)titleDateLabel {
    if (_titleDateLabel == nil) {
        _titleDateLabel = [[UILabel alloc] init];
        _titleDateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleDateLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _titleDateLabel;
}

- (UILabel *)remarkTitleLabel {
    if (_remarkTitleLabel == nil) {
        _remarkTitleLabel = [[UILabel alloc] init];
        _remarkTitleLabel.text = @"备注内容";
        _remarkTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _remarkTitleLabel.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _remarkTitleLabel;
}

- (UILabel *)remarkContentLabel {
    if (_remarkContentLabel == nil) {
        _remarkContentLabel = [[UILabel alloc] init];
        _remarkContentLabel.numberOfLines = 0;
        _remarkContentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _remarkContentLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _remarkContentLabel;
}

- (UILabel *)remarkDateTitleLabel {
    if (_remarkDateTitleLabel == nil) {
        _remarkDateTitleLabel = [[UILabel alloc] init];
        _remarkDateTitleLabel.text = @"备注时间";
        _remarkDateTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _remarkDateTitleLabel.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _remarkDateTitleLabel;
}

- (UILabel *)remarkDateValueLabel {
    if (_remarkDateValueLabel == nil) {
        _remarkDateValueLabel = [[UILabel alloc] init];
        _remarkDateValueLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _remarkDateValueLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _remarkDateValueLabel;
}

- (UIView *)line1 {
    if (_line1 == nil) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    }
    return _line1;
}

- (UIView *)line2 {
    if (_line2 == nil) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    }
    return _line2;
}

@end
