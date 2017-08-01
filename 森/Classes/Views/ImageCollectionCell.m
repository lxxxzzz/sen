//
//  ImageCollectionCell.m
//  森
//
//  Created by Lee on 2017/7/11.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ImageCollectionCell.h"
#import "ImageCell.h"


@interface ImageCollectionCell() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation ImageCollectionCell

static NSString *const kImageCellID = @"kImageCellID";
static const CGFloat spacing = 1.0f;  /**< 图片间距 */
static const CGFloat itemSize = 85.0f;  /**< 图片间距 */

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"ImageCollectionCell";
    ImageCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ImageCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        [_collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:kImageCellID];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(itemSize, itemSize);
        _layout.minimumLineSpacing      = spacing;
        _layout.minimumInteritemSpacing = spacing;
    }
    return _layout;
}

@end
