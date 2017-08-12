//
//  OrderCell.m
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "OrderCell.h"
#import "Order.h"
#import <Masonry.h>

@interface OrderCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *contactsLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *followerLabel;
@property (nonatomic, strong) UILabel *followerNameLabel;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *statusMessageBtn;

@end

@implementation OrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"customerCell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.dateLabel];
    [self.backView addSubview:self.statusLabel];
    [self.backView addSubview:self.line];
    [self.backView addSubview:self.contactsLabel];
    [self.backView addSubview:self.phoneLabel];
    [self.backView addSubview:self.followerLabel];
    [self.backView addSubview:self.followerNameLabel];
    [self.backView addSubview:self.bottomLine];
    [self.backView addSubview:self.statusMessageBtn];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(15);
        make.top.mas_equalTo(self.backView.mas_top).offset(16);
        make.height.mas_equalTo(16);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backView.mas_right).offset(-15);
        make.top.mas_equalTo(self.backView.mas_top).offset(16);
        make.height.mas_equalTo(self.dateLabel.mas_height);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_left);
        make.right.mas_equalTo(self.statusLabel.mas_right);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.dateLabel.mas_bottom).offset(16);
    }];
    
    [self.contactsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_left);
        make.top.mas_equalTo(self.line.mas_bottom).offset(21);
        make.height.mas_equalTo(self.dateLabel.mas_height);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(100);
//        make.left.mas_equalTo(self.contactsLabel.mas_right).offset(49);
        make.top.mas_equalTo(self.contactsLabel.mas_top);
        make.height.mas_equalTo(self.dateLabel.mas_height);
    }];
    
    [self.followerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contactsLabel.mas_left);
        make.top.mas_equalTo(self.contactsLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(self.dateLabel.mas_height);
    }];
    
    [self.followerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneLabel.mas_left);
        make.top.mas_equalTo(self.followerLabel.mas_top);
        make.height.mas_equalTo(self.dateLabel.mas_height);
        make.right.mas_equalTo(self.backView.mas_right).offset(-15);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line.mas_left);
        make.right.mas_equalTo(self.line.mas_right);
        make.height.mas_equalTo(self.line.mas_height);
        make.top.mas_equalTo(self.followerLabel.mas_bottom).offset(20);
    }];
    
    [self.statusMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.followerLabel.mas_left);
        make.top.mas_equalTo(self.bottomLine.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-10);
    }];
}

- (void)statusMessageBtnOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(orderCellBtnDidClick:)]) {
        [self.delegate orderCellBtnDidClick:self];
    }
}

- (void)setOrder:(Order *)order {
    _order = order;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:order.create_time];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    self.dateLabel.text = [fmt stringFromDate:date];
    
    if (order.status == OrderStatusDaichuli) {
        if (order.erxiao_status) {
            self.statusLabel.text = [NSString stringWithFormat:@"（%@）待处理",order.erxiao_status];
        } else {
            self.statusLabel.text = @"待处理";
        }
        self.statusLabel.textColor = HEX(@"#178FE6");
        self.statusMessageBtn.enabled = NO;
        [self.statusMessageBtn setTitle:@"" forState:UIControlStateNormal];
        [self.statusMessageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.followerLabel.mas_left);
            make.top.mas_equalTo(self.bottomLine.mas_bottom);
            make.height.mas_equalTo(0);
            make.bottom.mas_equalTo(self.backView.mas_bottom);
        }];
    } else if (order.status == OrderStatusDaishenhe) {
        if (order.erxiao_status) {
            self.statusLabel.text = [NSString stringWithFormat:@"（%@）待审核",order.erxiao_status];
        } else {
            self.statusLabel.text = @"待审核";
        }
        self.statusLabel.textColor = HEX(@"#FAB732");
        self.statusMessageBtn.enabled = NO;
        [self.statusMessageBtn setTitle:@"" forState:UIControlStateNormal];
        [self.statusMessageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.followerLabel.mas_left);
            make.top.mas_equalTo(self.bottomLine.mas_bottom);
            make.height.mas_equalTo(0);
            make.bottom.mas_equalTo(self.backView.mas_bottom);
        }];
    } else if (order.status == OrderStatusDaijiesuan) {
        if (order.erxiao_status) {
            self.statusLabel.text = [NSString stringWithFormat:@"（%@）待结算",order.erxiao_status];
        } else {
            self.statusLabel.text = @"待结算";
        }
        
        self.statusLabel.textColor = HEX(@"#178FE6");
        self.statusMessageBtn.enabled = NO;
        if (self.order.type == OrderTypeDajian) {
            [self.statusMessageBtn setTitle:@"搭建奖励即将发放，请确保收款账户正确无误哟" forState:UIControlStateNormal];
        } else {
            [self.statusMessageBtn setTitle:@"客资奖励即将发放，请确保收款账户正确无误哟" forState:UIControlStateNormal];
        }
        [self.statusMessageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.followerLabel.mas_left);
            make.top.mas_equalTo(self.bottomLine.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-10);
        }];
    } else if (order.status == OrderStatusYijiesuan) {
        if (order.erxiao_status) {
            self.statusLabel.text = [NSString stringWithFormat:@"（%@）已结算",order.erxiao_status];
        } else {
            self.statusLabel.text = @"已结算";
        }
        
        self.statusLabel.textColor = HEX(@"#178FE6");
        self.statusMessageBtn.enabled = NO;
        if (self.order.type == OrderTypeDajian) {
            [self.statusMessageBtn setTitle:@"搭建奖励已发放" forState:UIControlStateNormal];
        } else {
            [self.statusMessageBtn setTitle:@"客资奖励已发放" forState:UIControlStateNormal];
        }
        
        [self.statusMessageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.followerLabel.mas_left);
            make.top.mas_equalTo(self.bottomLine.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-10);
        }];
    } else if (order.status == OrderStatusYibohui) {
        if (order.erxiao_status) {
            self.statusLabel.text = [NSString stringWithFormat:@"（%@）已驳回",order.erxiao_status];
        } else {
            self.statusLabel.text = @"已驳回";
        }
        
        self.statusLabel.textColor = HEX(@"#178FE6");
        self.statusMessageBtn.enabled = YES;
        
        [self.statusMessageBtn setTitle:@"修改并重新提交" forState:UIControlStateNormal];
        [self.statusMessageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.followerLabel.mas_left);
            make.top.mas_equalTo(self.bottomLine.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-10);
        }];
    } else if (order.status == OrderStatusYiquxiao) {
        if (order.erxiao_status) {
            self.statusLabel.text = [NSString stringWithFormat:@"（%@）已取消",order.erxiao_status];
        } else {
            self.statusLabel.text = @"已取消";
        }
        
        self.statusLabel.textColor = HEX(@"#178FE6");
        self.statusMessageBtn.enabled = NO;
        if (self.order.type == OrderTypeDajian) {
            [self.statusMessageBtn setTitle:@"搭建信息已终止跟进" forState:UIControlStateNormal];
        } else {
            [self.statusMessageBtn setTitle:@"客资信息已终止跟进" forState:UIControlStateNormal];
        }
        [self.statusMessageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.followerLabel.mas_left);
            make.top.mas_equalTo(self.bottomLine.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-10);
        }];
    } else if (order.status == OrderStatusYiwanjie) {
        if (order.erxiao_status) {
            self.statusLabel.text = [NSString stringWithFormat:@"（%@）已完结",order.erxiao_status];
        } else {
            self.statusLabel.text = @"已完结";
        }
        
        self.statusLabel.textColor = HEX(@"#178FE6");
        self.statusMessageBtn.enabled = NO;
        if (self.order.type == OrderTypeDajian) {
            [self.statusMessageBtn setTitle:@"搭建订单已完结" forState:UIControlStateNormal];
        } else {
            [self.statusMessageBtn setTitle:@"客资订单已完结" forState:UIControlStateNormal];
        }

        [self.statusMessageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.followerLabel.mas_left);
            make.top.mas_equalTo(self.bottomLine.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-10);
        }];
    } else if (order.status == OrderStatusGenjinzhong) {
        if (order.erxiao_status) {
            self.statusLabel.text = [NSString stringWithFormat:@"（%@）跟进中",order.erxiao_status];
        } else {
            self.statusLabel.text = @"跟进中";
        }
        self.statusLabel.textColor = HEX(@"#178FE6");
        self.statusMessageBtn.enabled = NO;
        [self.statusMessageBtn setTitle:@"" forState:UIControlStateNormal];
        [self.statusMessageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.followerLabel.mas_left);
            make.top.mas_equalTo(self.bottomLine.mas_bottom);
            make.height.mas_equalTo(0);
            make.bottom.mas_equalTo(self.backView.mas_bottom);
        }];
    }
    
    
    self.phoneLabel.text = order.order_phone;
    self.followerNameLabel.text = order.watch_user;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _dateLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _dateLabel;
}

- (UILabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    }
    return _statusLabel;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEX(@"#EBEBF0");
    }
    return _line;
}

- (UILabel *)contactsLabel {
    if (_contactsLabel == nil) {
        _contactsLabel = [[UILabel alloc] init];
        _contactsLabel.text = @"联系人";
        _contactsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _contactsLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _contactsLabel;
}

- (UILabel *)phoneLabel {
    if (_phoneLabel == nil) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _phoneLabel.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _phoneLabel;
}

- (UILabel *)followerLabel {
    if (_followerLabel == nil) {
        _followerLabel = [[UILabel alloc] init];
        _followerLabel.text = @"跟踪方";
        _followerLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _followerLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _followerLabel;
}

- (UILabel *)followerNameLabel {
    if (_followerNameLabel == nil) {
        _followerNameLabel = [[UILabel alloc] init];
        _followerNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _followerNameLabel.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _followerNameLabel;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = HEX(@"#EBEBF0");
    }
    return _bottomLine;
}

- (UIButton *)statusMessageBtn {
    if (_statusMessageBtn == nil) {
        _statusMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusMessageBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_statusMessageBtn setTitleColor:[UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0] forState:UIControlStateDisabled];
        [_statusMessageBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:118/255.0 blue:255/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [_statusMessageBtn addTarget:self action:@selector(statusMessageBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _statusMessageBtn;
}

@end
