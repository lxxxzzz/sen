//
//  AlbumsViewController.h
//  森
//
//  Created by Lee on 2017/5/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlbumsViewController;

@protocol AlbumsViewControllerDelegate <NSObject>

@optional
- (void)albumsViewController:(AlbumsViewController *)viewController didSelectPhotos:(NSArray *)photos;

@end

@interface AlbumsViewController : UIViewController

@property (nonatomic, weak) id <AlbumsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *selectedPhotos;

@end
