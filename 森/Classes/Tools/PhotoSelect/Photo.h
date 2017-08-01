//
//  Photo.h
//  美UI
//
//  Created by Lee on 17/2/18.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PHAsset;

@interface Photo : NSObject

@property (nonatomic, strong) PHAsset *asset;
// 高清图
@property (nonatomic, strong) UIImage *hdImage;
// 小图
@property (nonatomic, strong) UIImage *thumbnailImage;
// 预览图
@property (nonatomic, strong) UIImage *previewImage;
// 二进制数据
@property (nonatomic, strong) NSData *data;
// 图片大小
@property (nonatomic, assign) CGSize size;
// 缩小之后的图片大小
@property (assign, nonatomic) CGSize endImageSize;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end
