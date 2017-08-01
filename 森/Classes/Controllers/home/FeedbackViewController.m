//
//  FeedbackViewController.m
//  森
//
//  Created by Lee on 17/3/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackSuccessView.h"
#import "HTTPTool.h"
#import "TextView.h"
#import "NSString+Extension.h"

#import <SVProgressHUD.h>
#import <Masonry.h>

@interface FeedbackViewController () <UIScrollViewDelegate, FeedbackSuccessViewDelegate>

@property (nonatomic, weak) UIButton *submit;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UITextView *questionContent;
@property (nonatomic, weak) UITextField *phoneNumber;
@property (nonatomic, strong) FeedbackSuccessView *successView;

@end

@implementation FeedbackViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
    
    [self setupNotifacation];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    Log(@"%s", __func__);
}

#pragma mark - Overrid
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 私有方法
#pragma mark

- (void)setupNavigationItem {
    self.navigationItem.title = @"用户反馈";
}

- (void)setupNotifacation {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    CGRect kbRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([self.phoneNumber isFirstResponder]) {
        CGFloat btnY = CGRectGetMaxY(self.submit.frame);
        CGFloat difference = ABS(btnY - kbRect.origin.y);
        [self.scrollView setContentOffset:CGPointMake(0, difference) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)noti {
    [self.scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
}

#pragma mark Action
- (void)submitFeedback {
    [self.view endEditing:YES];
    if (!self.questionContent.hasText) {
        [SVProgressHUD showErrorWithStatus:@"问题和意见不能为空"];
        return;
    }
    if (self.phoneNumber.hasText && [self.phoneNumber.text validMobile]) {
        [SVProgressHUD showErrorWithStatus:[self.phoneNumber.text validMobile]];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"提交中..."];
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=feedback&f=create", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = TOKEN;
    parameters[@"content"] = self.questionContent.text;
    parameters[@"phone"] = self.phoneNumber.text;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        [SVProgressHUD dismiss];
        if (result.success) {
            [self.scrollView addSubview:self.successView];
            [self.successView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.scrollView.mas_top);
                make.left.mas_equalTo(self.scrollView.mas_left);
                make.height.mas_equalTo(self.scrollView.mas_height);
                make.width.mas_equalTo(self.scrollView.mas_width);
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

- (void)viewClick {
    [self.view endEditing:YES];
}

#pragma mark 布局
- (void)setupSubviews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
    scrollView.alwaysBounceVertical = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick)];
    [scrollView addGestureRecognizer:tap];
    
    UIView *questionContainer = [[UIView alloc] init];
    questionContainer.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:questionContainer];
    
    UILabel *question = [[UILabel alloc] init];
    question.text = @"问题和意见";
    question.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    question.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [questionContainer addSubview:question];
    
    UIView *questionLine = [[UIView alloc] init];
    questionLine.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:240/255.0 alpha:1/1.0];
    [questionContainer addSubview:questionLine];
    
    TextView *questionContent = [[TextView alloc] init];
    questionContent.placeholder = @"请描述您的问题";
    [questionContainer addSubview:questionContent];
    self.questionContent = questionContent;
    
    //--------------------------分割线------------------------
    UIView *phoneContainer = [[UIView alloc] init];
    phoneContainer.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:phoneContainer];
    
    UILabel *phone = [[UILabel alloc] init];
    phone.text = @"联系电话（选填）";
    phone.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    phone.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [phoneContainer addSubview:phone];
    
    UIView *phoneLine = [[UIView alloc] init];
    phoneLine.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:240/255.0 alpha:1/1.0];
    [phoneContainer addSubview:phoneLine];
    
    UITextField *phoneNumber = [[UITextField alloc] init];
    phoneNumber.font = FONT(14);
    phoneNumber.placeholder = @"请输入手机号";
    phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    [phoneContainer addSubview:phoneNumber];
    self.phoneNumber = phoneNumber;
    
    UIButton *submit = [[UIButton alloc] init];
    submit.layer.cornerRadius = 4;
    submit.layer.masksToBounds = YES;
    submit.backgroundColor = [UIColor colorWithRed:23/255.0 green:143/255.0 blue:230/255.0 alpha:1/1.0];
    [submit setTitle:@"提交反馈" forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitFeedback) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:submit];
    self.submit = submit;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [questionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollView.mas_top).offset(4);
        make.left.mas_equalTo(scrollView.mas_left);
        make.width.mas_equalTo(scrollView.mas_width);
        make.height.mas_equalTo(232);
    }];
    
    [question mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(questionContainer.mas_left).offset(15);
        make.right.mas_equalTo(questionContainer.mas_right).offset(-15);
        make.top.mas_equalTo(questionContainer.mas_top).offset(18);
        make.height.mas_equalTo(15);
    }];
    
    [questionLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(question.mas_left);
        make.right.mas_equalTo(question.mas_right);
        make.top.mas_equalTo(question.mas_bottom).offset(17);
    }];
    
    [questionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(questionLine.mas_left).offset(-3);
        make.right.mas_equalTo(questionLine.mas_right);
        make.top.mas_equalTo(questionLine.mas_bottom);
        make.bottom.mas_equalTo(questionContainer.mas_bottom).offset(-20);
    }];

    [phoneContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scrollView.mas_left);
        make.top.mas_equalTo(questionContainer.mas_bottom).offset(5);
        make.width.mas_equalTo(questionContainer.mas_width);
    }];
    
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneContainer.mas_left).offset(15);
        make.right.mas_equalTo(phoneContainer.mas_right).offset(-15);
        make.top.mas_equalTo(phoneContainer.mas_top).offset(18);
        make.height.mas_equalTo(15);
    }];
    
    [phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.left.mas_equalTo(phone.mas_left);
        make.right.mas_equalTo(phone.mas_right);
        make.height.mas_equalTo(questionLine.mas_height);
        make.top.mas_equalTo(phone.mas_bottom).offset(17);
    }];
    
    [phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phone.mas_left);
        make.right.mas_equalTo(phone.mas_right);
        make.top.mas_equalTo(phoneLine.mas_bottom).offset(18);
        make.bottom.mas_equalTo(phoneContainer.mas_bottom).offset(-19);
    }];
    
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneContainer.mas_bottom).offset(21);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(phoneContainer.mas_left).offset(45);
        make.right.mas_equalTo(phoneContainer.mas_right).offset(-45);
    }];
    
}

#pragma mark - delegate
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark FeedbackSuccessViewDelegate
- (void)feedbackSuccessViewDidClickClose:(FeedbackSuccessView *)view {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setter and getter
#pragma mark getter
- (FeedbackSuccessView *)successView {
    if (_successView == nil) {
        _successView = [[FeedbackSuccessView alloc] init];
        _successView.delegate = self;
    }
    return _successView;
}

@end
