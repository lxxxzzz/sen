//
//  PhotoBrowserCell.m
//  森
//
//  Created by Lee on 2017/5/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PhotoBrowserCell.h"
#import "PhotoManager.h"
#import "Photo.h"
#import <UIImageView+WebCache.h>

@interface PhotoBrowserCell ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation PhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.contentView.bounds;
//    self.imageView.frame = self.scrollView.bounds;
    
    Log(@"%@",NSStringFromCGSize(self.imageView.frame.size));
}

- (void)setPhoto:(id)photo {
    _photo = photo;
    
    __weak typeof(self) weakself = self;

    if ([photo isKindOfClass:[Photo class]]) {
        Photo *p = (Photo *)photo;
        if (p.hdImage) {
            UIImage *image = p.hdImage;
            weakself.imageView.image = image;
            CGFloat height = self.frame.size.width * image.size.height / image.size.width;
            CGFloat y = (self.frame.size.height - height) / 2.0;
            weakself.imageView.frame = CGRectMake(0, y, self.frame.size.width, height);
            weakself.scrollView.contentSize = CGSizeMake(self.frame.size.width, height);
        } else {
        
            CGFloat width = self.contentView.frame.size.width;
            CGFloat height = width * p.asset.pixelHeight / p.asset.pixelWidth;
            
            [[PhotoManager manager] fetchImageForAsset:p.asset size:CGSizeMake(width, height) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
                weakself.imageView.image = image;
                CGFloat height = self.frame.size.width * image.size.height / image.size.width;
                CGFloat y = (self.frame.size.height - height) / 2.0;
                weakself.imageView.frame = CGRectMake(0, y, self.frame.size.width, height);
                weakself.scrollView.contentSize = CGSizeMake(self.frame.size.width, height);
            }];
        }
    } else {
        [weakself.imageView sd_setImageWithURL:[NSURL URLWithString:photo] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                CGFloat height = self.frame.size.width * image.size.height / image.size.width;
                CGFloat y = (self.frame.size.height - height) / 2.0;
                weakself.imageView.frame = CGRectMake(0, y, self.frame.size.width, height);
                weakself.scrollView.contentSize = CGSizeMake(self.frame.size.width, height);
            }
        }];
    }
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = NO;
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.userInteractionEnabled = NO;
    }
    return _scrollView;
}

@end
