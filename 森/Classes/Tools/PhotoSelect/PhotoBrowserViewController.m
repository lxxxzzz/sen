//
//  PhotoBrowserViewController.m
//  森
//
//  Created by Lee on 2017/5/16.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PhotoBrowserViewController.h"
#import "PhotoManager.h"
#import "Photo.h"
#import "PhotoBrowserCell.h"
#import "PhotosCell.h"

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#ifdef DEBUG
    #define Log(FORMAT, ...) fprintf(stderr,"%s: %d\t %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
    #define Log(...);
#endif

@interface PhotoBrowserViewController () <UIScrollViewDelegate, UIViewControllerTransitioningDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *backView;
//@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString *const photoBrowserCellId = @"photoBrowserCellId";

@implementation PhotoBrowserViewController

#pragma mark - init
//- (instancetype)initWithModels:(NSArray *)models selectedIndex:(NSInteger)index {
//    if (self = [super init]) {
//        self.models = models;
//        self.selectedIndex = index;
//        
//        self.modalPresentationStyle = UIModalPresentationCustom;
//        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    }
//    return self;
//}

- (instancetype)initWithImages:(NSArray *)images selectedIndex:(NSInteger)index {
    if (self = [super init]) {
        self.images = images;
        self.selectedIndex = index;
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    return self;
}


#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = [UIColor redColor];
    
    self.backView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [self.view addSubview:self.backView];
    
    self.collectionView.frame = self.backView.bounds;
    self.collectionView.hidden = YES;
    [self.backView addSubview:self.collectionView];

    if (self.images.count <= 8) {
        self.pageControl.center = self.view.center;
        CGRect rect = self.pageControl.frame;
        rect.origin.y = self.view.frame.size.height - 30;
        self.pageControl.frame = rect;
        self.pageControl.numberOfPages = self.images.count;
        self.pageControl.currentPage = self.selectedIndex;
        [self.backView addSubview:self.pageControl];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.collectionView.contentOffset = CGPointMake(self.view.frame.size.width * self.selectedIndex, 0);
    
    PhotosCell *sourceView = (PhotosCell *)[self.sourceCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    UIImageView *snapshotView = [[UIImageView alloc] initWithImage:sourceView.imageView.image];
    if (snapshotView == nil) {
        return;
    }
    CGRect rect = [sourceView.superview convertRect:sourceView.frame toView:self.backView];

    snapshotView.frame = rect;
    [self.backView addSubview:snapshotView];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat width = self.view.frame.size.width;
        CGFloat height = width * sourceView.imageView.image.size.height / sourceView.imageView.image.size.width;
        CGFloat y = (self.view.frame.size.height - height) / 2.0;
        snapshotView.frame = CGRectMake(0, y, width, height);
        self.backView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    } completion:^(BOOL finished) {
        [snapshotView removeFromSuperview];
//        cell.imageView.hidden = NO;
        self.collectionView.hidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - 私有方法
- (void)dismiss {
    PhotoBrowserCell *cell = (PhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    // 遮盖的view
    UIImageView *maskView = [[UIImageView alloc] initWithImage:cell.imageView.image];
    CGRect imageRect = cell.imageView.frame;
    maskView.contentMode = UIViewContentModeScaleAspectFill;
    maskView.clipsToBounds = YES;
    imageRect.origin.x = 0;
    maskView.frame = imageRect;
    [self.backView addSubview:maskView];

    PhotosCell *sourceView = (PhotosCell *)[self.sourceCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    CGRect rect = [sourceView.superview convertRect:sourceView.frame toView:self.backView];
    
    cell.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [UIView animateWithDuration:0.5 animations:^{
        maskView.frame = rect;
        self.backView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - 公共方法
- (void)show {
    [self showWithViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (void)showWithViewController:(UIViewController *)viewController {
    [viewController presentViewController:self animated:NO completion:nil];
}

#pragma mark - 代理
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.selectedIndex = scrollView.contentOffset.x / self.view.frame.size.width;
    Log(@"当前页数为%f",scrollView.contentOffset.x / self.view.frame.size.width);
}

#pragma mark UICollectionViewDelegate

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoBrowserCellId forIndexPath:indexPath];
    cell.photo = self.images[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismiss];
}

#pragma mark - setter and getter
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    self.pageControl.currentPage = selectedIndex;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
    }
    return _pageControl;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0.f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[PhotoBrowserCell class] forCellWithReuseIdentifier:photoBrowserCellId];
    }
    return _collectionView;
}

@end
