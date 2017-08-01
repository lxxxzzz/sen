//
//  HotelListCell.m
//  森
//
//  Created by Lee on 2017/5/22.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HotelListCell.h"
#import "Hotel.h"
#import <UIImageView+WebCache.h>

@interface HotelListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *telephone;

@end

@implementation HotelListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.hotelName.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.hotelName.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];

    self.price.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    self.price.textColor = HEX(@"#313133");
    
    self.area.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.area.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];

    self.telephone.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.telephone.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:102/255.0 alpha:1/1.0];
    
    self.count.textColor = HEX(@"#939399");
}

- (void)setHotel:(Hotel *)hotel {
    _hotel = hotel;
    self.hotelName.text = hotel.hotel_name;
    self.price.text = [NSString stringWithFormat:@"￥%ld-%ld/桌", hotel.hotel_low, hotel.hotel_high];

    self.count.text = [NSString stringWithFormat:@"桌数：%ld", hotel.hotel_max_desk];
    self.area.text = [NSString stringWithFormat:@"%@  %@", hotel.area_sh_name, hotel.hotel_type];
    self.telephone.text = hotel.hotel_phone;

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:hotel.hotel_image]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"HotelListCell";
    HotelListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
