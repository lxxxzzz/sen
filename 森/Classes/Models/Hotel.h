//
//  Hotel.h
//  森
//
//  Created by Lee on 2017/6/1.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hotel : NSObject

@property (nonatomic, copy) NSString *hotel_id;
@property (nonatomic, copy) NSString *hotel_name;
@property (nonatomic, assign) NSInteger hotel_low;
@property (nonatomic, assign) NSInteger hotel_high;
@property (nonatomic, assign) NSInteger hotel_max_desk;
@property (nonatomic, copy) NSString *area_sh_name;
@property (nonatomic, copy) NSString *hotel_type;
@property (nonatomic, copy) NSString *hotel_phone;
@property (nonatomic, copy) NSString *hotel_image;
@property (nonatomic, strong) NSArray *hotel_images;
@property (nonatomic, copy) NSString *hotel_address;
@property (nonatomic, strong) NSArray *room_list;
@property (nonatomic, strong) NSArray *menu_list;

@end
