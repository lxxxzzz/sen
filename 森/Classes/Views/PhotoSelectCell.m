//
//  PhotoSelectCell.m
//  森
//
//  Created by Lee on 2017/5/3.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PhotoSelectCell.h"
#import <Masonry.h>
#import "PhotoBrowserViewController.h"
#import "PhotoWallCell.h"
#import "Photo.h"
#import "PhotoManager.h"


static const CGFloat spacing = 1.0f;  /**< 图片间距 */
static const NSInteger maxCountInLine = 4; /**< 每行显示图片张数 */
static NSString *const kPhotoWallCellID = @"PhotoWallCellID";

@interface PhotoSelectCell () <UICollectionViewDelegate, UICollectionViewDataSource, PhotoWallCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation PhotoSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self setupSubviews];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.collectionView];
        self.photos = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"PhotoSelectCell";
    PhotoSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PhotoSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = (self.frame.size.width - spacing * (maxCountInLine - 1)) / maxCountInLine;
    
    
    CGFloat x = 15;
    self.titleLabel.frame = CGRectMake(x, 16, self.frame.size.width - 2 * x, 20);
    CGFloat collectionViewY = CGRectGetMaxY(self.titleLabel.frame) + 34;
    self.collectionView.frame = CGRectMake(15, CGRectGetMaxY(self.titleLabel.frame) + 34, self.titleLabel.frame.size.width, self.frame.size.height - (collectionViewY + 20));
}

//- (void)setupSubviews {
//    [self.contentView addSubview:self.titleLabel];
//    [self.contentView addSubview:self.photoWallView];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
//        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
//    }];
//    
//    [self.photoWallView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView.mas_left).offset(38);
//        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(34);
//        make.right.mas_equalTo(self.contentView.mas_right).offset(-38);
//        make.height.mas_equalTo(100);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-28);
//    }];
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.editable) {
        return self.photos.count + 1;
    }
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PhotoWallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoWallCellID forIndexPath:indexPath];
    if (self.editable) {
        // 可编辑的情况下
        if (indexPath.row == self.photos.count) {
            cell.photo = nil;
        } else {
            cell.photo = self.photos[indexPath.row];
        }
    } else {
        cell.photo = self.photos[indexPath.row];
    }
    cell.editable = self.editable;
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.photos.count && self.editable) {
        // 点了加号按钮
        if ([self.delegate respondsToSelector:@selector(photoSelectCellAdd:)]) {
            [self.delegate photoSelectCellAdd:self];
        }
    } else {
        // 点击了照片
        PhotoBrowserViewController *vc = [[PhotoBrowserViewController alloc] initWithImages:self.photos selectedIndex:indexPath.row];
        vc.sourceCollectionView = collectionView;
        [vc show];
    }
}

- (void)photoWallCell:(PhotoWallCell *)cell deletePhoto:(Photo *)photo {
    [self.photos removeObject:photo];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    UIView *mirrorView = [cell snapshotViewAfterScreenUpdates:NO];
    mirrorView.frame = cell.frame;
    [self.collectionView insertSubview:mirrorView atIndex:0];
    cell.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        mirrorView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        cell.hidden = NO;
        [mirrorView removeFromSuperview];
    }];
    
    if ((self.photos.count + 1) % maxCountInLine == 0) {
        if ([self.delegate respondsToSelector:@selector(photoSelectCellHeightDidChange:height:)]) {
            [self.delegate photoSelectCellHeightDidChange:self height:[self cellHeight]];
        }
    }
}


- (CGFloat)cellHeight {
    [self setNeedsDisplay];
    
    CGFloat height = 16 + 20 + 34 + 20;
    
    int rowCount = ceil((self.photos.count + 1/*还有加号按钮*/) / 4.0);

    return height + rowCount * self.layout.itemSize.width + (rowCount - 1) * spacing;
}

- (void)setPhotos:(NSMutableArray *)photos {
    if (photos == nil || [photos isKindOfClass:[NSNull class]]) {
        // 容错处理
        photos = [NSMutableArray array];
    }
    
    _photos = photos;
    
    [self.collectionView reloadData];
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[PhotoWallCell class] forCellWithReuseIdentifier:kPhotoWallCellID];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(85, 85);
        _layout.minimumLineSpacing      = spacing;
        _layout.minimumInteritemSpacing = spacing;
    }
    return _layout;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"在此上传（合同）与（收据）照片";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _titleLabel;
}


@end
