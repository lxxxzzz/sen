//
//  TextView.m
//  森
//
//  Created by Lee on 17/4/10.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "TextView.h"

@interface TextView () <UITextViewDelegate>

@end

@implementation TextView 

- (void)drawRect:(CGRect)rect {
    if (self.hasText) return;
    
    rect.origin.x = 4;
    rect.origin.y = 7;
    rect.size.width -= rect.origin.x * 2;
    rect.size.height -= rect.origin.y * 2;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    [self.placeholder drawInRect:rect withAttributes:attrs];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup {
//    self.layoutManager.allowsNonContiguousLayout = NO;

    self.font = [UIFont systemFontOfSize:14];

    self.placeholderColor = [UIColor colorWithRed:0 green:0 blue:0.0980392f alpha:0.22f];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}


- (void)textDidChange {
    [self setNeedsDisplay];
}

@end
