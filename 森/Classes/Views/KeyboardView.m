//
//  KeyboardView.m
//  森
//
//  Created by Lee on 17/4/7.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "KeyboardView.h"
#import "Option.h"
#import <Masonry.h>

@interface KeyboardView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *cancel;
@property (nonatomic, strong) UIButton *confirm;
@property (nonatomic, weak) UIView *container;

@end

@implementation KeyboardView

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
 
    if (self.didFinishBlock) {
        self.didFinishBlock(self.selectedOption);
    }
    
    NSLog(@"%@",self.selectedOption);
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

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataSource[row].title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedOption = self.dataSource[row];
}

- (void)setDataSource:(NSArray<Option *> *)dataSource {
    _dataSource = dataSource;

    if (dataSource.count) self.selectedOption = dataSource.firstObject;

    [self.pickerView reloadAllComponents];
}

- (void)setSelectedOption:(Option *)selectedOption {
    _selectedOption = selectedOption;
    
    NSInteger index = [self.dataSource indexOfObject:selectedOption];
    [self.pickerView selectRow:index inComponent:0 animated:NO];
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
//        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

@end
