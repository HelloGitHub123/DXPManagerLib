//
//  UIColor+Category_mg.h
//  PelvicFloorPersonal
//
//  Created by 张威 on 2020/4/12.
//  Copyright © 2020 henglongwu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GradientColorDirection) {
    GradientColorDirectionLevel,//水平渐变
    GradientColorDirectionVertical,//竖直渐变
    GradientColorDirectionDownDiagonalLine,//向上对角线渐变
    GradientColorDirectionUpwardDiagonalLine,//向下对角线渐变
};

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Category_mg)
/// 设置渐变色
/// @param size 需要渐变的大小
/// @param direction 渐变的方向
/// @param startcolor 渐变的开始颜色
/// @param endColor 渐变的结束颜色
+ (instancetype)gradientColorWithSize:(CGSize)size
                            direction:(GradientColorDirection)direction
                           startColor:(UIColor *)startcolor
                             endColor:(UIColor *)endColor;

+ (instancetype)gradientColorWithSize:(CGSize)size
                            direction:(GradientColorDirection)direction
                           startColor:(UIColor *)startcolor
                             endColor:(UIColor *)endColor
                                angle:(CGFloat)angle;

+ (UIColor*)colorWithHexString:(NSString *)hexString;

+ (UIColor*)colorWithHexString:(NSString *)hexString alpha:(float)alpha;
@end

NS_ASSUME_NONNULL_END
