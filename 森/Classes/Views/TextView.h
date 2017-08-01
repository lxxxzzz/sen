//
//  TextView.h
//  森
//
//  Created by Lee on 17/4/10.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, assign) NSInteger maxNumberOfWords;

@end
