//
//  SegmentControl.m
//  森
//
//  Created by Lee on 17/3/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "SegmentControl.h"

@interface SegmentControl ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indicator;
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation SegmentControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selectedIndex = 0;
        self.leading = 30;
        self.minMargin = 20;
        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.indicator];
    }
    return self;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.buttons removeAllObjects];
    
    for (int i=0; i<titles.count; i++) {
        UIButton *button = [self makeButtonWithTitle:titles[i]];
        [self.buttons addObject:button];
        [self.scrollView addSubview:button];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setBadgeValue:(NSDictionary *)badgeValue {
    _badgeValue = badgeValue;
    for (int i=0; i<self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        NSString *key = [NSString stringWithFormat:@"%d", i+1];
        NSInteger count = [[badgeValue objectForKey:key] integerValue];
        NSString *title = [NSString stringWithFormat:@"%@(%ld)",self.titles[i],count];
        [button setTitle:title forState:UIControlStateNormal];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    if (self.buttons.count == 0) return;
    
    UIButton *button = [self.buttons objectAtIndex:selectedIndex];
    [self buttonClick:button];
}

- (void)buttonClick:(UIButton *)button {
    if (button == nil) return;
    
    _selectedIndex = [self.buttons indexOfObject:button];
    
    if ([self.delegate respondsToSelector:@selector(segmentView:didSelectIndex:)]) {
        [self.delegate segmentView:self didSelectIndex:self.selectedIndex];
    }
    
    [self scrollToIndex:self.selectedIndex animated:YES];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    _selectedIndex = index;
    
    UIButton *button = [self.buttons objectAtIndex:index];
    
    CGFloat x = 5;
    CGFloat indicatorW = button.frame.size.width + x * 2;
    CGFloat indicatorX = button.frame.origin.x - x;
    CGFloat indicatorH = 2;
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.indicator.frame = CGRectMake(indicatorX, self.frame.size.height - indicatorH, indicatorW, indicatorH);
        }];
    } else {
        self.indicator.frame = CGRectMake(indicatorX, self.frame.size.height - indicatorH, indicatorW, indicatorH);
    }
    
    CGFloat offsetX = button.center.x - self.scrollView.frame.size.width / 2.0f;
    if (offsetX < 0) {
        offsetX = 0;
    }
    if (offsetX > self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
        offsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    }
    
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    CGFloat h = self.bounds.size.height;
    CGFloat w = self.bounds.size.width;
    // 计算出全部按钮的宽度+中间的间隔
    CGFloat contentW = 0;
    for (UIButton *btn in self.buttons) {
        [btn sizeToFit];
        contentW += btn.frame.size.width;
    }
    // 加上中间的leading
    contentW += (self.buttons.count - 1) * self.leading;
    
    CGFloat buttonX = 0;
    if ((w - contentW) < self.minMargin) {
        buttonX = self.minMargin;
    } else {
        buttonX = (w - contentW) / 2.0f;
    }
    
    CGFloat margin = buttonX;
    
    UIButton *lastButton;
    for (int i=0; i<self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        
        CGFloat buttonY = (h - button.frame.size.height) / 2.0f;
        if (lastButton) {
            // 不是第一个
            buttonX = CGRectGetMaxX(lastButton.frame) + self.leading;
        }
        button.frame = CGRectMake(buttonX, buttonY, button.frame.size.width, button.frame.size.height);
        
        if (i == self.selectedIndex) {
            button.selected = YES;
            CGFloat offsetX = 5;
            CGFloat indicatorW = button.frame.size.width + offsetX * 2;
            CGFloat indicatorX = button.frame.origin.x - offsetX;
            CGFloat indicatorH = 2;
            self.indicator.frame = CGRectMake(indicatorX, self.frame.size.height - indicatorH, indicatorW, indicatorH);
        } else {
            button.selected = NO;
        }
        lastButton = button;
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastButton.frame) + margin, 0);
}

- (UIButton *)makeButtonWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = FONT(14);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:HEX(@"#626266") forState:UIControlStateNormal];
    [button setTitleColor:HEX(@"#178FE6") forState:UIControlStateSelected];
    [button setTitleColor:HEX(@"#178FE6") forState:UIControlStateHighlighted | UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    return button;
}

- (UIView *)indicator {
    if (_indicator == nil) {
        _indicator = [[UIView alloc] init];
        _indicator.backgroundColor = HEX(@"#178FE6");
    }
    return _indicator;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
        
    }
    return _scrollView;
}

- (NSMutableArray *)buttons {
    if (_buttons == nil) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

@end
