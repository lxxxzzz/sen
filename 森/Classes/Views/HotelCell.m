//
//  HotelCell.m
//  森
//
//  Created by Lee on 2017/6/1.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HotelCell.h"
#import "Room.h"
#import "NSURL+chinese.h"
#import <UIImageView+WebCache.h>

@interface HotelCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@end

@implementation HotelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"HotelListCell";
    HotelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setRoom:(Room *)room {
    _room = room;
//    NSString *url = [room.room_image firstObject];
//    NSString *encodedString = [[room.room_image firstObject] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:encodedString];
    [self.iconImageView sd_setImageWithURL:[NSURL xx_URLWithString:[room.room_image firstObject]]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@", room.room_name];
    self.infoLabel.text = [NSString stringWithFormat:@"桌数：%@   层高：%@   立柱：%@", room.room_best_desk, room.room_high, room.room_lz];
}

@end
