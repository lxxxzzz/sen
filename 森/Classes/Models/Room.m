//
//  Room.m
//  森
//
//  Created by Lee on 2017/6/10.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "Room.h"
#import "NSURL+chinese.h"

@implementation Room

- (NSArray *)getEncodingImages {
    NSMutableArray *encodingArray = [NSMutableArray array];
    for (NSString *url in self.room_image) {
        NSURL *encodeingURL = [NSURL xx_URLWithString:url];
        [encodingArray addObject:encodeingURL];
    }
    return encodingArray;
}

@end
