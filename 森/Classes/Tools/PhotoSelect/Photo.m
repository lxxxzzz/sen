//
//  Photo.m
//  美UI
//
//  Created by Lee on 17/2/18.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "Photo.h"
#import "PhotoManager.h"
#import <Photos/Photos.h>

@implementation Photo

- (CGSize)size {
    if (_size.width == 0 || _size.height == 0) {
        _size = CGSizeMake(self.asset.pixelWidth, self.asset.pixelHeight);
    }
    return _size;
}

- (CGSize)endImageSize {
    if (_endImageSize.width == 0 || _endImageSize.height == 0) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height - 64;
        CGFloat imgWidth = self.size.width;
        CGFloat imgHeight = self.size.height;
        CGFloat w;
        CGFloat h;
        imgHeight = width / imgWidth * imgHeight;
        if (imgHeight > height) {
            w = height / self.size.height * imgWidth;
            h = height;
        }else {
            w = width;
            h = imgHeight;
        }
        _endImageSize = CGSizeMake(w, h);
    }
    return _endImageSize;
}

- (BOOL)isEqual:(Photo *)object {
    return [self.asset.localIdentifier isEqualToString:object.asset.localIdentifier];
}

- (UIImage *)hdImage {
    if (_hdImage == nil) {
        [[PhotoManager manager] fetchImageForAsset:self.asset size:CGSizeMake(self.asset.pixelWidth * 0.5, self.asset.pixelHeight * 0.5) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
            _hdImage = image;
        }];
    }
    return _hdImage;
}

@end
