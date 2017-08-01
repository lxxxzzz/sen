//
//  RefreshView.m
//  森
//
//  Created by Lee on 2017/6/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "RefreshView.h"

@interface RefreshView()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation RefreshView

+ (instancetype)refreshView {
    return [[[NSBundle mainBundle] loadNibNamed:@"RefreshView" owner:nil options:nil] lastObject];
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

- (void)setup {
    [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)onClick {
    if ([self.delegate respondsToSelector:@selector(refreshViewDidClick:)]) {
        [self.delegate refreshViewDidClick:self];
    }
    if (self.onClickBlock) {
        self.onClickBlock();
    }
    
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
}

- (void)endRefresh {
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
}

- (void)awakeFromNib {
    self.indicatorView.hidden = YES;
    [super awakeFromNib];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.messageLabel.text = title;
}

@end
