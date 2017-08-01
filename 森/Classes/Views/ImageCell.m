//
//  ImageCell.m
//  森
//
//  Created by Lee on 2017/6/21.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ImageCell.h"
#import <UIImageView+WebCache.h>
#import <UIImage+WebP.h>
#import <SDWebImageDownloader.h>

@interface ImageCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    
    __weak typeof(self) weakself = self;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        NSString *extension = [url pathExtension];
        if ([extension isEqualToString:@"webp"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.imageView.image = [UIImage sd_imageWithWebPData:data];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.imageView.image = image;
            });
        }
        
    }];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
