//
//  Dropdown.m
//  森
//
//  Created by Lee on 17/3/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "Dropdown.h"

@interface Dropdown () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat height;

@end

@implementation Dropdown

static CGFloat const rowWidth = 130;
static CGFloat const rowHeight = 40;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
        [self addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.backImageView];
        [self.backImageView addSubview:self.tableView];
    }
    return self;
}

- (void)show {
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view {
    if (self.superview == view) {
        return;
    }
    [view addSubview:self];
    CGRect rect = self.backImageView.frame;
    rect.size.height = 0;
    self.backImageView.frame = rect;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect rect = self.backImageView.frame;
        rect.size.height = rowHeight * 2 + 7;
        self.backImageView.frame = rect;
    } completion:^(BOOL finished){
        Log(@"%@",NSStringFromCGRect(self.backImageView.frame));
    }];
}

- (void)hidden {
    CGRect rect = self.backImageView.frame;
    rect.size.height = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backImageView.frame = rect;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Id = @"dropdownCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = HEX(@"#626266");
        cell.textLabel.font = FONT(12);
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(dropdown:didSelectIndex:)]) {
        [self.delegate dropdown:self didSelectIndex:indexPath.row];
    }
    
    if ([self.delegate respondsToSelector:@selector(dropdown:didSelectItem:)]) {
        [self.delegate dropdown:self didSelectItem:self.dataSource[indexPath.row]];
    }
    
    !self.didSelectBlock ? : self.didSelectBlock(indexPath.row, self.dataSource[indexPath.row]);
    
    [self hidden];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;

    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 7, rowWidth, rowHeight * 2)];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.layer.borderColor = [UIColor clearColor].CGColor;
        _tableView.layer.borderWidth = 0;
        _tableView.layer.cornerRadius = 8;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = rowHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UIImageView *)backImageView {
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - rowWidth - 18, 70, rowWidth, rowHeight * 2 + 7)];
        _backImageView.image = [[UIImage imageNamed:@"DownMenuView_white"] stretchableImageWithLeftCapWidth:0 topCapHeight:7];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.layer.masksToBounds = YES;
    }
    return _backImageView;
}


@end
