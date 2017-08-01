//
//  ItemGroup.h
//  森
//
//  Created by Lee on 17/4/10.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemGroup : NSObject

@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *footer;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *subHeader;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) void(^subHeaderAction)();

@end
