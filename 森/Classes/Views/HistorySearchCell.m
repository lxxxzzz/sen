//
//  HistorySearchCell.m
//  森
//
//  Created by 小红李 on 2017/7/31.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HistorySearchCell.h"

@interface HistorySearchCell ()

@property (nonatomic, strong) UIView *line;

@end

@implementation HistorySearchCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        self.textLabel.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:102/255.0 alpha:1/1.0];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, 0.5)];
        self.line.backgroundColor = HEX(@"#E6E6EB");
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.contentView.frame.size;
    self.line.frame = CGRectMake(10, size.height - 0.5, size.width - 20, 0.5);
}

@end
