//
//  UserViewController.m
//  森
//
//  Created by Lee on 17/3/23.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoViewController.h"
#import "FeedbackViewController.h"
#import "DrawerViewController.h"
#import "User.h"
#import "RootVCManager.h"
#import "UserCell.h"
#import "UserItem.h"

#import <Masonry.h>

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *logoutBtn;
@property (nonatomic, strong) NSArray *items;

@end

@implementation UserViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 私有方法
#pragma mark Action
- (void)logout {
    [User logout];
    
    DrawerViewController *drawerVc = (DrawerViewController *)self.parentViewController;
    [drawerVc closeDrawerWithAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kUserDidLoginNotification object:nil];
}

- (void)userDidLogin {
    self.nickName = [User sharedUser].nike_name;
}

#pragma mark 布局
- (void)setupSubviews {
    self.view.backgroundColor = HEX(@"#F5F5FA");
    [self.view addSubview:self.iconImage];
    [self.view addSubview:self.accountLabel];
    [self.view addSubview:self.nickNameLabel];
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.logoutBtn];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.mas_equalTo(self.view.mas_top).offset(100);
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImage.mas_bottom).offset(18);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountLabel.mas_bottom).offset(8);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
//    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-40);
//        make.right.mas_equalTo(self.view.mas_right);
//    }];
}

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.items[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.items[indexPath.section];
    UserCell *cell = [UserCell cellWithTableView:tableView];
    cell.userItem = array[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.items[indexPath.section];
    UserItem *userItem = array[indexPath.row];
    DrawerViewController *drawerVc = (DrawerViewController *)self.parentViewController;
    [drawerVc closeDrawerWithAnimated:YES completion:nil];
    
    if (userItem.destVc) {
        UIViewController *vc = [[userItem.destVc alloc] init];
        vc.navigationItem.title = userItem.title;
        [(UINavigationController *)drawerVc.centerController pushViewController:vc animated:YES];
    } else if(userItem.task) {
        userItem.task();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

#pragma mark - setter and getter
- (void)setDataSource:(NSArray<UserItem *> *)dataSource {
    _dataSource = dataSource;
    UserItem *logoutItem = [UserItem userItemWithTitle:@"退出登录" image:@"icons_exit" destVc:nil];
    @weakObj(self)
    logoutItem.task = ^{
        @strongObj(self)
        [User logout];
        
        DrawerViewController *drawerVc = (DrawerViewController *)self.parentViewController;
        [drawerVc closeDrawerWithAnimated:YES completion:nil];
    };
    
    self.items = @[self.dataSource, @[logoutItem]];
    
    [self.tableView reloadData];
}

- (void)setAvatarName:(NSString *)avatarName {
    _avatarName = avatarName;
    self.iconImage.image = IMAGE(avatarName);
}

- (void)setNickName:(NSString *)nickName {
    _nickName = [nickName copy];
    self.nickNameLabel.text = [NSString stringWithFormat:@"(%@)", nickName];
}

#pragma mark getter
- (UIImageView *)iconImage {
    if (_iconImage == nil) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.image = IMAGE(@"logo");
    }
    return _iconImage;
}

- (UILabel *)nickNameLabel {
    if (_nickNameLabel == nil) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        _nickNameLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _nickNameLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _nickNameLabel;
}

- (UILabel *)accountLabel {
    if (_accountLabel == nil) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        _accountLabel.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:102/255.0 alpha:1/1.0];
        _accountLabel.text = [User sharedUser].account;
    }
    return _accountLabel;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = HEX(@"#F5F5FA");
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = NO;
//        if (SCREEN_HEIGHT < ) {
//
//        }
        Log(@"%f",SCREEN_HEIGHT);
        if (SCREEN_HEIGHT <= 568) {
            _tableView.rowHeight = 40;
        } else {
            _tableView.rowHeight = 55;
        }
        
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (UIButton *)logoutBtn {
    if (_logoutBtn == nil) {
        _logoutBtn = [[UIButton alloc] init];
        _logoutBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutBtn setTitleColor: [UIColor colorWithRed:98/255.0 green:98/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [_logoutBtn addTarget:self action:@selector(logout)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBtn;
}


@end
