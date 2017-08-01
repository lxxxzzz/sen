//
//  AreaViewController.m
//  森
//
//  Created by Lee on 2017/5/23.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "AreaViewController.h"
#import "AreaCell.h"
#import "HTTPTool.h"
#import "Option.h"
#import <Masonry.h>
#import <MJExtension.h>

@interface AreaViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation AreaViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
    
    [self loadData];
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - Override

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.title = @"选择查看区域";
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
}

- (void)loadData {
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=user&f=getShArea", HOST];
    [HTTPTool POST:url parameters:nil success:^(HTTPResult *result) {
        Log(@"%@",[result.data class]);
        if (result.success) {
            NSMutableArray *areas = [NSMutableArray array];
            
            [result.data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                Log(@"%@  %@",key,obj);
                Option *option = [Option optionWithTitle:obj value:key];
                [areas addObject:option];
            }];
            
            self.dataSource = areas;
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AreaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAreaCellID forIndexPath:indexPath];
    Option *option = self.dataSource[indexPath.row];
    cell.label.text = option.title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Option *option = self.dataSource[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(areaViewController:didSelectArea:)]) {
        [self.delegate areaViewController:self didSelectArea:option];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(86, 32);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[AreaCell class] forCellWithReuseIdentifier:kAreaCellID];
    }
    return _collectionView;
}

//- (NSArray *)dataSource {
//    if (_dataSource == nil) {
//        _dataSource = @[@"浦东新区", @"黄浦区", @"杨浦区", @"闸北区", @"静安区", @"松江区", @"青浦区"];
//    }
//    return _dataSource;
//}


@end
