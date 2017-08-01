//
//  HotelDetailViewController.m
//  森
//
//  Created by Lee on 2017/5/22.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HotelDetailViewController.h"
#import <Masonry.h>
#import <MJExtension.h>
#import "HotelDetailHeaderView.h"
#import "BanquetHallDetailViewController.h"
#import "ItemGroup.h"
#import "BaseItem.h"
#import "Hotel.h"
#import "MultiCell.h"
#import "HotelCell.h"
#import "HTTPTool.h"
#import "Room.h"
#import "TelephoneItem.h"
#import "TelephoneCell.h"

@interface HotelDetailViewController () <UITableViewDelegate, UITableViewDataSource, TelephoneCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) HotelDetailHeaderView *headerView;

@end

@implementation HotelDetailViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)dealloc {
    Log(@"%s",__func__);
}


#pragma mark - Override

#pragma mark - 私有方法
- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(-20);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData {
    __weak typeof(self) weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=user&f=mainHotelDetail&debug=1", HOST];
    NSDictionary *parameters = @{@"hotel_id" : self.hotel.hotel_id};
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        if (result.success) {
            Hotel *hotel = [Hotel mj_objectWithKeyValues:result.data];
            
            ItemGroup *group1 = [[ItemGroup alloc] init];
            group1.height = 44;
            group1.items = @[[BaseItem itemWithTitle:@"类型" value:hotel.hotel_type required:NO],
                             [BaseItem itemWithTitle:@"地址" value:hotel.hotel_address required:NO],
                             [TelephoneItem itemWithTitle:@"联系方式" value:hotel.hotel_phone required:NO]
                             ];
            
            ItemGroup *group2 = [[ItemGroup alloc] init];
            group2.height = 90;
            group2.header = @"宴会厅";
            group2.items = hotel.room_list;
             
            ItemGroup *group3 = [[ItemGroup alloc] init];
            group3.height = 44;
            group3.header = @"婚宴菜单";
            NSMutableArray *menus = [NSMutableArray array];
            for (NSDictionary *dict in hotel.menu_list) {
                NSString *value = [NSString stringWithFormat:@"￥%@/桌", dict[@"menu_money"]];
                BaseItem *item = [BaseItem itemWithTitle:dict[@"menu_name"] value:value required:NO];
                [menus addObject:item];
            }
            group3.items = menus;
            weakself.dataSource = @[group1, group2, group3];
            weakself.hotel = hotel;
            weakself.headerView.hotel = hotel;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView reloadData];
    }];
}

- (void)phone:(NSString *)mobileNum {
    
    
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    /**
     25     * 大陆地区固话及小灵通
     26     * 区号：010,020,021,022,023,024,025,027,028,029
     27     * 号码：七位或八位
     28     */
    NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    
    NSArray *matchedString1 = [mobileNum componentsSeparatedByString:PHS];
    
    
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:PHS options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:mobileNum options:0 range:NSMakeRange(0, [mobileNum length])];
    
    NSRange range = [mobileNum rangeOfString:PHS options:NSRegularExpressionSearch];
    NSLog(@"%@", [mobileNum substringWithRange:range]);
    
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
//        return YES;
    }
    else
    {
//        return NO;
    }
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
    if ([obj isMemberOfClass:[BaseItem class]]) {
        MultiCell *cell = [MultiCell cellWithTableView:tableView];
        cell.item = obj;
        return cell;
    } else if ([obj isMemberOfClass:[TelephoneItem class]]) {
        TelephoneCell *cell = [TelephoneCell cellWithTableView:tableView];
        cell.item = obj;
        cell.delegate = self;
        return cell;
    } else {
        HotelCell *cell = [HotelCell cellWithTableView:tableView];
        cell.room = obj;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    if (group.header) {
        return 45;
    }
    return 10.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemGroup *group = self.dataSource[indexPath.section];
    if (group.height) {
        return group.height;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    if (group.header) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 45)];
        titleLabel.text = group.header;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        titleLabel.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
        [headerView addSubview:titleLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 44, SCREEN_WIDTH - 10 - 16, 0.5)];
        line.backgroundColor = HEX(@"#EBEBF0");
        [headerView addSubview:line];
        
        return headerView;
    }
    return nil;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ItemGroup *group = self.dataSource[indexPath.section];
    id obj = group.items[indexPath.row];
    if ([obj isKindOfClass:[Room class]]) {
        BanquetHallDetailViewController *detailVc = [[BanquetHallDetailViewController alloc] init];
        detailVc.room = obj;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

#pragma mark TelephoneCellDelegate
- (void)telephoneCellDidCalling:(TelephoneCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ItemGroup *group = self.dataSource[indexPath.section];
    TelephoneItem *item = group.items[indexPath.row];

    NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"tel:%@",item.value];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (HotelDetailHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[HotelDetailHeaderView alloc] init];
        CGFloat height = SCREEN_WIDTH * 200 / 375 + 50;
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    }
    return _headerView;
}

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:IMAGE(@"icons_back_white") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

@end
