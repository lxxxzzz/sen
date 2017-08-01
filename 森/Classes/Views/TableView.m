//
//  TableView.m
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "TableView.h"
#import <Masonry.h>

@interface TableView ()

@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation TableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)click {
    [self endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.checkBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setFooterTitle:(NSString *)footerTitle {
    self.tableFooterView = self.footerView;
    _footerTitle = [footerTitle copy];
    [self.checkBtn setTitle:_footerTitle forState:UIControlStateNormal];
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
        _footerView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        [_footerView addGestureRecognizer:tap];
        [_footerView addSubview:self.checkBtn];
        [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_footerView.mas_left).offset(45);
            make.right.mas_equalTo(_footerView.mas_right).offset(-45);
            make.height.mas_equalTo(50);
            make.centerY.mas_equalTo(_footerView.mas_centerY);
        }];
    }
    return _footerView;
}

- (UIButton *)checkBtn {
    if (_checkBtn == nil) {
        _checkBtn = [[UIButton alloc] init];
        _checkBtn.backgroundColor = HEX(@"#178FE6");
        _checkBtn.titleLabel.font = FONT(14);
        _checkBtn.layer.cornerRadius = 4;
        _checkBtn.layer.masksToBounds = YES;
        [_checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _checkBtn;
}

@end
