//
//  BasePlainViewController.m
//  森
//
//  Created by Lee on 2017/5/26.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BasePlainViewController.h"

@interface BasePlainViewController ()

@property (nonatomic, assign) BOOL isShow;

@end

@implementation BasePlainViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self setupNotifacation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isShow = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [self.keyboardView hidden];
    
    self.isShow = NO;
    
    [SVProgressHUD dismiss];
}

- (void)dealloc {
    Log(@"%s",__func__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override

#pragma mark - 私有方法

- (void)setupNotifacation {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    if (!self.isShow) return;
    
    CGRect kbRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat btnY = CGRectGetMaxY(self.firstResponderCell.frame) + 64;

    if (kbRect.origin.y < btnY) {
        CGFloat difference = ABS(btnY - kbRect.origin.y);
        [self.tableView setContentOffset:CGPointMake(0, difference) animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)noti {
    if (!self.isShow) return;
    [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
}

#pragma mark Action

#pragma mark 布局
- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (MultiCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultiCell *cell = [MultiCell cellWithTableView:tableView];
    cell.item = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BaseItem *item = self.dataSource[indexPath.row];
    if ([item isKindOfClass:[ArrowItem class]]) {
        ArrowItem *arrowItem = (ArrowItem *)item;
        if (arrowItem.task) {
            arrowItem.task();
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseItem *item = self.dataSource[indexPath.row];
    if ([item isKindOfClass:[TextViewItem class]]) {
        TextViewItem *textViewItem = (TextViewItem *)item;
        return textViewItem.height;
    }
    return 44;
}

#pragma mark MultiCellDelegate
- (void)multiCellTextFieldBecomeFirstResponder:(MultiCell *)cell {
    self.firstResponderCell = cell;
}


#pragma mark - setter and getter
#pragma mark getter
- (TableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[TableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
    }
    return _tableView;
}

- (KeyboardView *)keyboardView {
    if (_keyboardView == nil) {
        _keyboardView = [[KeyboardView alloc] init];
    }
    return _keyboardView;
}

- (DateKeyboardView *)dateKeyboardView {
    if (_dateKeyboardView == nil) {
        _dateKeyboardView = [[DateKeyboardView alloc] init];
    }
    return _dateKeyboardView;
}

@end
