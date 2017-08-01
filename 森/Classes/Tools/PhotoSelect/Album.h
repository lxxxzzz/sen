//
//  Album.h
//  森
//
//  Created by Lee on 2017/5/8.
//  Copyright © 2017年 Lee. All rights reserved.
//  相册模型

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface Album : NSObject
// 相册名称
@property (nonatomic, copy) NSString *name;
// 中文名称
//@property (nonatomic, copy) NSString *chineseName;
// 相片数量
@property (nonatomic, assign) NSInteger count;
// 照片集合对象
@property (nonatomic, strong) PHFetchResult *result;
// 相册的封面
@property (nonatomic, strong) PHAsset *albumArt;
@property (nonatomic, strong) UIImage *albumArtImage;

@end
