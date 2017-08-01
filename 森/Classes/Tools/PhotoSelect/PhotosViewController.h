//
//  PhotosViewController.h
//  森
//
//  Created by Lee on 2017/5/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Album, AlbumsViewController;

@interface PhotosViewController : UIViewController

@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) AlbumsViewController *albumsViewController;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@end
