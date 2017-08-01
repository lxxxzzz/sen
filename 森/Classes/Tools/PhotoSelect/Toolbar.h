//
//  Toolbar.h
//  森
//
//  Created by Lee on 2017/5/9.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Toolbar;

@protocol ToolbarDelegate <NSObject>

@optional
- (void)toolbarFinishBtnDidClick:(Toolbar *)toolbar;
- (void)toolbarPreviewBtnDidClick:(Toolbar *)toolbar;

@end

@interface Toolbar : UIView

@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger selectedCount;
@property (nonatomic, weak) id <ToolbarDelegate> delegate;

@end
