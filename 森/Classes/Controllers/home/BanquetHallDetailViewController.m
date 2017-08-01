//
//  BanquetHallDetailViewController.m
//  森
//
//  Created by Lee on 2017/5/23.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BanquetHallDetailViewController.h"
#import "Room.h"
#import <Masonry.h>
#import <SDCycleScrollView.h>

@interface BanquetHallDetailViewController () <SDCycleScrollViewDelegate>

@property (nonatomic, weak) UILabel *pageLabel;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *infoLabel;

@end

@implementation BanquetHallDetailViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - 私有方法
#pragma mark 布局
- (void)setupSubviews {
    self.view.backgroundColor = [UIColor blackColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:IMAGE(@"icons_back_white") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)imageURLStringsGroup:self.room.room_image];
    cycleScrollView.delegate = self;
    cycleScrollView.autoScroll = NO;
    cycleScrollView.infiniteLoop = NO;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cycleScrollView.autoScrollTimeInterval = 3;
    [self.view addSubview:cycleScrollView];
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.height.mas_equalTo(250);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(100);
    }];
    
    UILabel *pageLabel = [[UILabel alloc] init];
    pageLabel.textAlignment = NSTextAlignmentRight;
    pageLabel.textColor = [UIColor whiteColor];
    pageLabel.text = [NSString stringWithFormat:@"%d/%ld", 1, cycleScrollView.imageURLStringsGroup.count];
    [self.view addSubview:pageLabel];
    self.pageLabel = pageLabel;
    [pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(cycleScrollView.mas_bottom).offset(10);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    nameLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self.view addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pageLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(self.view.mas_left).offset(15);
    }];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    infoLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6];
    infoLabel.numberOfLines = 0;
    [self.view addSubview:infoLabel];
    self.infoLabel = infoLabel;
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(12);
    }];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@   %@", self.room.room_name, self.room.room_high];
    self.infoLabel.text = [NSString stringWithFormat:@"最佳容纳桌数：%@桌\n最多容纳桌数：%@桌\n最少容纳桌数：%@桌\n层高：%@\n面积：%@\n立柱：%@", self.room.room_best_desk, self.room.room_max_desk, self.room.room_min_desk, self.room.room_high, self.room.room_m, self.room.room_lz];
}

#pragma mark Action
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 代理方法
#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, cycleScrollView.imageURLStringsGroup.count];
}


@end
