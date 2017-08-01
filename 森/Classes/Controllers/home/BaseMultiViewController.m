//
//  BaseMultiViewController.m
//  森
//
//  Created by Lee on 2017/5/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BaseMultiViewController.h"

@interface BaseMultiViewController ()
@property (nonatomic, assign) BOOL isShow;
@end

@implementation BaseMultiViewController

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
    
    self.isShow = NO;
    
    [self.keyboardView hidden];
    
    [SVProgressHUD dismiss];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    Log(@"%s",__func__);
}

#pragma mark - Override

#pragma mark - 私有方法
- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (void)subHeaderOnClick {
    if (self.subHeaderAction) {
        self.subHeaderAction();
    }
}

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


#pragma mark - 公共方法
- (void)loadData {
    // 让子类实现
}

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemGroup *group = self.dataSource[indexPath.section];
    id obj = group.items[indexPath.row];
    if ([obj isMemberOfClass:[TelephoneItem class]]) {
        TelephoneCell *cell = [TelephoneCell cellWithTableView:tableView];
        cell.item = obj;
        cell.delegate = self;
        return cell;
    } else {
        MultiCell *cell = [MultiCell cellWithTableView:tableView];
        cell.item = group.items[indexPath.row];
        cell.delegate = self;
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    return group.header;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ItemGroup *group = self.dataSource[indexPath.section];
    BaseItem *item = group.items[indexPath.row];
    if ([item isKindOfClass:[ArrowItem class]]) {
        ArrowItem *arrowItem = (ArrowItem *)item;
        if (arrowItem.task) {
            arrowItem.task();
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    if (group.header) return 30;
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataSource.count - 1) {
        // 最后一行
        return 20;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    if (group.header) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 200, 20)];
        titleLabel.text = group.header;
        titleLabel.font = FONT(14);
        titleLabel.textColor = [UIColor grayColor];
        [headerView addSubview:titleLabel];
        
        if (group.subHeader) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = FONT(14);
            [button setTitle:group.subHeader forState:UIControlStateNormal];
            [button sizeToFit];
            CGRect rect = button.frame;
            rect.origin.x = self.view.frame.size.width - rect.size.width - 10;
            rect.origin.y = 7;
            rect.size.height = 20;
            button.frame = rect;
            [button setTitleColor:HEX(@"#178FE6") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(subHeaderOnClick) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:button];
            self.subHeaderAction = group.subHeaderAction;
        }
        return headerView;
    }
    return nil;
}

#pragma mark TelephoneCellDelegate
- (void)telephoneCellDidCalling:(TelephoneCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ItemGroup *group = self.dataSource[indexPath.section];
    BaseItem *item = group.items[indexPath.row];
    if ([item isKindOfClass:[TelephoneItem class]]) {
        TelephoneItem *arrowItem = (TelephoneItem *)item;
        if (arrowItem.click) {
            arrowItem.click();
        }
    }
}

#pragma mark getter
- (TableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[TableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
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
