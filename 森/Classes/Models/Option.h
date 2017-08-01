//
//  Option.h
//  森
//
//  Created by Lee on 17/4/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Option : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
+ (instancetype)optionWithTitle:(NSString *)title value:(NSString *)value;

@end
