//
//  PhotoManager.m
//  森
//
//  Created by Lee on 2017/5/4.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PhotoManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "Album.h"
#import "Photo.h"
#import "AlbumsViewController.h"
#import "NavigationViewController.h"

NSString * const AlbumNameCameraRollKey                        = @"Camera Roll";
NSString * const AlbumNameScreenshotsKey                       = @"Screenshots";
NSString * const AlbumNameRecentlyAddedKey                     = @"Recently Added";
NSString * const AlbumNameSelfiesKey                           = @"Selfies";
NSString * const AlbumNamePanoramasKey                         = @"Panoramas";
NSString * const AlbumNameFavoritesKey                         = @"Favorites";
NSString * const AlbumNameBurstsKey                            = @"Bursts";
NSString * const AlbumNameMyPhotoStreamKey                     = @"My Photo Stream";
NSString * const AlbumNameSlomoKey                             = @"Slo-mo";
NSString * const AlbumNameTimelapseKey                         = @"Time-lapse";
NSString * const AlbumNameVideosKey                            = @"Videos";
NSString * const AlbumNameRecentlyDeletedKey                   = @"Recently Deleted";
NSString * const AlbumNameRecentlyAllPhotos                    = @"All Photos";

@interface PhotoManager () <AlbumsViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *albumNameDict;

@end

@implementation PhotoManager

static PhotoManager *_instance;

#pragma mark 单利
+ (instancetype)manager {
    return [[self alloc]init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            _instance.albums = [NSMutableArray array];
            _instance.maxSelectCount = 8;
            _instance.albumNameDict = @{AlbumNameBurstsKey : @"连拍快照",
                                        AlbumNameRecentlyAddedKey : @"最近添加",
                                        AlbumNameScreenshotsKey : @"屏幕快照",
                                        AlbumNameCameraRollKey : @"相机胶卷",
                                        AlbumNameSelfiesKey : @"自拍",
                                        AlbumNameMyPhotoStreamKey : @"我的照片流",
                                        AlbumNameVideosKey : @"视频",
                                        AlbumNameRecentlyAllPhotos : @"所有照片",
                                        AlbumNameSlomoKey : @"慢动作",
                                        AlbumNameRecentlyDeletedKey : @"最近删除",
                                        AlbumNameFavoritesKey : @"个人收藏",
                                        AlbumNamePanoramasKey : @"全景照片",
                                        AlbumNameTimelapseKey : @"延时摄影"};
        }
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

#pragma mark 公共方法
- (void)openAlbum {
    [self openAlbumWithOptions:DefaultControllerOptionsAlbums completion:nil];
}

- (void)requestAuthorization:(void (^)(BOOL))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            if (handler) {
                handler(YES);
            }
        } else {
            if (handler) {
                handler(NO);
            }
        }
    }];
}

- (void)openAlbumWithOptions:(DefaultControllerOptions)options completion:(void (^)(NSArray *))completion {
    self.options = options;
    self.selectPhotosHandler = completion;
    dispatch_async(dispatch_get_main_queue(), ^{
        AlbumsViewController *albumsVc = [[AlbumsViewController alloc] init];
        albumsVc.delegate = self;
        NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:albumsVc];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    });
}

- (void)openAlbumWithPhotos:(NSArray *)photos completion:(void (^)(NSArray *))completion {
    self.options = DefaultControllerOptionsCameraRoll;
    self.selectPhotosHandler = completion;
    dispatch_async(dispatch_get_main_queue(), ^{
        AlbumsViewController *albumsVc = [[AlbumsViewController alloc] init];
        albumsVc.delegate = self;
        albumsVc.selectedPhotos = photos;
        NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:albumsVc];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    });
}

- (NSString *)defaultAlbumName {
    if (self.options == DefaultControllerOptionsCameraRoll) {
        // 默认跳转到“相机胶卷”
        return [self.albumNameDict objectForKey:AlbumNameCameraRollKey];
    } else if (self.options == DefaultControllerOptionsScreenshots) {
        // 默认跳转到“屏幕快照”
        return [self.albumNameDict objectForKey:AlbumNameScreenshotsKey];
    } else if (self.options == DefaultControllerOptionsRecentlyAdded) {
        // 默认跳转到“最近添加”
        return [self.albumNameDict objectForKey:AlbumNameRecentlyAddedKey];
    } else if (self.options == DefaultControllerOptionsSelfies) {
        // 默认跳转到“自拍”
        return [self.albumNameDict objectForKey:AlbumNameSelfiesKey];
    } else if (self.options == DefaultControllerOptionsPanoramas) {
        // 默认跳转到“全景照片”
        return [self.albumNameDict objectForKey:AlbumNamePanoramasKey];
    } else if (self.options == DefaultControllerOptionsFavorites) {
        // 默认跳转到“个人收藏”
        return [self.albumNameDict objectForKey:AlbumNameFavoritesKey];
    } else if (self.options == DefaultControllerOptionsBursts) {
        // 默认跳转到“相机胶卷”
        return [self.albumNameDict objectForKey:AlbumNameBurstsKey];
    } else if (self.options == DefaultControllerOptionsMyPhotoStream) {
        // 默认跳转到“我的照片流”
        return [self.albumNameDict objectForKey:AlbumNameMyPhotoStreamKey];
    } else if (self.options == DefaultControllerOptionsSlomo) {
        // 默认跳转到“慢动作”
        return [self.albumNameDict objectForKey:AlbumNameSlomoKey];
    } else if (self.options == DefaultControllerOptionsTimelapse) {
        // 默认跳转到“延时摄影”
        return [self.albumNameDict objectForKey:AlbumNameTimelapseKey];
    } else if (self.options == DefaultControllerOptionsVideos) {
        // 默认跳转到“视频”
        return [self.albumNameDict objectForKey:AlbumNameVideosKey];
    } else if (self.options == DefaultControllerOptionsRecentlyDeleted) {
        // 默认跳转到“最近删除”
        return [self.albumNameDict objectForKey:AlbumNameRecentlyDeletedKey];
    } else if (self.options == DefaultControllerOptionsAllPhotos) {
        // 默认跳转到“所有照片”
        return [self.albumNameDict objectForKey:AlbumNameRecentlyAllPhotos];
    }
    
    return nil;
}

- (NSString *)albumChineseNameWithAlbum:(Album *)album {
    NSString *chineseName = [self.albumNameDict objectForKey:album.name];
    if (chineseName == nil) {
        chineseName = album.name;
    }
    return chineseName;
}

- (BOOL)useable {
    return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized;
}

#pragma mark 获取所有相册
- (void)fetchAllAlbumsCompletion:(void (^)(NSArray <Album *>*))completion {
    [self.albums removeAllObjects];
    __weak typeof(self) weakself = self;
    
    // 获取用户相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        // 过滤掉空相册
        if (result.count > 0) {
            Log(@"数量:%ld \n名字:%@", result.count, collection.localizedTitle);
            Album *album = [[Album alloc] init];
            album.name = collection.localizedTitle;
            album.count = result.count;
            album.albumArt = result.lastObject;
            album.result = result;
            [weakself.albums addObject:album];
        }
    }];
    
    if (completion) {
        completion(self.albums);
    }
}

#pragma mark 获取相册里的所有照片
- (void)fetchAllPhotosForResult:(PHFetchResult *)result completion:(void (^)(NSArray<Photo *> *))completion {
    __block NSMutableArray *photos = [NSMutableArray array];
    for (PHAsset *asset in result) {
        Photo *photo = [[Photo alloc] init];
        photo.asset = asset;
//        [self fetchImageForAsset:asset size:CGSizeMake(asset.pixelWidth, asset.pixelHeight) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
//            photo.hdImage = image;
//        }];
        [photos addObject:photo];
    }
    if (completion) {
        completion(photos);
    }
}

- (void)fetchHDImageForResult:(PHFetchResult *)result completion:(void (^)(NSArray *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *photos = [NSMutableArray array];
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        //仅显示缩略图，不控制质量显示
        /**
         PHImageRequestOptionsResizeModeNone,
         PHImageRequestOptionsResizeModeFast, //根据传入的size，迅速加载大小相匹配(略大于或略小于)的图像
         PHImageRequestOptionsResizeModeExact //精确的加载与传入size相匹配的图像
         */
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        option.networkAccessAllowed = YES;
        [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
                //解析出来的图片
                [photos addObject:image];
            }];
        }];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(photos);
            });
        }
    });
    
}

- (void)fetchHDImageForAsset:(PHAsset *)asset completion:(void (^)(UIImage *image))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        //仅显示缩略图，不控制质量显示
        /**
         PHImageRequestOptionsResizeModeNone,
         PHImageRequestOptionsResizeModeFast, //根据传入的size，迅速加载大小相匹配(略大于或略小于)的图像
         PHImageRequestOptionsResizeModeExact //精确的加载与传入size相匹配的图像
         */
        //    option.resizeMode = PHImageRequestOptionsResizeModeFast;
        option.resizeMode = PHImageRequestOptionsResizeModeExact;
        option.networkAccessAllowed = YES;
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
            //解析出来的图片
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(image);
                });
            }
        }];
    });
}

- (PHImageRequestID)fetchPhotoDataForPHAsset:(PHAsset *)asset completion:(void (^)(NSData *, NSDictionary *))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.networkAccessAllowed = YES;
    return [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (imageData) {
            if (completion) completion(imageData,info);
        }
    }];
}

- (PHImageRequestID)fetchImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void(^)(UIImage *image, NSDictionary *info))completion {
    static PHImageRequestID requestID = -1;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, 500);
    if (requestID >= 1 && size.width / width == scale) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:requestID];
    }
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.resizeMode = resizeMode;
    requestID = [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                      targetSize:size
                                                     contentMode:PHImageContentModeAspectFill
                                                         options:options
                                                   resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                         
       BOOL didFinishDownload = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
       if (didFinishDownload && completion && result) {
           dispatch_async(dispatch_get_main_queue(), ^{
                completion(result, info);
           });
       }
    }];
    
    return requestID;
}

//- (void)selectedPhotoHandler:(void (^)(NSArray *))handler {
//    self.selectPhotosHandler = handler;
//}

- (void)albumsViewController:(AlbumsViewController *)viewController didSelectPhotos:(NSArray *)photos {
    for (id obj in photos) {
        if ([obj isKindOfClass:[Photo class]]) {
            Photo *photo = (Photo *)obj;
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            CGFloat height = width * photo.asset.pixelHeight / photo.asset.pixelWidth;
            [self fetchImageForAsset:photo.asset size:CGSizeMake(photo.asset.pixelWidth * 0.5, photo.asset.pixelHeight * 0.5) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
                photo.hdImage = image;
            }];
        }
        
//        [self fetchHDImageForAsset:photo.asset completion:^(UIImage *image) {
//            photo.hdImage = image;
//        }];
    }
    if (self.selectPhotosHandler) {
        self.selectPhotosHandler(photos);
    }
}

@end
