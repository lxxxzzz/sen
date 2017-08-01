//
//  UIImage+Extension.m
//  森
//
//  Created by Lee on 17/4/11.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color {
    //图片尺寸
    CGRect rect = CGRectMake(0, 0, 10, 10);
    //填充画笔
    UIGraphicsBeginImageContext(rect.size);
    //根据所传颜色绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    //显示区域
    CGContextFillRect(context, rect);
    // 得到图片信息
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //消除画笔
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)stretchedImageWithName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    int left = image.size.width * 0.5;
    int top = image.size.height * 0.5;
    return [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
}

@end
