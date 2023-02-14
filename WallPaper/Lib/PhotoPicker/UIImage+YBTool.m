//
//  UIImage+YBTool.m
//  EnglishVideoStudio
//
//  Created by liQi on 2019/8/1.
//  Copyright © 2019 优贝科技. All rights reserved.
//

#import "UIImage+YBTool.h"

@implementation UIImage (YBTool)

+ (UIImage *)yb_imageWithColor:(UIColor *)color
                          size:(CGSize)size
                        radius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)yb_imageWithBorderWidth:(CGFloat)width
                              corner:(CGFloat)corner
                                size:(CGSize)size
                           fillColor:(UIColor *)fillColor
{
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect imageRect = CGRectMake(width / 2, width / 2, size.width - width, size.height - width);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
    [path closePath];
    CGContextAddPath(context, path.CGPath);
    
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

//使用该方法不会模糊，根据屏幕密度计算
+ (UIImage *)yb_convertViewToImage:(UIView *)view
{
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}

@end
