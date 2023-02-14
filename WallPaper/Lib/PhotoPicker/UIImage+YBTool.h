//
//  UIImage+YBTool.h
//  EnglishVideoStudio
//
//  Created by liQi on 2019/8/1.
//  Copyright © 2019 优贝科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YBTool)

+ (UIImage *)yb_imageWithColor:(UIColor *)color
                          size:(CGSize)size
                        radius:(CGFloat)radius;


+ (UIImage *)yb_imageWithBorderWidth:(CGFloat)width
                              corner:(CGFloat)corner
                                size:(CGSize)size
                           fillColor:(UIColor *)fillColor;


+ (UIImage *)yb_convertViewToImage:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
