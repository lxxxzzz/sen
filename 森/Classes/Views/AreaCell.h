//
//  AreaCell.h
//  森
//
//  Created by Lee on 2017/5/23.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Option;

static NSString *const kAreaCellID = @"kAreaCellID";

@interface AreaCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) Option *option;

@end
