//
//  LoginViewController.m
//  森
//
//  Created by Lee on 17/3/23.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "LoginViewController.h"
#import "BindingAccountViewController.h"
#import "CustomerListViewController.h"
#import "HTTPTool.h"
#import "User.h"
#import "RootVCManager.h"

#import "NSString+Extension.h"
#import "UIImage+Extension.h"

#import <Masonry.h>
#import <MZTimerLabel.h>
#import <SVProgressHUD.h>

#import "DrawerViewController.h"
#import "UserViewController.h"

#import "NavigationViewController.h"
#import "EasterEggViewController.h"

@interface LoginViewController () <MZTimerLabelDelegate> {
    NSString *_captcha;
}

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *explainLabel;
@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) UITextField *phoneNumberText;
@property (nonatomic, strong) UIView *phoneNumberLine;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) UIView *passwordLine;


@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UITextField *accountText;
@property (nonatomic, strong) UIView *accountLine;
@property (nonatomic, strong) UILabel *captchaLabel;
@property (nonatomic, strong) UITextField *captchaText;
@property (nonatomic, strong) UIView *captchaLine;
@property (nonatomic, strong) UIButton *getCaptchaBtn;

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *loginWayBtn;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LoginViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self textFieldDidChange:nil];
    
    NSString *rootVcValue = [[NSUserDefaults standardUserDefaults] objectForKey:kRootViewControllerKey];
    if (rootVcValue) {
        if ([rootVcValue isEqualToString:kRootViewControllerZhuizong]) {
            // 之前是用追踪账号登录过的，此时应该显示追踪登录界面，按钮文字应该为使用注册登录，seleted为YES
            self.loginWayBtn.selected = YES;
        } else {
            self.loginWayBtn.selected = NO;
        }
    } else {
        // 第一次
        self.loginWayBtn.selected = NO;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 延迟0.1秒执行，不然设定scrollView的contentOffSize不起作用
        [self updateLoginStatus:NO];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置状态栏文字颜色为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma makr - Override
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 私有方法
- (NSString *)checkPhoneNumber {
    if (!self.phoneNumberText.hasText) return @"请输入手机号码";
    return [self.phoneNumberText.text validMobile];;
}

- (NSString *)checkCaptcha {
    if (!self.captchaText.hasText)  return @"请输入验证码";
    if (![self.captchaText.text isEqualToString:_captcha]) return @"验证码有误，请重新输入";
    return nil;
}

#pragma mark Action
- (void)textFieldDidChange:(UITextField *)textField {
    if (self.loginWayBtn.isSelected) {
        // 追踪账号
        self.loginBtn.enabled = self.accountText.hasText && self.passwordText.hasText;
    } else {
        // 提供者账号
        self.loginBtn.enabled = self.phoneNumberText.hasText && self.captchaText.hasText;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:[[EasterEggViewController alloc] init]];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)closeVc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getCaptcha {
    NSString *error = [self checkPhoneNumber];
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
        return;
    }
    
    // 焦点自动切到验证码输入框
    [self.captchaText becomeFirstResponder];
    
    [self networkCaptcha];
}

- (void)captchaStart {
    MZTimerLabel *timerLabel = [[MZTimerLabel alloc] initWithTimerType:MZTimerLabelTypeTimer];
    timerLabel.frame = self.getCaptchaBtn.bounds;
    timerLabel.timeFormat = @"ss秒";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timerLabel.timeLabel.textColor = HEX(@"#C7C7CC");
    timerLabel.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    timerLabel.timeLabel.textAlignment = NSTextAlignmentRight;//剧中
    timerLabel.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    [timerLabel setCountDownTime:60];//倒计时时间60s
    [timerLabel start];//开始计时
    
    [self.getCaptchaBtn setTitle:nil forState:UIControlStateNormal];
    [self.getCaptchaBtn addSubview:timerLabel];
    [self.getCaptchaBtn setUserInteractionEnabled:NO];
}

- (void)login {
    [self.view endEditing:YES];
    
    if (self.loginWayBtn.isSelected) {
        // 追踪账号登录
        [self trailsmanLogin];
    } else {
        // 提供者账号登录
        [self providerLogin];
    }
}

- (void)selectedLoginWay:(UIButton *)sender {
    sender.selected = !sender.isSelected;

    [self updateLoginStatus:YES];
}

- (void)updateLoginStatus:(BOOL)animated {
    if (self.loginWayBtn.isSelected) {
        // 追踪账号
        [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:animated];
        self.loginBtn.enabled = self.accountText.hasText && self.passwordText.hasText;
        [[NSUserDefaults standardUserDefaults] setObject:kRootViewControllerZhuizong forKey:kRootViewControllerKey];
    } else {
        // 提供者账号
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:animated];
        self.loginBtn.enabled = self.phoneNumberText.hasText && self.captchaText.hasText;
        [[NSUserDefaults standardUserDefaults] setObject:kRootViewControllerTigong forKey:kRootViewControllerKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 网络请求
#pragma mark 获取验证码
- (void)networkCaptcha {
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=user&f=getPhoneCode", HOST];
    NSDictionary *parameters = @{@"mobile" : self.phoneNumberText.text};
    @weakObj(self)
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        if (result.success) {
            @strongObj(self)
            Log(@"短信验证码是%@",result.data[@"code"]);
            _captcha = [result.data[@"code"] stringValue];
            
            [self captchaStart];
            
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

- (void)providerLogin {
    // 检查手机号码和验证码
    if (![self.phoneNumberText.text isEqualToString:kSpecialAccount]) {
        NSString *error = [self checkPhoneNumber];
        if (error) {
            [SVProgressHUD showErrorWithStatus:error];
            return;
        }
        
        error = [self checkCaptcha];
        if (error) {
            [SVProgressHUD showErrorWithStatus:error];
            return;
        }
    } else {
        _captcha = @"8888";
    }
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=user&f=login&debug=1", HOST];
    NSDictionary *parameters = @{
                                 @"phone" : self.phoneNumberText.text,
                                 @"code"  : _captcha
                                 };
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        [SVProgressHUD dismiss];
        if (result.success) {
            User *user = [User userWithDict:result.data];
            user.account = self.phoneNumberText.text;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserDidLoginNotification object:nil];
            
            if ((user.alipay_account && user.alipay_account.length) || (user.bank_account && user.bank_account.length)) {
                // 有设定过支付信息，到酒店列表
                [RootVCManager rootVc];
            } else {
                // 没有设定过支付信息，到绑定账号界面
                [RootVCManager bindingAccount:YES];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

- (void)trailsmanLogin {
    if (!self.passwordText.hasText) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=user&f=loginByUser&debug=1", HOST];
    NSDictionary *parameters = @{
                                 @"user_name" : self.accountText.text,
                                 @"password"  : self.passwordText.text
                                 };
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        [SVProgressHUD dismiss];
        if (result.success) {
            User *user = [User userWithDict:result.data];
            user.account = self.accountText.text;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserDidLoginNotification object:nil];
            
            if (user.user_type == 4) {
                if ((user.alipay_account && user.alipay_account.length) || (user.bank_account && user.bank_account.length)) {
                    // 有设定过支付信息，到酒店列表
                    [RootVCManager rootVc];
                } else {
                    // 没有设定过支付信息，到绑定账号界面
                    [RootVCManager bindingAccount:YES];
                }
            } else {
                [RootVCManager rootVc];
            }
            Log(@"%@",TOKEN);
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

#pragma mark - delegate
#pragma mark MZTimerLabelDelegate 倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [self.getCaptchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [timerLabel removeFromSuperview];
    [self.getCaptchaBtn setUserInteractionEnabled:YES];
}

#pragma mark 布局
- (void)setupSubviews {
    [self.view setBackgroundColor:RGB(255, 255, 255)];
    
    [self.view addSubview:self.iconImage];
    [self.view addSubview:self.explainLabel];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.top.mas_equalTo(self.view.mas_top).offset(100);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImage.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(14);
    }];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.explainLabel.mas_bottom).offset(40);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    // 提供者
    UIView *providerContainer = [[UIView alloc] init];
    [self.scrollView addSubview:providerContainer];
    
    UIView *trailsmanContainer = [[UIView alloc] init];
    [self.scrollView addSubview:trailsmanContainer];
    
    [self.view addSubview:self.loginBtn];
    
    [self.view addSubview:self.loginWayBtn];
    
    [providerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.top.mas_equalTo(self.scrollView.mas_top);
        make.width.mas_equalTo(self.scrollView.mas_width);
        make.height.mas_equalTo(self.scrollView.mas_height);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom);
    }];
    
    [trailsmanContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(providerContainer.mas_right);
        make.top.mas_equalTo(self.scrollView.mas_top);
        make.width.mas_equalTo(providerContainer.mas_width);
        make.height.mas_equalTo(providerContainer.mas_height);
        make.right.mas_equalTo(self.scrollView.mas_right);
    }];
#pragma mark --------------提供者start--------------
    [providerContainer addSubview:self.phoneNumberLabel];
    [providerContainer addSubview:self.phoneNumberText];
    [providerContainer addSubview:self.phoneNumberLine];
    [providerContainer addSubview:self.captchaLabel];
    [providerContainer addSubview:self.captchaText];
    [providerContainer addSubview:self.getCaptchaBtn];
    [providerContainer addSubview:self.captchaLine];

    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(providerContainer.mas_left).offset(45);
        make.centerY.mas_equalTo(self.phoneNumberText.mas_centerY);
        // 因为不要这个字段了，先这样设置，万一以后又要了
        make.width.mas_equalTo(0);
    }];
    
    [self.phoneNumberText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.phoneNumberLabel.mas_right).offset(42);
        make.left.mas_equalTo(self.phoneNumberLabel.mas_right).offset(10);
        make.top.mas_equalTo(providerContainer.mas_top);
        make.right.mas_equalTo(providerContainer.mas_right).offset(-45);
        make.height.mas_equalTo(44);
    }];
    
    [self.phoneNumberLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumberLabel.mas_left);
        make.right.mas_equalTo(self.phoneNumberText.mas_right);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.phoneNumberText.mas_bottom);
    }];
    
//    [self.captchaLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [self.captchaLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.captchaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumberLabel.mas_left);
        make.centerY.mas_equalTo(self.captchaText.mas_centerY);
        
        make.width.mas_equalTo(0);
    }];
    
    [self.captchaText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumberText.mas_left);
        make.top.mas_equalTo(self.phoneNumberText.mas_bottom).offset(23);
        make.right.mas_equalTo(self.getCaptchaBtn.mas_left);
        make.height.mas_equalTo(self.phoneNumberText.mas_height);
    }];
    
    [self.captchaLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumberLine.mas_left);
        make.right.mas_equalTo(self.phoneNumberLine.mas_right);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.captchaText.mas_bottom);
        make.bottom.mas_equalTo(providerContainer.mas_bottom);
    }];
    
    [self.getCaptchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.captchaLine.mas_right);
        make.top.mas_equalTo(self.captchaText.mas_top);
        make.bottom.mas_equalTo(self.captchaText.mas_bottom);
        make.width.mas_equalTo(100);
    }];
#pragma mark --------------提供者end--------------
    
#pragma mark --------------追踪者start--------------
    [trailsmanContainer addSubview:self.accountLabel];
    [trailsmanContainer addSubview:self.accountText];
    [trailsmanContainer addSubview:self.accountLine];
    [trailsmanContainer addSubview:self.passwordLabel];
    [trailsmanContainer addSubview:self.passwordText];
    [trailsmanContainer addSubview:self.passwordLine];
    
//    [self.accountLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [self.accountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(trailsmanContainer.mas_left).offset(45);
        make.centerY.mas_equalTo(self.accountText.mas_centerY);
        
        make.width.mas_equalTo(0);
    }];
    
    [self.accountText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.accountLabel.mas_right).offset(42);
        make.left.mas_equalTo(self.accountLabel.mas_right).offset(10);
        make.top.mas_equalTo(trailsmanContainer.mas_top);
        make.right.mas_equalTo(trailsmanContainer.mas_right).offset(-45);
        make.height.mas_equalTo(44);
    }];
    
    [self.accountLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.accountLabel.mas_left);
        make.right.mas_equalTo(self.accountText.mas_right);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.accountText.mas_bottom);
    }];
    
//    [self.passwordLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [self.passwordLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.accountLabel.mas_left);
        make.centerY.mas_equalTo(self.passwordText.mas_centerY);
        
        make.width.mas_equalTo(0);
    }];
    
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.accountText.mas_left);
        make.top.mas_equalTo(self.accountText.mas_bottom).offset(23);
        make.right.mas_equalTo(self.accountText.mas_right);
        make.height.mas_equalTo(self.accountText.mas_height);
    }];
    
    [self.passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.accountLine.mas_left);
        make.right.mas_equalTo(self.accountLine.mas_right);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.passwordText.mas_bottom);
    }];
    
#pragma mark --------------追踪者end--------------
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view.mas_left).offset(45);
        make.right.mas_equalTo(self.view.mas_right).offset(-45);
        make.height.mas_equalTo(50);
    }];
    
    [self.loginWayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.titleLabel.font = FONT(12);
    [close setImage:IMAGE(@"icons_dropdown") forState:UIControlStateNormal];
    [close setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

#pragma mark - setter and getter
#pragma mark setter

#pragma mark getter
- (UIImageView *)iconImage {
    if (_iconImage == nil) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.image = IMAGE(@"login_icon");
        
        _iconImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(tapAction:)];
        //轻拍次数
        tap.numberOfTapsRequired = 4;
        //轻拍手指个数
        tap.numberOfTouchesRequired = 1;
        [_iconImage addGestureRecognizer:tap];
    }
    return _iconImage;
}

- (UILabel *)explainLabel {
    if (_explainLabel == nil) {
        _explainLabel = [[UILabel alloc] init];
        _explainLabel.text = @"您的一站式婚宴助手";
        _explainLabel.textColor = HEX(@"#178FE6");
        _explainLabel.font = FONT(14);
        _explainLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _explainLabel;
}

- (UILabel *)accountLabel {
    if (_accountLabel == nil) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.text = @"账号";
        _accountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _accountLabel.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:102/255.0 alpha:1/1.0];
    }
    return _accountLabel;
}

- (UITextField *)accountText {
    if (_accountText == nil) {
        _accountText = [[UITextField alloc] init];
        _accountText.font = FONT(16);
        _accountText.placeholder = @"请输入账号";
        _accountText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountText.autocorrectionType = UITextAutocorrectionTypeNo;
        _accountText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [_accountText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _accountText;
}

- (UIView *)accountLine {
    if (_accountLine == nil) {
        _accountLine = [[UIView alloc] init];
        _accountLine.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:234/255.0 alpha:1/1.0];
    }
    return _accountLine;
}

- (UILabel *)passwordLabel {
    if (_passwordLabel == nil) {
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.text = @"密码";
        _passwordLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _passwordLabel.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:102/255.0 alpha:1/1.0];
    }
    return _passwordLabel;
}

- (UITextField *)passwordText {
    if (_passwordText == nil) {
        _passwordText = [[UITextField alloc] init];
        _passwordText.font = FONT(16);
        _passwordText.secureTextEntry = YES;
        _passwordText.placeholder = @"请输入密码";
        [_passwordText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordText;
}

- (UIView *)passwordLine {
    if (_passwordLine == nil) {
        _passwordLine = [[UIView alloc] init];
        _passwordLine.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:234/255.0 alpha:1/1.0];
    }
    return _passwordLine;
}

- (UILabel *)phoneNumberLabel {
    if (_phoneNumberLabel == nil) {
        _phoneNumberLabel = [[UILabel alloc] init];
        _phoneNumberLabel.text = @"手机号";
        _phoneNumberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _phoneNumberLabel.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:102/255.0 alpha:1/1.0];
    }
    return _phoneNumberLabel;
}

- (UITextField *)phoneNumberText {
    if (_phoneNumberText == nil) {
        _phoneNumberText = [[UITextField alloc] init];
        _phoneNumberText.font = FONT(16);
        _phoneNumberText.placeholder = @"请输入手机号";
        _phoneNumberText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumberText.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumberText.autocorrectionType = UITextAutocorrectionTypeNo;
        _phoneNumberText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [_phoneNumberText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneNumberText;
}

- (UIView *)phoneNumberLine {
    if (_phoneNumberLine == nil) {
        _phoneNumberLine = [[UIView alloc] init];
        _phoneNumberLine.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:234/255.0 alpha:1/1.0];
    }
    return _phoneNumberLine;
}

- (UILabel *)captchaLabel {
    if (_captchaLabel == nil) {
        _captchaLabel = [[UILabel alloc] init];
        _captchaLabel.text = @"验证码";
        _captchaLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _captchaLabel.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:102/255.0 alpha:1/1.0];
    }
    return _captchaLabel;
}

- (UITextField *)captchaText {
    if (_captchaText == nil) {
        _captchaText = [[UITextField alloc] init];
        _captchaText.font = FONT(16);
        _captchaText.placeholder = @"请输入验证码";
        _captchaText.keyboardType = UIKeyboardTypeNumberPad;
        [_captchaText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _captchaText;
}

- (UIView *)captchaLine {
    if (_captchaLine == nil) {
        _captchaLine = [[UIView alloc] init];
        _captchaLine.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:234/255.0 alpha:1/1.0];
    }
    return _captchaLine;
}

- (UIButton *)getCaptchaBtn {
    if (_getCaptchaBtn == nil) {
        _getCaptchaBtn = [[UIButton alloc] init];
        _getCaptchaBtn.titleLabel.font = FONT(16);
        [_getCaptchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCaptchaBtn setTitleColor:HEX(@"#178FE6") forState:UIControlStateNormal];
        [_getCaptchaBtn addTarget:self action:@selector(getCaptcha) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCaptchaBtn;
}

- (UIButton *)loginBtn {
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc] init];
        _loginBtn.enabled = NO;
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        [_loginBtn setBackgroundImage:[UIImage imageWithColor:RGB(23, 143, 230)] forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[UIImage imageWithColor:RGBA(23, 143, 230, 0.6)] forState:UIControlStateDisabled];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)loginWayBtn {
    if (_loginWayBtn == nil) {
        _loginWayBtn = [[UIButton alloc] init];
        _loginWayBtn.titleLabel.font = FONT(14);
        [_loginWayBtn setTitle:@"采用手机注册登录" forState:UIControlStateSelected];
        [_loginWayBtn setTitle:@"采用员工账号登录" forState:UIControlStateNormal];
        [_loginWayBtn setTitleColor:HEX(@"#313133") forState:UIControlStateNormal];
        [_loginWayBtn addTarget:self action:@selector(selectedLoginWay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginWayBtn;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}


@end
