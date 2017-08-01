//
//  PhotoManager.h
//  森
//
//  Created by Lee on 2017/5/4.
//  Copyright © 2017年 Lee. All rights reserved.
//


typedef NS_ENUM(NSInteger, DefaultControllerOptions) {
    DefaultControllerOptionsAlbums = 0, // 默认跳转到相册
    DefaultControllerOptionsCameraRoll = 1, // 默认跳转到“相机胶卷”
    DefaultControllerOptionsScreenshots = 2, // 默认跳转到“屏幕快照”
    DefaultControllerOptionsRecentlyAdded = 3, // 默认跳转到“最近添加”
    DefaultControllerOptionsSelfies = 4, // 默认跳转到“自拍”
    DefaultControllerOptionsPanoramas = 5, // 默认跳转到“全景照片”
    DefaultControllerOptionsFavorites = 6, // 默认跳转到“个人收藏”
    DefaultControllerOptionsBursts = 7, // 默认跳转到“连拍快照”
    DefaultControllerOptionsMyPhotoStream = 8, // 默认跳转到“我的照片流”
    DefaultControllerOptionsSlomo = 9, // 默认跳转到“慢动作”
    DefaultControllerOptionsTimelapse = 10, // 默认跳转到“延时摄影”
    DefaultControllerOptionsVideos = 20, // 默认跳转到“视频”
    DefaultControllerOptionsRecentlyDeleted = 30, // 默认跳转到“最近删除”
    DefaultControllerOptionsAllPhotos = 100, // 默认跳转到“所有照片”
};

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class Album, Photo;

UIKIT_EXTERN NSString * const AlbumNameCameraRollKey;
UIKIT_EXTERN NSString * const AlbumNameScreenshotsKey;
UIKIT_EXTERN NSString * const AlbumNameRecentlyAddedKey;
UIKIT_EXTERN NSString * const AlbumNameSelfiesKey;
UIKIT_EXTERN NSString * const AlbumNamePanoramasKey;
UIKIT_EXTERN NSString * const AlbumNameFavoritesKey;
UIKIT_EXTERN NSString * const AlbumNameBurstsKey;
UIKIT_EXTERN NSString * const AlbumNameMyPhotoStreamKey;
UIKIT_EXTERN NSString * const AlbumNameSlomoKey;
UIKIT_EXTERN NSString * const AlbumNameTimelapseKey;
UIKIT_EXTERN NSString * const AlbumNameVideosKey;
UIKIT_EXTERN NSString * const AlbumNameRecentlyDeletedKey;
UIKIT_EXTERN NSString * const AlbumNameRecentlyAllPhotos;

@interface PhotoManager : NSObject

@property (nonatomic, strong) NSMutableArray *albums;
// 默认跳转控制器
@property (nonatomic, assign) DefaultControllerOptions options;
// 最大选择照片数量，默认8张
@property (nonatomic, assign) NSInteger maxSelectCount;
@property (nonatomic, copy) void(^selectPhotosHandler)(NSArray *photos);

+ (instancetype)manager;
- (void)openAlbum;
- (void)openAlbumWithOptions:(DefaultControllerOptions)options completion:(void(^)(NSArray *photos))completion;
- (void)openAlbumWithPhotos:(NSArray *)photos completion:(void (^)(NSArray *photos))completion;
- (NSString *)defaultAlbumName;
- (NSString *)albumChineseNameWithAlbum:(Album *)album;
- (void)requestAuthorization:(void(^)(BOOL authorization))handler;
- (void)fetchAllAlbumsCompletion:(void(^)(NSArray <Album *>*albums))completion;

- (void)fetchAllPhotosForResult:(PHFetchResult *)result
                     completion:(void (^)(NSArray<Photo *> *photos))completion;

- (PHImageRequestID)fetchImageForAsset:(PHAsset *)asset
                      size:(CGSize)size
                resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
                completion:(void(^)(UIImage *image, NSDictionary *info))completion;

- (PHImageRequestID)fetchPhotoDataForPHAsset:(PHAsset *)asset
                                  completion:(void (^)(NSData *, NSDictionary *))completion;

- (void)fetchHDImageForResult:(PHFetchResult *)result completion:(void (^)(NSArray *images))completion;
- (void)fetchHDImageForAsset:(PHAsset *)asset completion:(void (^)(UIImage *image))completion;
//- (void)selectedPhotoHandler:(void(^)(NSArray *photos))handler;

@end
