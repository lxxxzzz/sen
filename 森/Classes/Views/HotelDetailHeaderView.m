//
//  HotelDetailHeaderView.m
//  森
//
//  Created by Lee on 2017/5/22.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HotelDetailHeaderView.h"
#import "Hotel.h"
#import <SDCycleScrollView.h>
#import <Masonry.h>

@interface HotelDetailHeaderView ()

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *priceLabel;

@end

@implementation HotelDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.cycleScrollView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.priceLabel];
        
        [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(self.cycleScrollView.mas_width).multipliedBy(200 / 375.0);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(9);
            make.top.mas_equalTo(self.cycleScrollView.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
            make.right.mas_equalTo(self.mas_right).offset(-9);
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        }];
    }
    return self;
}

- (void)setHotel:(Hotel *)hotel {
    _hotel = hotel;
    
    // 解决url中文
    NSMutableArray *urls = [NSMutableArray array];
    for (NSString *str in hotel.hotel_images) {
        NSString *encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [urls addObject:encodedString];
    }
    
    self.cycleScrollView.imageURLStringsGroup = urls;
    self.nameLabel.text = hotel.hotel_name;
    self.priceLabel.text = [NSString stringWithFormat:@"（￥%ld-%ld/桌  桌数:%ld）", hotel.hotel_low, hotel.hotel_high, hotel.hotel_max_desk];
}

- (SDCycleScrollView *)cycleScrollView {
    if (_cycleScrollView == nil) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)imageURLStringsGroup:@[]];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.pageDotColor = HEX(@"#ffffff");
        _cycleScrollView.currentPageDotColor = HEX(@"#ef563a");
        _cycleScrollView.pageControlDotSize = CGSizeMake(8, 8);
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _cycleScrollView.autoScrollTimeInterval = 3;
    }
    return _cycleScrollView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _nameLabel.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _priceLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _priceLabel;
}

@end
