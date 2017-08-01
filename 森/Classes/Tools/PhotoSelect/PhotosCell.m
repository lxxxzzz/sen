//
//  PhotosCell.m
//  森
//
//  Created by Lee on 2017/5/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PhotosCell.h"
#import "Photo.h"
#import "PhotoManager.h"

@interface PhotosCell ()


@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) CAKeyframeAnimation *animation;

@end

@implementation PhotosCell

static NSString * const selectBtnAnimationKey = @"selectBtnAnimationKey";

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.maskView];
        [self.contentView addSubview:self.selectBtn];
    }
    return self;
}

- (void)click:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(photosCellSelectBtnDidClick:)]) {
        [self.delegate photosCellSelectBtnDidClick:self];
    }
}

- (void)setPhoto:(Photo *)photo {
    _photo = photo;
//    self.imageView.image = photo.image;
    self.selectBtn.selected = photo.isSelected;
    __weak typeof(self) weakself = self;
    [[PhotoManager manager] fetchImageForAsset:photo.asset size:CGSizeMake(180, 180) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
        weakself.imageView.image = image;
    }];

    if (photo.isSelected) {
        [self.selectBtn.layer addAnimation:self.animation forKey:selectBtnAnimationKey];
    } else {
        [self.selectBtn.layer removeAnimationForKey:selectBtnAnimationKey];
    }
    self.maskView.hidden = !photo.isSelected;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat btnW = 40;
    self.selectBtn.frame = CGRectMake(self.frame.size.width - btnW, 0, btnW, btnW);
    self.imageView.frame = self.bounds;
    self.maskView.frame = self.bounds;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)selectBtn {
    if (_selectBtn == nil) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"ico_check_nomal"] forState:UIControlStateNormal];
//        [_selectBtn setImage:[UIImage imageNamed:@"ico_check_nomal"] forState:UIControlStateNormal | UIControlStateHighlighted];
        [_selectBtn setImage:[UIImage imageNamed:@"ico_check_select"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _maskView.hidden = YES;
    }
    return _maskView;
}

- (CAKeyframeAnimation *)animation {
    if (_animation == nil) {
        _animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        _animation.duration = 0.25;
        _animation.values = @[@(1.2),@(0.8),@(1.1),@(0.9),@(1.0)];
    }
    return _animation;
}

@end
