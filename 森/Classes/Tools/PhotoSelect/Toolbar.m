//
//  Toolbar.m
//  森
//
//  Created by Lee on 2017/5/9.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "Toolbar.h"

@interface Toolbar ()

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *previewBtn;
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation Toolbar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectedCount = 0;
        [self addSubview:self.line];
        
//        [self addSubview:self.previewBtn];
        [self addSubview:self.finishBtn];
        [self addSubview:self.infoLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.line.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    self.previewBtn.frame = CGRectMake(10, 0, 50, self.frame.size.height);
    self.infoLabel.frame = CGRectMake(CGRectGetMaxX(self.previewBtn.frame), 0, self.frame.size.width - (2 * 10 + 2 * self.previewBtn.frame.size.width), self.frame.size.height);
    self.finishBtn.frame = CGRectMake(CGRectGetMaxX(self.infoLabel.frame), 0, self.previewBtn.frame.size.width, self.frame.size.height);
}

- (void)previewBtnDidClick {
    if ([self.delegate respondsToSelector:@selector(toolbarPreviewBtnDidClick:)]) {
        [self.delegate toolbarPreviewBtnDidClick:self];
    }
}

- (void)finiBtnDidClick {
    if ([self.delegate respondsToSelector:@selector(toolbarFinishBtnDidClick:)]) {
        [self.delegate toolbarFinishBtnDidClick:self];
    }
}

- (void)setMaxCount:(NSInteger)maxCount {
    _maxCount = maxCount;
    
    self.infoLabel.text = [NSString stringWithFormat:@"%ld / %ld", self.selectedCount, self.maxCount];
}

- (void)setSelectedCount:(NSInteger)selectedCount {
    _selectedCount = selectedCount;
    
    self.previewBtn.enabled = selectedCount;
    self.finishBtn.enabled = selectedCount;
    self.infoLabel.text = [NSString stringWithFormat:@"%ld / %ld", self.selectedCount, self.maxCount];
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    }
    return _line;
}

- (UIButton *)previewBtn {
    if (_previewBtn == nil) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_previewBtn addTarget:self action:@selector(previewBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewBtn;
}

- (UIButton *)finishBtn {
    if (_finishBtn == nil) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_finishBtn addTarget:self action:@selector(finiBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.font = [UIFont systemFontOfSize:14];
    }
    return _infoLabel;
}

@end
