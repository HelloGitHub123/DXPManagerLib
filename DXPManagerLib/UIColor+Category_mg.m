//
//  UIColor+Category_mg.m
//  PelvicFloorPersonal
//
//  Created by 张威 on 2020/4/12.
//  Copyright © 2020 henglongwu. All rights reserved.
//

#import "UIColor+Category_mg.h"

@implementation UIColor (Category_mg)
/// 设置渐变色
/// @param size 需要渐变的大小
/// @param direction 渐变的方向
/// @param startcolor 渐变的开始颜色
/// @param endColor 渐变的结束颜色
+ (instancetype)gradientColorWithSize:(CGSize)size
                            direction:(GradientColorDirection)direction
                           startColor:(UIColor *)startcolor
                             endColor:(UIColor *)endColor
                                angle:(CGFloat)angle{
    
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    CGFloat x = angle / 360.f;
    CGFloat a = pow(sin((2*M_PI*((x+0.75)/2))),2);
    CGFloat b = pow(sin((2*M_PI*((x+0.0)/2))),2);
    CGFloat c = pow(sin((2*M_PI*((x+0.25)/2))),2);
    CGFloat d = pow(sin((2*M_PI*((x+0.5)/2))),2);
    
    gradientLayer.startPoint = CGPointMake(a, b);
    gradientLayer.endPoint = CGPointMake(c, d);
    
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    //    CGPoint startPoint = CGPointMake(0.0, 0.0);
    //    if (direction == GradientColorDirectionUpwardDiagonalLine) {
    //        startPoint = CGPointMake(0.0, 1.0);
    //    }
    //
    //    CGPoint endPoint = CGPointMake(0.0, 0.0);
    //    switch (direction) {
    //        case GradientColorDirectionVertical:
    //            endPoint = CGPointMake(0.0, 1.0);
    //            break;
    //        case GradientColorDirectionDownDiagonalLine:
    //            endPoint = CGPointMake(1.0, 1.0);
    //            break;
    //        case GradientColorDirectionUpwardDiagonalLine:
    //            endPoint = CGPointMake(1.0, 0.0);
    //            break;
    //        default:
    //            endPoint = CGPointMake(1.0, 0.0);
    //            break;
    //    }
    //    gradientLayer.startPoint = startPoint;
    //    gradientLayer.endPoint = endPoint;
    
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}


+ (instancetype)gradientColorWithSize:(CGSize)size
                            direction:(GradientColorDirection)direction
                           startColor:(UIColor *)startcolor
                             endColor:(UIColor *)endColor{
    
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    if (direction == GradientColorDirectionUpwardDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    
    CGPoint endPoint = CGPointMake(0.0, 0.0);
    switch (direction) {
        case GradientColorDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case GradientColorDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case GradientColorDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            endPoint = CGPointMake(1.0, 0.0);
            break;
    }
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}
+ (UIColor*)colorWithHexString:(NSString *)hexString {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return nil;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6 &&[cString length] != 8) return nil;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b,a=255.0;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    if ([cString length] == 8)
    {
        range.location = 6;
        NSString *aString = [cString substringWithRange:range];
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
    }
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}


+ (UIColor*)colorWithHexString:(NSString *)hexString alpha:(float)alpha{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return nil;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6 &&[cString length] != 8) return nil;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b,a=255.0;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    if ([cString length] == 8)
    {
        range.location = 6;
        NSString *aString = [cString substringWithRange:range];
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
    }
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

@end
