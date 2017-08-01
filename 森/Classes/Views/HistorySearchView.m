//
//  HistorySearchView.m
//  森
//
//  Created by Lee on 2017/7/30.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HistorySearchView.h"
#import "HistorySearchCell.h"

@interface HistorySearchView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HistorySearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void)clearHistorySearch {
    if ([self.delegate respondsToSelector:@selector(historySearchViewClearHistorySearchKeywords:)]) {
        [self.delegate historySearchViewClearHistorySearchKeywords:self];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keywords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"keywordsID";
    HistorySearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HistorySearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    cell.textLabel.text = self.keywords[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(historySearchView:selectedKeyword:)]) {
        [self.delegate historySearchView:self selectedKeyword:self.keywords[indexPath.row]];
    }
}

- (void)setKeywords:(NSArray *)keywords {
    _keywords = keywords;
    
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 35)];
        label.text = @"搜索历史";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = HEX(@"#E6E6EB");
        [headerView addSubview:label];
        [headerView addSubview:line];
        _tableView.tableHeaderView = headerView;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 57)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        button.frame = CGRectMake((SCREEN_WIDTH - 160) / 2, 24, 160, 32);
        [button setTitle:@"清空搜索历史" forState:UIControlStateNormal];
        [button setTitleColor:HEX(@"#626266") forState:UIControlStateNormal];
        button.layer.borderColor = HEX(@"#E1E1E6").CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 4;
        [button addTarget:self action:@selector(clearHistorySearch) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:button];
        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}

@end
