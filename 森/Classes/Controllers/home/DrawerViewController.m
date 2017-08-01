//
//  DrawerViewController.m
//  森
//
//  Created by Lee on 17/3/23.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "DrawerViewController.h"

@interface DrawerViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIControl *maskView;
@property (nonatomic, assign) BOOL closed;

@end

@implementation DrawerViewController {
    CGFloat _scalef;
}

static NSInteger const rightMargin = 135;

- (instancetype)initWithLeftViewController:(UIViewController *)leftController centerViewController:(UIViewController *)centerController {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.leftController = leftController;
        self.centerController = centerController;
        
        [self addChildViewController:leftController];
        [self addChildViewController:centerController];
        
        [self.view addSubview:leftController.view];
        [self.view addSubview:centerController.view];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        pan.delegate = self;
        if ([centerController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)centerController;
            [nav.topViewController.view addGestureRecognizer:pan];
        } else {
            [centerController.view addGestureRecognizer:pan];
        }
        leftController.view.frame = CGRectMake(0, 0, SCREEN_W - rightMargin, SCREEN_H);
        leftController.view.center = CGPointMake(30, SCREEN_H * 0.5);
        
        self.closed = YES;
        
        [self.centerController.view addSubview:self.maskView];
    }
    return self;
}

//CGFloat x = 0;
//- (void)handlePan:(UIPanGestureRecognizer *)panGesture {
//    CGPoint point = [panGesture translationInView:self.view];
//    static BOOL isLeft = NO;
//    
//    switch (panGesture.state) {
//        case UIGestureRecognizerStateBegan:{
//            _startP = self.centerController.view.center;
//        }
//        case UIGestureRecognizerStateChanged:{
////            NSLog(@"%@",panGesture.view);
//            if ((self.centerController.view.frame.origin.x >= 0) && (self.centerController.view.frame.origin.x < (SCREEN_W - 200 ))) {
//                NSLog(@"%f   %f",self.centerController.view.frame.origin.x,(SCREEN_W - 200 ));
//                self.centerController.view.center = CGPointMake(_startP.x + point.x, _startP.y);
//                CGFloat leftTabCenterX = 30 + ((SCREEN_W - 200) * 0.5 - 30) * (panGesture.view.frame.origin.x / (SCREEN_W - 200));
//                self.leftController.view.center = CGPointMake(leftTabCenterX, SCREEN_H * 0.5);
//            }
//            isLeft = point.x < x;
//            x = point.x;
//            break;
//        }
//        case UIGestureRecognizerStateEnded:
//        case UIGestureRecognizerStateCancelled: {
////            if (fabs(_scalef) > (SCREEN_W - 200) / 2.0 - 40) {
//                if (isLeft) {
//                    [self closeDrawerWithAnimated:YES completion:nil];
//                } else {
//                    
//                    [self openDrawerWithAnimated:YES completion:nil];
//                }
//            _scalef = 0;
//            break;
//        }
//        default:
//            break;
//    }
//}

- (void)handlePan:(UIPanGestureRecognizer *)rec {
    CGPoint point = [rec translationInView:self.view];
    _scalef = point.x + _scalef;
    
    CGPoint centerOrigin = self.centerController.view.frame.origin;


    self.maskView.alpha = centerOrigin.x / (rightMargin * 2.0);


    BOOL needMoveWithTap = YES;  //是否还需要跟随手指移动
    if (((centerOrigin.x <= 0) && (_scalef <= 0)) || ((centerOrigin.x >= (SCREEN_W - rightMargin )) && (_scalef >= 0))) {
        //边界值管控
        _scalef = 0;
        needMoveWithTap = NO;
    }
    
    //根据视图位置判断是左滑还是右边滑动
    if (needMoveWithTap && (rec.view.frame.origin.x >= 0) && (rec.view.frame.origin.x <= (SCREEN_W - rightMargin ))) {
        CGFloat recCenterX = rec.view.center.x + point.x;
        if (recCenterX < SCREEN_W * 0.5 - 2) {
            recCenterX = SCREEN_W * 0.5;
        }
        
        CGFloat recCenterY = rec.view.center.y;
        
        rec.view.center = CGPointMake(recCenterX,recCenterY);
        
        //scale 1.0~kMainPageScale
        CGFloat scale = 1 - (1 - 1) * (rec.view.frame.origin.x / (SCREEN_W - rightMargin));
        
        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,scale, scale);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        
        CGFloat leftTabCenterX = 30 + ((SCREEN_W - rightMargin) * 0.5 - 30) * (rec.view.frame.origin.x / (SCREEN_W - rightMargin));
        
        self.leftController.view.center = CGPointMake(leftTabCenterX, SCREEN_H * 0.5);
        
    } else {
        //超出范围，
        if (centerOrigin.x < 0)
        {
            [self closeDrawerWithAnimated:YES completion:nil];
            _scalef = 0;
        } else if (centerOrigin.x > (SCREEN_W - rightMargin)) {
            [self openDrawerWithAnimated:YES completion:nil];
            _scalef = 0;
        }
    }
    
    //手势结束后修正位置,超过约一半时向多出的一半偏移
    if (rec.state == UIGestureRecognizerStateEnded) {
        if (fabs(_scalef) > (SCREEN_W - rightMargin) / 2.0 - 40) {
            if (self.closed) {
                [self openDrawerWithAnimated:YES completion:nil];
            } else {
                [self closeDrawerWithAnimated:YES completion:nil];
            }
        } else {
            if (self.closed) {
                [self closeDrawerWithAnimated:YES completion:nil];
            } else {
                [self openDrawerWithAnimated:YES completion:nil];
            }
        }
        _scalef = 0;
    }
}

- (void)openDrawerWithAnimated:(BOOL)animated completion:(void (^)(BOOL))completion {
    
    self.closed = NO;
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self openTransform];
            self.maskView.alpha = 0.6;
        } completion:completion];
    } else {
        [self openTransform];
    }
}

- (void)closeDrawerWithAnimated:(BOOL)animated completion:(void (^)(BOOL))completion {
    self.closed = YES;
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self closeTransform];
            self.maskView.alpha = 0.0;
        } completion:completion];
    } else {
        [self closeTransform];
    }
}

- (void)close {
    [self closeDrawerWithAnimated:YES completion:nil];
}

- (void)closeTransform {
    self.centerController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.centerController.view.center = CGPointMake(SCREEN_W / 2, SCREEN_H / 2);
    
    self.leftController.view.center = CGPointMake(30, SCREEN_H * 0.5);
    self.leftController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
}

- (void)openTransform {
    // 缩放比例
//    self.centerController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    // 200是centerController露出的宽度
    self.centerController.view.center = CGPointMake(SCREEN_W + SCREEN_W / 2 - rightMargin, SCREEN_H / 2);
    self.leftController.view.center = CGPointMake((SCREEN_W - rightMargin) / 2, SCREEN_H / 2);
//    self.leftController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if(touch.view == self.centerController.view) {
        // 只有客资列表控制器响应侧滑
        return YES;
    } else {
        return NO;
    }
}

- (UIControl *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIControl alloc] initWithFrame:self.centerController.view.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.0;
        [_maskView addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskView;
}

@end
