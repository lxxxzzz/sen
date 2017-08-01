//
//  TableView.h
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableView : UITableView

@property (nonatomic, copy) NSString *footerTitle;
- (void)addTarget:(id)target action:(SEL)action;

@end
