//
//  SearchViewController.m
//  森
//
//  Created by Lee on 2017/7/26.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "SearchViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "SearchBar.h"
#import "HTTPTool.h"
#import "Hotel.h"
#import "HotelListCell.h"
#import "HotelDetailViewController.h"
#import "HistorySearchView.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <Masonry.h>

@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, HistorySearchViewDelegate>

@property (nonatomic, strong) SearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *historyKeywords;
@property (nonatomic, strong) HistorySearchView *historySearchView;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation SearchViewController

static NSString * const kHistoryKeywordsKey = @"kHistoryKeywordsKey";
static NSInteger kMaxHistryKeywordsCount = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)searchWithKeyword:(NSString *)keyword {
    __weak typeof(self) weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=user&f=mainList", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"list_type"] = @"3";
    parameters[@"search_input"] = keyword;
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.dataSource = @[];
    [self.tableView reloadData];
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        if (result.success) {
            if ([result.data count]) {
                weakself.dataSource = [Hotel mj_objectArrayWithKeyValuesArray:result.data];
                self.messageLabel.hidden = YES;
            } else {
                self.messageLabel.hidden = NO;
            }
        }
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    }];
}

- (void)saveHistorySearchKeywordToSandBox {
    // 讲搜索关键字存入沙盒
    if ([self.historyKeywords containsObject:self.searchBar.text]) {
        [self.historyKeywords removeObject:self.searchBar.text];
    }
    
    [self.historyKeywords insertObject:self.searchBar.text atIndex:0];
    
    if (self.historyKeywords.count > kMaxHistryKeywordsCount) {
        // 删除多余的历史搜索记录
        [self.historyKeywords removeLastObject];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.historyKeywords forKey:kHistoryKeywordsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)hiddenHistorySearchView {
    CGRect rect = self.historySearchView.frame;
    rect.size.height = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.historySearchView.frame = rect;
    } completion:^(BOOL finished) {
        [self.historySearchView removeFromSuperview];
    }];
}

- (void)showHistorySearchView {
    [self.view addSubview:self.historySearchView];
    CGRect rect = self.historySearchView.frame;
    rect.size.height = SCREEN_HEIGHT - rect.origin.y;
    [UIView animateWithDuration:0.3 animations:^{
        self.historySearchView.frame = rect;
    }];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self showHistorySearchView];
    
    return YES;
}

//当搜索框结束编辑时候调用
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self searchBarResignAndChangeUI];
    
    [self hiddenHistorySearchView];
}

- (void)searchBarResignAndChangeUI {
    [self.searchBar resignFirstResponder];//失去第一响应
    [self changeSearchBarCancelBtnTitleColor:self.searchBar];//改变布局
}
    
#pragma mark - 遍历改变搜索框 取消按钮的文字颜色
- (void)changeSearchBarCancelBtnTitleColor:(UIView *)view{
    if (view) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *getBtn = (UIButton *)view;
            [getBtn setEnabled:YES];//设置可用
            [getBtn setUserInteractionEnabled:YES];
            
            //设置取消按钮字体的颜色“#0374f2”
            [getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateReserved];
            [getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            return;
            
        } else {
            for (UIView *subView in view.subviews) {
                [self changeSearchBarCancelBtnTitleColor:subView];
            }
        }
    } else {
        return;
    }
}

#pragma mark 点击了搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchBarResignAndChangeUI];
    // 发送网络请求
    [self searchWithKeyword:searchBar.text];
    // 讲搜索关键字存入沙盒
    [self saveHistorySearchKeywordToSandBox];
    
    // 隐藏历史搜索view
    [self hiddenHistorySearchView];
}

//点击CancelButton调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // 跳转到root
    [searchBar resignFirstResponder];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

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

- (void)historySearchView:(HistorySearchView *)view selectedKeyword:(NSString *)keyword {
    [self searchBarResignAndChangeUI];
    
    self.searchBar.text = keyword;
    
    [self searchWithKeyword:keyword];
    
    [self saveHistorySearchKeywordToSandBox];
    
    [self hiddenHistorySearchView];
}

- (void)historySearchViewClearHistorySearchKeywords:(HistorySearchView *)view {
    [self.historyKeywords removeAllObjects];
    self.historySearchView.keywords = self.historyKeywords;
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, self.view.frame.size.width - 50, 35)];
    titleView.backgroundColor = [UIColor redColor];
    self.searchBar = [[SearchBar alloc] init];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.frame = CGRectMake(0, 0, 340, 30);
    self.searchBar.delegate = self;
    [titleView addSubview:self.searchBar];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:0 target:nil action:nil];
    [self.searchBar becomeFirstResponder];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = self.searchBar;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.messageLabel];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
}

- (NSMutableArray *)historyKeywords {
    if (_historyKeywords == nil) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kHistoryKeywordsKey];
        if (array) {
            _historyKeywords = [array mutableCopy];
        } else {
            _historyKeywords = [[NSMutableArray alloc] init];
        }
    }
    return _historyKeywords;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = 120;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (HistorySearchView *)historySearchView {
    if (_historySearchView == nil) {
        _historySearchView = [[HistorySearchView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0)];
        _historySearchView.keywords = self.historyKeywords;
        _historySearchView.delegate = self;
    }
    return _historySearchView;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = @"暂无酒店信息";
        _messageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        _messageLabel.hidden = YES;
        _messageLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _messageLabel;
}

@end
