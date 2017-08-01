//
//  PhotoBrowserCell.h
//  森
//
//  Created by Lee on 2017/5/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo;

@interface PhotoBrowserCell : UICollectionViewCell

@property (nonatomic, strong) id photo;
@property (nonatomic, strong) UIImageView *imageView;

@end
