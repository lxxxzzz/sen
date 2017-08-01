//
//  PayList.h
//  森
//
//  Created by Lee on 2017/6/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "sign_type": "5",
 "order_money": "300000",
 "order_time": "1498567632",
 "first_order_money": "20000",
 "first_order_using_time": "1498567577",
 "other_item_weikuan_old_time": "1498567632",
 "other_item_weikuan_new_time": "0",
 "order_sign_pic": [
 "http://sendevimg.oss-cn-zhangjiakou.aliyuncs.com/upload/user_app/CB9C0512-9E45-4A69-B8B1-05AE11E8A4C1-2017-06-27-08:47:10:753.png",
 "http://sendevimg.oss-cn-zhangjiakou.aliyuncs.com/upload/user_app/7D827CB3-CB7D-4D1E-9625-735F60459BBD-2017-06-27-08:47:11:288.png",
 "http://sendevimg.oss-cn-zhangjiakou.aliyuncs.com/upload/user_app/97061DD3-2F0B-4B4B-B166-231D4F7CBC6B-2017-06-27-08:47:11:860.png"
 ]
 
 */

@interface PayList : NSObject

@property (nonatomic, assign) NSInteger sign_type;
@property (nonatomic, copy) NSString *order_money;
@property (nonatomic, copy) NSString *order_time;
@property (nonatomic, copy) NSString *first_order_money;
@property (nonatomic, copy) NSString *first_order_using_time;
@property (nonatomic, copy) NSString *other_item_weikuan_old_time;
@property (nonatomic, copy) NSString *other_item_weikuan_new_time;
@property (nonatomic, strong) NSArray *order_sign_pic;

@end
