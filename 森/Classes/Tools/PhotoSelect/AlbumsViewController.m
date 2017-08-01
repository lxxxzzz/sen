//
//  AlbumsViewController.m
//  森
//
//  Created by Lee on 2017/5/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "AlbumsViewController.h"

#import "AlbumCell.h"
#import "PhotosViewController.h"
#import "Album.h"
#import "Photo.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <Masonry.h>
#import "PhotoManager.h"

@interface AlbumsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray    *groupList;
@property (strong, nonatomic) UITableView       *tableView;

@property (nonatomic, strong) PHFetchResult<PHAssetCollection *> *result;
@property (nonatomic, strong) NSArray *albums;

@end

@implementation AlbumsViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
    
    __weak typeof(self) weakself = self;

    [[PhotoManager manager] fetchAllAlbumsCompletion:^(NSArray<Album *> *albums) {
        weakself.albums = albums;
        [weakself.tableView reloadData];
        NSString *albumName = [[PhotoManager manager] defaultAlbumName];
        if (albumName) {
            for (Album *album in albums) {
                // 默认跳转到照片控制器
                if ([[[PhotoManager manager] albumChineseNameWithAlbum:album] isEqualToString:albumName]) {
                    PhotosViewController *photoListVC = [[PhotosViewController alloc] init];
                    photoListVC.album = album;
                    photoListVC.albumsViewController = self;
                    photoListVC.selectedPhotos = [self.selectedPhotos mutableCopy];
                    [weakself.navigationController pushViewController:photoListVC animated:NO];
                    break;
                }
            }
        }
    }];
  

}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - 私有方法
- (void)setupNavigationItem {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateHighlighted];
    [button sizeToFit];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [button addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.title = @"相薄";
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)clickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - delegate
#pragma mark TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumCell *cell = [AlbumCell cellWithTableView:tableView];
    cell.album = self.albums[indexPath.row];
    return cell;
}

#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PhotosViewController *photoListVC = [[PhotosViewController alloc] init];
    photoListVC.albumsViewController = self;
    photoListVC.album = self.albums[indexPath.row];
    [self.navigationController pushViewController:photoListVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 16, 0, 0);
        tableView.layoutMargins = cell.layoutMargins;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
        tableView.separatorInset = cell.separatorInset;
    }
}

#pragma mark - setter and getter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = 80;
    }
    return _tableView;
}

@end
