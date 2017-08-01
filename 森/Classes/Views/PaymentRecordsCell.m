//
//  PaymentRecordsCell.m
//  森
//
//  Created by Lee on 2017/7/15.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PaymentRecordsCell.h"
#import "ImageCell.h"
#import "PhotoBrowserViewController.h"
#import "PayList.h"

@interface PaymentRecordsCell () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UITableView *tableView;

@end


@implementation PaymentRecordsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self setupSubviews];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"PaymentRecordsCell";
    PaymentRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PaymentRecordsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 1 中款 2尾款 3附加款 4尾款时间 5首款
    if (self.paylist.sign_type == 5) {
        if (self.paylist.order_sign_pic.count) {
            // 有图片
            return 5;
        }
        return 4; // 没有图片
    } else {
        if (self.paylist.order_sign_pic.count) {
            // 有图片
            return 3;
        }
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate

#pragma mark - UICollectionViewSource


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

@end
