//
//  FeedbackSuccessView.m
//  森
//
//  Created by Lee on 17/4/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "FeedbackSuccessView.h"
#import <Masonry.h>

@interface FeedbackSuccessView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) UILabel *desc;
@property (nonatomic, strong) UIButton *close;

@end

@implementation FeedbackSuccessView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
        
        [self setupSubviews];
    }
    return self;
}

- (void)dealloc {
    Log(@"%s", __func__);
}

- (void)btnClick {
    if ([self.delegate respondsToSelector:@selector(feedbackSuccessViewDidClickClose:)]) {
        [self.delegate feedbackSuccessViewDidClickClose:self];
    }
}

- (void)setupSubviews {
    [self addSubview:self.imageView];
    [self addSubview:self.status];
    [self addSubview:self.desc];
    [self addSubview:self.close];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(120);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(30);
    }];
    
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.status.mas_bottom);
    }];
    
    [self.close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(45);
        make.right.mas_equalTo(self.mas_right).offset(-45);
        make.top.mas_equalTo(self.desc.mas_bottom).offset(30);
        make.height.mas_equalTo(50);
    }];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = IMAGE(@"icon-success");
    }
    return _imageView;
}

- (UILabel *)status {
    if (_status == nil) {
        _status = [[UILabel alloc] init];
        _status.text = @"反馈成功";
        _status.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        _status.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _status;
}

- (UILabel *)desc {
    if (_desc == nil) {
        _desc = [[UILabel alloc] init];
        _desc.text = @"感谢您对森的关注，我们会认真处理您的反馈";
        _desc.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _desc.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _desc;
}

- (UIButton *)close {
    if (_close == nil) {
        _close = [[UIButton alloc] init];
        _close.backgroundColor = [UIColor colorWithRed:23/255.0 green:143/255.0 blue:230/255.0 alpha:1/1.0];
        _close.layer.cornerRadius = 4;
        _close.layer.masksToBounds = YES;
        [_close setTitle:@"关闭" forState:UIControlStateNormal];
        [_close addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _close;
}

@end
