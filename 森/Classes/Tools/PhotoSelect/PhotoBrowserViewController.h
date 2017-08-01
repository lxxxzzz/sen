//
//  PhotoBrowserViewController.h
//  森
//
//  Created by Lee on 2017/5/16.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo, PhotoBrowserCell;

@interface PhotoBrowserViewController : UIViewController

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray <PhotoBrowserCell *>*sourceViews;
@property (nonatomic, strong) UICollectionView *sourceCollectionView;
@property (nonatomic, assign) NSInteger selectedIndex;

- (instancetype)initWithImages:(NSArray *)images selectedIndex:(NSInteger)index;
- (void)show;
- (void)showWithViewController:(UIViewController *)viewController;

@end
