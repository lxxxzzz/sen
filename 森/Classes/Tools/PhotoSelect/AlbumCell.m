//
//  AlbumCell.m
//  森
//
//  Created by Lee on 2017/5/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "AlbumCell.h"
#import "Album.h"
#import "PhotoManager.h"

@interface AlbumCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation AlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AlbumCell";
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AlbumCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 5;
    CGFloat iconSize = self.frame.size. height - (2 * margin);
    self.icon.frame = CGRectMake(20, margin, iconSize, iconSize);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.icon.frame) + 20, 0, self.frame.size.width - (CGRectGetMaxX(self.icon.frame) + 20), self.frame.size.height);
}

- (void)setAlbum:(Album *)album {
    _album = album;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[[PhotoManager manager] albumChineseNameWithAlbum:album], album.count];
    __weak typeof(self) weakself = self;
    [[PhotoManager manager] fetchImageForAsset:album.albumArt size:CGSizeMake(180, 180) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
        weakself.icon.image = image;
    }];
}

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.clipsToBounds = YES;
    }
    return _icon;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

@end
