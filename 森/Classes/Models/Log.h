//
//  Log.h
//  森
//
//  Created by Lee on 2017/5/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Log : NSObject

// 状态 1有效、2无效、3签单
@property (nonatomic, assign) NSInteger user_order_status;
@property (nonatomic, copy) NSString *title;
// 下次跟进时间
@property (nonatomic, assign) NSTimeInterval order_follow_time;
// 描述
@property (nonatomic, copy) NSString *order_follow_desc;
// 备注时间
@property (nonatomic, assign) NSTimeInterval order_follow_create_time;

@end
