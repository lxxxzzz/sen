//
//  PhotoWallCell.h
//  森
//
//  Created by Lee on 2017/5/9.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo, PhotoWallCell;

@protocol PhotoWallCellDelegate <NSObject>

@optional
- (void)photoWallCellCloseBtnDidClick:(PhotoWallCell *)cell;
- (void)photoWallCell:(PhotoWallCell *)cell deletePhoto:(Photo *)photo;

@end

@interface PhotoWallCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) id photo; //只能是UIImage或者Photo
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, weak) id <PhotoWallCellDelegate> delegate;

@end
