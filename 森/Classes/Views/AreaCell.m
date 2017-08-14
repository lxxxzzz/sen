//
//  AreaCell.m
//  森
//
//  Created by Lee on 2017/5/23.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "AreaCell.h"
#import "Option.h"

@implementation AreaCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.label];
        self.layer.borderColor = HEX(@"E1E1E6").CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 16;
    }
    return self;
}

- (void)setOption:(Option *)option {
    _option = option;
    self.label.text = option.title;
    if (option.isSelected) {
        self.layer.borderColor = HEX(@"#178FE6").CGColor;
        self.label.textColor = HEX(@"#178FE6");
    } else {
        self.layer.borderColor = HEX(@"E1E1E6").CGColor;
        self.label.textColor = HEX(@"#626266");
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        if (SCREEN_WIDTH <= 320) {
            _label.font = FONT(11);
        } else {
            _label.font = FONT(14);
        }
        _label.textColor = HEX(@"#626266");
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}


@end
