//
//  HotelListViewController.m
//  森
//
//  Created by Lee on 2017/5/22.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HotelListViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "RootVCManager.h"
#import "LoginViewController.h"
#import "HotelListCell.h"
#import "HotelDetailViewController.h"
#import "Dropdown.h"
#import "AreaViewController.h"
#import "DrawerViewController.h"
#import "UserViewController.h"
#import "UserItem.h"
#import "Hotel.h"

#import "UserInfoViewController.h"
#import "FeedbackViewController.h"
#import "TMCustomerListViewController.h"
#import "GZOrderListViewController.h"
#import "UserInfoViewController.h"
#import "UpdatePasswordViewController.h"
#import "TMListParentViewController.h"
#import "CustomerListViewController.h"
#import "DJFollowListViewController.h"
#import "EXListViewController.h"
#import "Option.h"
#import "NavigationViewController.h"
#import "DropdownMenu.h"
#import "SearchViewController.h"

#import <Masonry.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>

@interface HotelListViewController () <UITableViewDelegate, UITableViewDataSource, DropdownDelegate, AreaViewControllerDelegate, DropdownMenuDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIButton *recommend;
//@property (nonatomic, copy) NSString *list_type;
@property (nonatomic, strong) Option *area_sh_id;
@property (nonatomic, strong) Option *hotel_type;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) Option *selectedOption;
@property (nonatomic, strong) DropdownMenu *dropdownMenu;
@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) NSTimer *timer;


@end

#define TEST NO

@implementation HotelListViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupSubviews];
    
    [self setupNavigationItem];
    
    [self setupLeftVc];
    
    [self loadAllData];
    
    [self loadAreaData];
    
    [self setupNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    Log(@"token ---- %@",TOKEN);
}

- (void)dealloc {
    Log(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override

#pragma mark - 私有方法
- (void)userDidLogin {
    [self setupNavigationItem];
    
    [self setupLeftVc];
}

- (void)userDidLogout {
    // 用户退出后调用的方法
    [self setupNavigationItem];
    
    self.recommend.hidden = NO;
}

- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:kUserDidLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kUserDidLoginNotification object:nil];
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"森";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"search" highImageName:@"search" target:self action:@selector(search)];
    if (TOKEN) {
        // 登录了
        User *user = [User sharedUser];
        if (user.user_type == 3) {
            // 注册账号
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"ti" highImageName:@"ti" target:self action:@selector(userInfo)];
        } else if (user.user_type == 4) {
            // 酒店账号
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"gen" highImageName:@"gen" target:self action:@selector(userInfo)];
        } else if (user.user_type == 11) {
            // 首销账号
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"shou" highImageName:@"shou" target:self action:@selector(userInfo)];
        }  else if (user.user_type == 12) {
            // 二销账号
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"er" highImageName:@"er" target:self action:@selector(userInfo)];
        }
    } else {
        // 未登录
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"hotel_user_icon" highImageName:@"hotel_user_icon" target:self action:@selector(userInfo)];
    }
}

- (void)setupSubviews {
//    self.dropdownMenu = [[DropdownMenu alloc] initWithItems:@[@"全部地区1", @"全部酒店类型"]];
    self.dropdownMenu = [[DropdownMenu alloc] init];
    self.dropdownMenu.delegate = self;
    [self.view addSubview:self.dropdownMenu];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.recommend];
    [self.view addSubview:self.messageLabel];
    [self.view addSubview:self.refreshView];
    
    [self.dropdownMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(64);
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dropdownMenu.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    
    [self.recommend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-30);
//        make.size.mas_equalTo(CGSizeMake(62, 62));
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    
    [self.refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(210, 35));
    }];
}

- (void)setupLeftVc {
    NavigationViewController *nav = (NavigationViewController *)self.parentViewController;
    DrawerViewController *drawerVc = (DrawerViewController *)nav.parentViewController;
    UserViewController *leftVc = (UserViewController *)drawerVc.leftController;
    
    User *user = [User sharedUser];
    if (user.user_type == 1) {
        // 未知用户
        self.recommend.hidden = NO;
    } else if (user.user_type == 2) {
        // 超级管理员
        self.recommend.hidden = NO;
    } else if (user.user_type == 3) {
        // 注册账号
        leftVc.avatarName = @"tigong_icon";
        leftVc.nickName = @"提供者";
        leftVc.dataSource = @[[UserItem userItemWithTitle:@"我的推荐" image:@"icons_recommend" destVc:[CustomerListViewController class]],[UserItem userItemWithTitle:@"个人中心" image:@"icons_avatar_dark" destVc:[UserInfoViewController class]],
                              [UserItem userItemWithTitle:@"用户反馈" image:@"icons_feedback" destVc:[FeedbackViewController class]]];
        self.recommend.hidden = NO;
    } else if (user.user_type == 4) {
        // 酒店账号，跳转到客资列表页
        leftVc.avatarName = @"genzong_icon";
        leftVc.nickName = @"跟踪者";
        leftVc.dataSource = @[[UserItem userItemWithTitle:@"我的推荐" image:@"icons_recommend" destVc:[TMListParentViewController class]],
                              [UserItem userItemWithTitle:@"我的跟进" image:@"icons_track" destVc:[GZOrderListViewController class]],
                              [UserItem userItemWithTitle:@"个人中心" image:@"icons_avatar_dark" destVc:[UserInfoViewController class]],
                              [UserItem userItemWithTitle:@"修改密码" image:@"icons_password" destVc:[UpdatePasswordViewController class]],
                              [UserItem userItemWithTitle:@"用户反馈" image:@"icons_feedback" destVc:[FeedbackViewController class]]];
        self.recommend.hidden = NO;
    } else if (user.user_type == 11) {
        // 首销账号
        leftVc.avatarName = @"shouxiao_icon";
        leftVc.nickName = @"首销";
        leftVc.dataSource = @[[UserItem userItemWithTitle:@"我的跟进" image:@"icons_track" destVc:[DJFollowListViewController class]],
                              [UserItem userItemWithTitle:@"修改密码" image:@"icons_password" destVc:[UpdatePasswordViewController class]],
                              [UserItem userItemWithTitle:@"用户反馈" image:@"icons_feedback" destVc:[FeedbackViewController class]]];
        self.recommend.hidden = YES;
    } else if (user.user_type == 12) {
        // 二销账号
        Log(@"二销账号");
        leftVc.avatarName = @"erxiao_icon";
        leftVc.nickName = @"二销";
        leftVc.dataSource = @[[UserItem userItemWithTitle:@"我的跟进" image:@"icons_track" destVc:[EXListViewController class]],
                              [UserItem userItemWithTitle:@"修改密码" image:@"icons_password" destVc:[UpdatePasswordViewController class]],
                              [UserItem userItemWithTitle:@"用户反馈" image:@"icons_feedback" destVc:[FeedbackViewController class]]];
        self.recommend.hidden = YES;
    } else if (user.user_type == 13) {
        // 财务
        self.recommend.hidden = NO;
    } else if (user.user_type == 14) {
        // 客服账号
        self.recommend.hidden = NO;
    }
}

- (void)userInfo {
    if (TOKEN) {
        // 登录了
        NavigationViewController *nav = (NavigationViewController *)self.parentViewController;
        if ([nav.parentViewController isKindOfClass:[DrawerViewController class]]) {
            DrawerViewController *drawerVc = (DrawerViewController *)nav.parentViewController;
            [drawerVc openDrawerWithAnimated:YES completion:nil];
        }
    } else {
        // 未登录，跳转登录页面
        LoginViewController *loginVc = [[LoginViewController alloc] init];
        [self presentViewController:loginVc animated:YES completion:nil];
    }
}

- (void)quickRecommend {
    if (TOKEN) {
        // 登录了
        User *user = [User sharedUser];
        if (user.user_type == 3) {
            CustomerListViewController *vc = [[CustomerListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(user.user_type == 4) {
            TMListParentViewController *tmVc = [[TMListParentViewController alloc] init];
            [self.navigationController pushViewController:tmVc animated:YES];
        }
    } else {
        // 未登录，跳转登录页面
        LoginViewController *loginVc = [[LoginViewController alloc] init];
        [self presentViewController:loginVc animated:YES completion:nil];
    }
}

- (void)option {
    Dropdown *dropdown = [[Dropdown alloc] initWithFrame:self.view.bounds];
    dropdown.dataSource = @[@"按推荐查看", @"按区域查看"];
    dropdown.delegate = self;
    [dropdown show];
}

- (void)search {
    SearchViewController *searchVc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:YES];
}

- (void)loadAreaData {
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=user&f=getShArea", HOST];
    [HTTPTool POST:url parameters:nil success:^(HTTPResult *result) {
        Log(@"%@",result.data);
        if (result.success) {
            NSMutableArray <Option *>*areas = [NSMutableArray array];
            NSMutableArray <Option *>*types = [NSMutableArray array];
            
            for (id number in result.data[@"sh_area_order"]) {
                [result.data[@"sh_area"] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSString *str = [NSString stringWithFormat:@"%@", number];
                    if ([key isEqualToString:str]) {
                        Option *option = [Option optionWithTitle:obj value:key];
                        [areas addObject:option];
                        *stop = YES;
                    }
                }];
            }
            
            [result.data[@"hotel_level"] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                Log(@"%@  %@",key,obj);
                Option *option = [Option optionWithTitle:obj value:key];
                [types addObject:option];
            }];
            
            NSSortDescriptor *countasc = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES];
            //按顺序添加排序描述器
            NSArray *ascs = [NSArray arrayWithObjects:countasc,nil];

    
            self.dropdownMenu.areas = areas;
            self.dropdownMenu.types = [types sortedArrayUsingDescriptors:ascs];
            self.dropdownMenu.items = @[[areas firstObject].title, [[self.dropdownMenu.types firstObject] title]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadTypeData {
    
}

- (void)loadAllData {
    __weak typeof(self) weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=user&f=mainList&debug=1", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"list_type"] = @"1";
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.dataSource = @[];
    [self.tableView reloadData];
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        self.refreshView.hidden = YES;
        [self.refreshView endRefresh];
        if (result.success) {
            if ([result.data count]) {
                weakself.dataSource = [Hotel mj_objectArrayWithKeyValuesArray:result.data];
                self.messageLabel.hidden = YES;
            } else {
                self.messageLabel.hidden = NO;
                self.messageLabel.text = [NSString stringWithFormat:@"%@下暂无酒店信息", self.area_sh_id.title];
            }
        }
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        self.refreshView.hidden = NO;
        [self.refreshView endRefresh];
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    }];
}

- (void)loadData {
    __weak typeof(self) weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=user&f=mainList", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"list_type"] = @"2";
    parameters[@"area_sh_id"] = self.area_sh_id.value == nil ? @"20" : self.area_sh_id.value;
    parameters[@"hotel_type"] = self.hotel_type.value == nil ? @"1" : self.hotel_type.value;
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.dataSource = @[];
    [self.tableView reloadData];
    Log(@"%@",parameters);
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        self.refreshView.hidden = YES;
        [self.refreshView endRefresh];
        if (result.success) {
            if ([result.data count]) {
                weakself.dataSource = [Hotel mj_objectArrayWithKeyValuesArray:result.data];
                self.messageLabel.hidden = YES;
            } else {
                self.messageLabel.hidden = NO;
                self.messageLabel.text = [NSString stringWithFormat:@"%@下暂无酒店信息", self.area_sh_id.title];
            }
        }
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        self.refreshView.hidden = NO;
        [self.refreshView endRefresh];
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    }];
}

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (HotelListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelListCell *cell = [HotelListCell cellWithTableView:tableView];
    cell.hotel = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    HotelDetailViewController *detailVc = [[HotelDetailViewController alloc] init];
    detailVc.hotel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark DropdownDelegate
- (void)dropdown:(Dropdown *)dropdown didSelectIndex:(NSInteger)index {
    
}

#pragma mark AreaViewControllerDelegate
- (void)areaViewController:(AreaViewController *)viewController didSelectArea:(Option *)area {
    // 筛选
    
}

#pragma mark DropdownMenuDelegate
- (void)dropdownMenu:(DropdownMenu *)dropdownMenu didSelectOption:(Option *)option {
    NSLog(@"选择了%@",option.title);
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"list_type"] = @"2";
    
    if (self.dropdownMenu.selectedIndex == 0) {
        self.area_sh_id = option;
    } else {
        self.hotel_type = option;
    }
    
    [self loadData];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = 120;
//        _tableView.estimatedRowHeight = 173;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCustomerInfo)];
    }
    return _tableView;
}

- (UIButton *)recommend {
    if (_recommend == nil) {
        _recommend = [[UIButton alloc] init];
        [_recommend setBackgroundImage:IMAGE(@"jisutuijian") forState:UIControlStateNormal];
        [_recommend addTarget:self action:@selector(quickRecommend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recommend;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = @"暂无此类酒店信息";
        _messageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        _messageLabel.hidden = YES;
        _messageLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
        _messageLabel.hidden = YES;
    }
    return _messageLabel;
}
    
- (RefreshView *)refreshView {
    if (_refreshView == nil) {
        _refreshView = [RefreshView refreshView];
        _refreshView.title = @"网络开了小差，点击重新加载";
        _refreshView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        
        [_refreshView setOnClickBlock:^{
            [weakSelf loadAllData];
            
            [weakSelf loadAreaData];
        }];
    }
    return _refreshView;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [[NSTimer alloc] init];
    }
    return _timer;
}

@end
