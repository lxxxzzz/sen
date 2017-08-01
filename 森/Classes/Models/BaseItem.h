//
//  BaseItem.h
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) id value;
@property (nonatomic, assign, getter=isRequired) BOOL required;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, copy) void(^valueDidChange)(id value);
+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title
                     required:(BOOL)required;
+ (instancetype)itemWithTitle:(NSString *)title
                        value:(id)value
                     required:(BOOL)required;

@end
