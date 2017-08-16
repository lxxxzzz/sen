//
//  EasterEggViewController.m
//  森
//
//  Created by 小红李 on 2017/8/16.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "EasterEggViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "HostTool.h"
#import <Masonry.h>

@interface EasterEggViewController ()

@end

@implementation EasterEggViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"高级设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"关闭" target:self action:@selector(close)];
    
    
    
    UILabel *debugLabel = [[UILabel alloc] init];
    debugLabel.text = @"debug";
    debugLabel.font = FONT(14);
    [self.view addSubview:debugLabel];
    
    UILabel *releaseLabel = [[UILabel alloc] init];
    releaseLabel.text = @"release";
    releaseLabel.font = FONT(14);
    [self.view addSubview:releaseLabel];
    
    UISwitch *switchView = [[UISwitch alloc] init];

    switchView.on = ![HostTool isDebug];
    [switchView addTarget:self action:@selector(switchViewDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchView];
    [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(100);
    }];
    
    [debugLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(switchView.mas_left).offset(-10);
        make.centerY.mas_equalTo(switchView.mas_centerY);
    }];
    
    [releaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(switchView.mas_right).offset(10);
        make.centerY.mas_equalTo(switchView.mas_centerY);
    }];
}


- (void)switchViewDidChange:(UISwitch *)switchView {
    [HostTool debug:!switchView.isOn];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
