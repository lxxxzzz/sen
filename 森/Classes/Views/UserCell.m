//
//  UserCell.m
//  森
//
//  Created by Lee on 17/4/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "UserCell.h"
#import "UserItem.h"
#import <Masonry.h>

@interface UserCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation UserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];

        self.contentView.backgroundColor = HEX(@"#F5F5FA");
    }
    return self;
}

- (void)setupSubviews {
    UIView *container = [[UIView alloc] init];
    [self.contentView addSubview:container];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(container.mas_left);
//        make.centerY.mas_equalTo(container.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
//        make.top.mas_equalTo(container.mas_top);
//        make.bottom.mas_equalTo(container.mas_bottom);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"userCell";
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setUserItem:(UserItem *)userItem {
    _userItem = userItem;
    
    self.titleLabel.text = userItem.title;
    self.icon.image = IMAGE(userItem.image);
}

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titleLabel.textColor = HEX(@"#626266");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
