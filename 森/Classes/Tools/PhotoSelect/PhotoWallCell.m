//
//  PhotoWallCell.m
//  森
//
//  Created by Lee on 2017/5/9.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PhotoWallCell.h"
#import "Photo.h"
#import "PhotoManager.h"
#import "NSURL+chinese.h"
#import <UIImageView+WebCache.h>

@interface PhotoWallCell ()

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation PhotoWallCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.closeBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    CGFloat btnW = 20;
    self.closeBtn.frame = CGRectMake(self.frame.size.width - btnW, 0, btnW, btnW);
}

- (void)deleteImage {
    if ([self.delegate respondsToSelector:@selector(photoWallCellCloseBtnDidClick:)]) {
        [self.delegate photoWallCellCloseBtnDidClick:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(photoWallCell:deletePhoto:)]) {
        [self.delegate photoWallCell:self deletePhoto:self.photo];
    }
}

- (void)setPhoto:(id)photo {
    _photo = photo;
    
    if (photo) {
        __weak typeof(self) weakself = self;
        if ([photo isKindOfClass:[Photo class]]) {
            Photo *p = (Photo *)photo;
            if (p.hdImage) {
                weakself.imageView.image = p.hdImage;
            } else {
                [[PhotoManager manager] fetchImageForAsset:p.asset size:CGSizeMake(300, 300) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
                    if (image) {
                        weakself.imageView.image = image;
                        weakself.userInteractionEnabled = YES;
                    } else {
                        weakself.userInteractionEnabled = NO;
                    }
                    
                }];
            }
        } else{
            [weakself.imageView sd_setImageWithURL:[NSURL xx_URLWithString:photo] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    weakself.userInteractionEnabled = YES;
                } else {
                    weakself.userInteractionEnabled = NO;
                }
            }];
        }
        self.closeBtn.hidden = NO;
    } else {
        self.imageView.image = IMAGE(@"plus");
        self.closeBtn.hidden = YES;
    }
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;

    if (self.photo && editable) {
        self.closeBtn.hidden = NO;
    } else {
        self.closeBtn.hidden = YES;
    }
    
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)closeBtn {
    if (_closeBtn == nil) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:IMAGE(@"compose_photo_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
