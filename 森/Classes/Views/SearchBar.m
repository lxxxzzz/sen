//
//  SearchBar.m
//  森
//
//  Created by Lee on 2017/7/26.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self sizeToFit];
        [self setPlaceholder:@"请输入酒店名称"];
        [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self setSearchTextFieldBackgroundColor:HEXA(@"#ffffff", 0.4)];
//        [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor redColor]];
        [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];
        [self setImage:IMAGE(@"search") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [self setImage:IMAGE(@"clear") forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    }
    return self;
}

- (void)clearButtonOnClick {
    Log(@"呵呵呵");
}

- (void)setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor {
    UITextField *searchTextField = nil;
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    self.barTintColor = HEXA(@"#ffffff", 0.4);
    searchTextField = [[[self.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = backgroundColor;
    searchTextField.textColor = [UIColor whiteColor];
    [searchTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIButton *clearButton = [searchTextField valueForKeyPath:@"_clearButton"];
    
    clearButton.backgroundColor = [UIColor redColor];
//    [clearButton addTarget:self action:@selector(clearButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    Log(@">>>>%@", [searchTextField valueForKeyPath:@"_clearButton"]);
}


@end
