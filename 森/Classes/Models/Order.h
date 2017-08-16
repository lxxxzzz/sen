//
//  Order.h
//  森
//
//  Created by Lee on 2017/6/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OrderStatus){
    OrderStatusUndefined = 0,
    OrderStatusDaichuli = 1,
    OrderStatusDaishenhe = 2,
    OrderStatusDaijiesuan = 3,
    OrderStatusYijiesuan = 4,
    OrderStatusYibohui = 5,
    OrderStatusYiquxiao = 6,
    OrderStatusYiwanjie = 7,
    OrderStatusGenjinzhong = 8,
};

typedef NS_ENUM(NSInteger, OrderType){
    OrderTypeKezi = 0,
    OrderTypeDajian = 1,
    
};

@interface Order : NSObject

@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, assign) NSInteger order_status;
@property (nonatomic, assign) NSInteger erxiao_sign_type;
@property (nonatomic, assign) NSTimeInterval create_time;
@property (nonatomic, copy) NSString *order_phone;
@property (nonatomic, copy) NSString *watch_user;

@property (nonatomic, assign) OrderStatus status;
@property (nonatomic, assign) OrderType type;
@property (nonatomic, copy) NSString *erxiao_status;

@property (nonatomic, copy) NSString *order_from;
@property (nonatomic, assign) BOOL showSource;

@end
