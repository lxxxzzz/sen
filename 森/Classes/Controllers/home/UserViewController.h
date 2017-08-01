//
//  UserViewController.h
//  森
//
//  Created by Lee on 17/3/23.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserItem;

@interface UserViewController : UIViewController

@property (nonatomic, strong) NSArray <UserItem *>*dataSource;
@property (nonatomic, copy) NSString *avatarName;
@property (nonatomic, copy) NSString *nickName;

@end
