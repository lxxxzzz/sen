//
//  TextViewItem.h
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "BaseItem.h"

@interface TextViewItem : BaseItem

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, assign) CGFloat height;

+ (instancetype)itemWithTitle:(NSString *)title
                        value:(NSString *)value
                  placeholder:(NSString *)placeholder
                       height:(CGFloat)height
                     required:(BOOL)required;

@end
