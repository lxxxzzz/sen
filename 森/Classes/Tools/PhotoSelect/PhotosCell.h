//
//  PhotosCell.h
//  森
//
//  Created by Lee on 2017/5/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo, PhotosCell;

@protocol PhotoListCellDelegate <NSObject>

@optional
- (void)photosCellSelectBtnDidClick:(PhotosCell *)cell;

@end

@interface PhotosCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (strong, nonatomic) Photo *photo;
@property (nonatomic, copy) void(^selectBtnClick)(BOOL selected);
@property (nonatomic, weak) id <PhotoListCellDelegate> delegate;

@end
