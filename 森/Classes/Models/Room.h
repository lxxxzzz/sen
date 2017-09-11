//
//  Room.h
//  森
//
//  Created by Lee on 2017/6/10.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject

@property (nonatomic, strong) NSArray *room_image;
@property (nonatomic, copy) NSString *room_name;
@property (nonatomic, copy) NSString *room_max_desk;
@property (nonatomic, copy) NSString *room_high;
@property (nonatomic, copy) NSString *room_lz;
@property (nonatomic, copy) NSString *room_min_desk;
@property (nonatomic, copy) NSString *room_best_desk;
@property (nonatomic, copy) NSString *room_m;

- (NSArray *)getEncodingImages;

@end
