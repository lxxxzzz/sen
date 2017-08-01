//
//  TextFieldItem.h
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BaseItem.h"

@interface TextFieldItem : BaseItem

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign, getter=isSecureTextEntry) BOOL secureTextEntry;

+ (instancetype)itemWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
                     required:(BOOL)required;
+ (instancetype)itemWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
                 keyboardType:(UIKeyboardType)keyboardType
                     required:(BOOL)required;
+ (instancetype)itemWithTitle:(NSString *)title
                    maxLength:(NSInteger)maxLength
                  placeholder:(NSString *)placeholder
                 keyboardType:(UIKeyboardType)keyboardType
                     required:(BOOL)required;

@end
