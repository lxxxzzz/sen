//
//  DateKeyboardView.m
//  森
//
//  Created by Lee on 17/4/9.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "DateKeyboardView.h"
#import <Masonry.h>

@interface DateKeyboardView ()

@property (nonatomic, strong) UIDatePicker *pickerView;
@property (nonatomic, weak) UIView *container;

@end

@implementation DateKeyboardView

static CGFloat const height = 300;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        self.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [self setupSubviews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [self addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    Log(@"%s", __func__);
}

- (void)show {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    UIView *view = self.superview;
    if (view == nil) {
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        
        [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)hidden {
    [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(height);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)cancelClick {
    
    [self hidden];
}

- (void)finishClick {
    
    if (self.didSelectDate) {
        self.didSelectDate(self.pickerView.date);
    }
    
    Log(@"%@",self.pickerView.date);
    
    [self hidden];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    [self hidden];
}


- (void)setupSubviews {
    UIView *container = [[UIView alloc] init];
    [self addSubview:container];
    self.container = container;
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(height);
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    UIView *toolbar = [[UIView alloc] init];
    toolbar.backgroundColor = HEX(@"#178FE6");
    
    [container addSubview:toolbar];
    [container addSubview:self.pickerView];
    
    UIButton *cancel = [[UIButton alloc] init];
    cancel.titleLabel.font = FONT(14);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:cancel];
    
    UIButton *finish = [[UIButton alloc] init];
    finish.titleLabel.font = FONT(14);
    [finish setTitle:@"完成" forState:UIControlStateNormal];
    [finish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finish addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:finish];
    
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(toolbar.mas_left).offset(15);
        make.top.mas_equalTo(toolbar.mas_top);
        make.bottom.mas_equalTo(toolbar.mas_bottom);
    }];
    
    [finish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(toolbar.mas_top);
        make.bottom.mas_equalTo(toolbar.mas_bottom);
        make.right.mas_equalTo(toolbar.mas_right).offset(-15);
    }];
    
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(container.mas_left);
        make.right.mas_equalTo(container.mas_right);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(container.mas_top);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(container.mas_bottom);
        make.top.mas_equalTo(toolbar.mas_bottom);
    }];
    
    [self layoutIfNeeded];
}

- (UIDatePicker *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIDatePicker alloc] init];
        _pickerView.datePickerMode = UIDatePickerModeDate;
        _pickerView.minimumDate = [NSDate date];
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

@end
