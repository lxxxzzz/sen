//
//  PhotosViewController.m
//  森
//
//  Created by Lee on 2017/5/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PhotosViewController.h"
#import "Photo.h"
#import "PhotosCell.h"
#import "Toolbar.h"
#import "AlbumsViewController.h"
#import <Photos/Photos.h>

#import "Album.h"
#import "PhotoManager.h"
#import "PhotoBrowserViewController.h"

static const CGFloat imageSpacing = 1.0f;  /**< 图片间距 */
static const NSInteger maxCountInLine = 4; /**< 每行显示图片张数 */

@interface PhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PhotoListCellDelegate, ToolbarDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger selectedCount;
@property (nonatomic, strong) Toolbar *toolbar;

@end

@implementation PhotosViewController

static NSString *const cellId = @"photoListCell";

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.dataSource.count == 0 ) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataSource.count - 1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
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
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
}

- (void)setupSubviews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat toolbarH = 44;
    CGFloat y = 64;
    self.collectionView.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - toolbarH - y);
    [self.view addSubview:self.collectionView];

    self.toolbar.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), self.view.frame.size.width, toolbarH);
    self.toolbar.selectedCount = self.selectedPhotos.count;
    [self.view addSubview:self.toolbar];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 设置按钮的尺寸为背景图片的尺寸
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - Action
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.delegate = self;
    Photo *photo = self.dataSource[indexPath.row];
    
    for (id obj in self.selectedPhotos) {
        if ([obj isKindOfClass:[Photo class]]) {
            Photo *p = (Photo *)obj;
            if ([p.asset.localIdentifier isEqualToString:photo.asset.localIdentifier]) {
                photo.selected = YES;
            }
        }
    }
    
    
    cell.photo = photo;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoBrowserViewController *vc = [[PhotoBrowserViewController alloc] initWithImages:self.dataSource selectedIndex:indexPath.row];
    vc.sourceCollectionView = collectionView;
    [vc showWithViewController:self];
}

- (void)photosCellSelectBtnDidClick:(PhotosCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    Photo *photo = self.dataSource[indexPath.row];
//    NSInteger maxCount = [[PhotoManager manager] maxSelectCount] - self.selectedPhotos.count;
//    Log(@"%ld",maxCount);
    if (self.selectedPhotos.count == [[PhotoManager manager] maxSelectCount] && photo.isSelected == NO) {
        NSString *title = [NSString stringWithFormat:@"你最多只能选择%ld张照片", [[PhotoManager manager] maxSelectCount]];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    photo.selected = !photo.isSelected;

    cell.photo = photo;
    
    if (photo.isSelected) {
        [self.selectedPhotos addObject:photo];
    } else {
        [self.selectedPhotos removeObject:photo];
    }
    self.toolbar.selectedCount = self.selectedPhotos.count;
    
    Log(@"%@", self.selectedPhotos);
}

#pragma mark ToolbarDelegate
- (void)toolbarFinishBtnDidClick:(Toolbar *)toolbar {
    if (self.albumsViewController.delegate && [self.albumsViewController.delegate respondsToSelector:@selector(albumsViewController:didSelectPhotos:)]) {
        [self.albumsViewController.delegate albumsViewController:self.albumsViewController didSelectPhotos:self.selectedPhotos];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toolbarPreviewBtnDidClick:(Toolbar *)toolbar {
    
}

- (void)setAlbum:(Album *)album {
    _album = album;
    
    self.navigationItem.title = [[PhotoManager manager] albumChineseNameWithAlbum:album];
    
    __weak typeof(self) weakself = self;
    [[PhotoManager manager] fetchAllPhotosForResult:album.result completion:^(NSArray<Photo *> *photos) {
        weakself.dataSource = photos;
        [weakself.collectionView reloadData];
    }];
}

#pragma mark - setter and getter
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (SCREEN_WIDTH - imageSpacing * (maxCountInLine - 1)) / maxCountInLine;
        layout.itemSize = CGSizeMake(width, width);
        layout.minimumLineSpacing      = imageSpacing;
        layout.minimumInteritemSpacing = imageSpacing;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[PhotosCell class] forCellWithReuseIdentifier:cellId];
    }
    return _collectionView;
}

- (Toolbar *)toolbar {
    if (_toolbar == nil) {
        _toolbar = [[Toolbar alloc] init];
        _toolbar.maxCount = [[PhotoManager manager] maxSelectCount];
        _toolbar.delegate = self;
    }
    return _toolbar;
}

- (NSMutableArray *)selectedPhotos {
    if (_selectedPhotos == nil) {
        _selectedPhotos = [[NSMutableArray alloc] init];
    }
    return _selectedPhotos;
}

@end
