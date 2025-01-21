//
//  HJTokenManager.m
//  HJControls
//
//  Created by mac on 2022/9/15.
//

#import "HJTokenManager.h"
#import <YYCache/YYCache.h>
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import "UIColor+Category_mg.h"
#import "ManagerHeader.h"

#define M_PI        3.14159265358979323846264338327950288  /* pi            */

#define M_PI_2      1.57079632679489661923132169163975144  /* pi/2          */

static HJTokenManager *tokenManager = nil;

@interface HJTokenManager ()

@property (nonatomic, strong) NSString *tokenKey;

@end

@implementation HJTokenManager

+ (HJTokenManager *)shareInstance {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        tokenManager = [[HJTokenManager alloc] init];
    });
    return tokenManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.tokenKey = [NSString stringWithFormat:@"color_%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        YYCache *cache = [[YYCache alloc] initWithName:@"APP_CACHE"];
		BOOL isContains = [cache containsObjectForKey:self.tokenKey];
		if (isContains) {
			NSMutableDictionary *darkAndLightTokenDic = (NSMutableDictionary *)[cache objectForKey:self.tokenKey];
			_tokenDic = [darkAndLightTokenDic objectForKey:@"light"];
			_darkTokenDic = [darkAndLightTokenDic objectForKey:@"dark"];
		} else {
			NSMutableDictionary *darkAndLightTokenDic = [[NSMutableDictionary alloc]initWithCapacity:2];
			
			NSString *path = [[NSBundle mainBundle] pathForResource:@"Token" ofType:@"json"];
			_tokenDic = path ? [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil] : @{};
			
			NSString *darkTokenPath = [[NSBundle mainBundle] pathForResource:@"DarkToken" ofType:@"json"];
			_darkTokenDic = darkTokenPath ? [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:darkTokenPath] options:0 error:nil] : @{};
			
			[darkAndLightTokenDic setObject:_tokenDic forKey:@"light"];
			[darkAndLightTokenDic setObject:_darkTokenDic forKey:@"dark"];
			[cache setObject:darkAndLightTokenDic forKey:self.tokenKey];
		}
		// 暗黑相关配置
		self.darkModeUserDefaultsKey = @"cx_dark_mode";
		self.darkModeUserDefaultsDarkValue = @"dark";
		self.darkModeUserDefaultsLightValue = @"light";
    }
    return self;
}

//"ref-primaryButton-cornerRadius":{
//    "topLeft":"24",
//    "topRight":"24",
//    "bottomLeft":"24",
//    "bottomRight":"24",
//
//},
- (void)setViewRadiusWithToken:(NSString *)token view:(UIView *)view borderColor:(UIColor *)borderColor borderWidth:(CGFloat )borderWidth {
	id cornerRadius = self.tokenDic[token];
	if([cornerRadius isKindOfClass:[NSDictionary class]]){
		CGFloat maxY = CGRectGetMaxY(view.bounds);
		
		CGFloat topLeft = [[cornerRadius objectForKey:@"topLeft"] floatValue]>maxY/2?maxY/2:[[cornerRadius objectForKey:@"topLeft"] floatValue];
		CGFloat topRight = [[cornerRadius objectForKey:@"topRight"] floatValue]>maxY/2?maxY/2:[[cornerRadius objectForKey:@"topRight"] floatValue];;
		CGFloat bottomLeft = [[cornerRadius objectForKey:@"bottomLeft"] floatValue]>maxY/2?maxY/2:[[cornerRadius objectForKey:@"bottomLeft"] floatValue];;
		CGFloat bottomRight = [[cornerRadius objectForKey:@"bottomRight"] floatValue]>maxY/2?maxY/2:[[cornerRadius objectForKey:@"bottomRight"] floatValue];;
		
		[self setCornerRadiusWithTopLeft:topLeft topRight:topRight bottomLeft:bottomLeft bottomRight:bottomRight bounds:view.bounds view:view borderColor:borderColor borderWidth:borderWidth];
		
	}else{
		UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(24,24)];
		CAShapeLayer *maskLayer = [CAShapeLayer layer];
		maskLayer.path = maskPath.CGPath;
		view.layer.mask = maskLayer;
		
		CAShapeLayer *borderLayer = [CAShapeLayer layer];
		borderLayer.path = maskPath.CGPath;
		borderLayer.fillColor = [UIColor clearColor].CGColor;
		borderLayer.strokeColor = [UIColor colorWithRed:0.835 green:0.835 blue:0.835 alpha:1].CGColor;
		borderLayer.lineWidth = 1;
		[view.layer addSublayer:borderLayer];
	}
}

- (void)setCornerRadiusWithTopLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight bounds:(CGRect)bounds view:(UIView *)view borderColor:(UIColor *)borderColor borderWidth:(CGFloat )borderWidth {

	CGFloat minX = CGRectGetMinX(bounds);
	CGFloat minY = CGRectGetMinY(bounds);
	CGFloat maxX = CGRectGetMaxX(bounds);
	CGFloat maxY = CGRectGetMaxY(bounds);
	CGFloat topLeftCenterX = minX + topLeft;
	CGFloat topLeftCenterY = minY + topLeft;
	CGFloat topRightCenterX = maxX - topRight;
	CGFloat topRightCenterY = minY + topRight;
	CGFloat bottomLeftCenterX = minX + bottomLeft;
	CGFloat bottomLeftCenterY = maxY - bottomLeft;
	CGFloat bottomRightCenterX = maxX - bottomRight;
	CGFloat bottomRightCenterY = maxY - bottomRight;
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path addArcWithCenter:CGPointMake(topLeftCenterX, topLeftCenterY) radius:topLeft startAngle:M_PI endAngle:3 * M_PI / 2.0 clockwise:YES];
	[path addArcWithCenter:CGPointMake(topRightCenterX, topRightCenterY) radius:topRight startAngle:3*M_PI/2.0 endAngle:0 clockwise:YES];
	[path addArcWithCenter:CGPointMake(bottomRightCenterX, bottomRightCenterY) radius:bottomRight startAngle:0 endAngle:M_PI_2 clockwise:YES];
	[path addArcWithCenter:CGPointMake(bottomLeftCenterX, bottomLeftCenterY) radius:bottomLeft startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
	[path closePath]; // 确保路径闭合
	
//    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
//    masklayer.frame= bounds;
//    masklayer.path= path.CGPath;
//    view.layer.mask= masklayer;
	
	 
	CAShapeLayer *maskLayer = [CAShapeLayer layer];
	maskLayer.frame= bounds;
	maskLayer.path = path.CGPath;
	view.layer.mask = maskLayer;
	
	CAShapeLayer *borderLayer = [CAShapeLayer layer];
	borderLayer.path = path.CGPath;
	borderLayer.fillColor = [UIColor clearColor].CGColor;
	borderLayer.strokeColor = borderColor.CGColor; // 可以调整为需要的颜色
	borderLayer.lineWidth = borderWidth; // 可以调整为需要的宽度
	[view.layer addSublayer:borderLayer];

}

#pragma mark - 获取颜色
- (UIColor *)getColorByToken:(NSString *)token {
	if (!self.supportDarkMode) {
		// 不支持暗黑
		return [[self colorWithHex:self.tokenDic[token]] colorWithAlphaComponent:1];
	}
	if (@available(iOS 13.0, *)) {
		return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
			if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
				if ([self.darkTokenDic objectForKey:token]) {
					return [self getColorByTokenValue:self.darkTokenDic[token]];
				} else {
					return [self getColorByTokenValue:self.tokenDic[token]];
				}
			} else {
				return [self getColorByTokenValue:self.tokenDic[token]];
			}
		}];
	} else {
		// Fallback on earlier versions
		return [[self colorWithHex:self.tokenDic[token]] colorWithAlphaComponent:1];
	}
}

- (id)getColorDictByToken:(NSString *)token {
    return self.tokenDic[token];
}

- (void)setViewBackgroundColorWithToken:(NSString *)token view:(UIView *)view size:(CGSize)size{
    id colorDict = self.tokenDic[token];
    if([colorDict isKindOfClass:[NSDictionary class]]){
        
        UIColor *startColor = [[self colorWithHex:[colorDict objectForKey:@"start"]] colorWithAlphaComponent:1];
        UIColor *endColor = [[self colorWithHex:[colorDict objectForKey:@"end"]] colorWithAlphaComponent:1];
        CGFloat degree = [[colorDict objectForKey:@"degree"] floatValue];
        if(isEmptyString_mg([colorDict objectForKey:@"degree"])||degree==0.0f){
            view.backgroundColor = [UIColor gradientColorWithSize:size direction:GradientColorDirectionLevel startColor:startColor endColor:endColor];
        } else {
            view.backgroundColor = [UIColor gradientColorWithSize:size direction:GradientColorDirectionLevel startColor:startColor endColor:endColor angle:degree];
        }
    } else {
        view.backgroundColor = [self getColorByToken:token];
    }
}

#pragma mark - 获取颜色 + 透明度
- (UIColor *)getColorByToken:(NSString *)token alpha:(CGFloat)alpha {
    return [[self colorWithHex:self.tokenDic[token]] colorWithAlphaComponent:alpha];
}

- (UIColor *)colorWithHex:(NSString *)hexColor {
    NSString *colorStr = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
	if ([colorStr length] != 7 && [colorStr length] != 9) {
		return [UIColor clearColor];
	}
    
    //
    if ([colorStr hasPrefix:@"#"]) {
        colorStr = [colorStr substringFromIndex:1];
    }
    NSRange range;
    range.length = 2;
    range.location = 0;

    //red
    NSString *redString = [colorStr substringWithRange:range];

    //green
    range.location = 2;
    NSString *greenString = [colorStr substringWithRange:range];

    //blue
    range.location = 4;
    NSString *blueString= [colorStr substringWithRange:range];
    
    // Scan values
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:redString] scanHexInt:&red];
    [[NSScanner scannerWithString:greenString] scanHexInt:&green];
    [[NSScanner scannerWithString:blueString] scanHexInt:&blue];
	
	//alpha
	if (colorStr.length > 6) {
		range.location = 6;
		NSString *alphaString = [colorStr substringWithRange:range];
		unsigned int alpha;
		[[NSScanner scannerWithString:alphaString] scanHexInt:&alpha];
		return [UIColor colorWithRed:((float)red/ 255.0f) green:((float)green/ 255.0f) blue:((float)blue/ 255.0f) alpha:alpha/255.0f];
	}
    
    return [UIColor colorWithRed:((float)red/ 255.0f) green:((float)green/ 255.0f) blue:((float)blue/ 255.0f) alpha:1];
}

- (UIColor *)dynamicColorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
	if (!self.supportDarkMode) {
		// 不支持暗黑
		return lightColor;
	}
	if (@available(iOS 13.0, *)) {
		return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
			if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
				return darkColor;
			} else {
				return lightColor;
			}
		}];
	} else {
		// Fallback on earlier versions
		return lightColor;
	}
}

#pragma mark - 获取值
- (NSString *)getValueByToken:(NSString *)token {
    return self.tokenDic[token];
}

- (UIColor *)getColorByTokenValue:(id)tokenValue {
	if ([tokenValue isKindOfClass:[NSString class]]) {
		NSString *valueStr = (NSString *)tokenValue;
		if ([tokenValue isEqualToString:@"transparent"]) {
			return [UIColor clearColor];
		} else {
			return [self colorWithHex:valueStr];
		}
	} else {
		return [UIColor clearColor];
	}
}

#pragma mark - 更新Token
- (void)updateTokenJsonWithDic:(NSDictionary *)dic {
    if (dic.count == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Token" ofType:@"json"];
        dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
    }
    
    NSMutableDictionary *localDic = [self.tokenDic mutableCopy];
    NSMutableDictionary *newDic = [dic mutableCopy];
    [localDic addEntriesFromDictionary:newDic];
	_tokenDic = localDic;
	YYCache *cache = [[YYCache alloc] initWithName:@"APP_CACHE"];
	NSMutableDictionary *darkAndLightTokenDic = (NSMutableDictionary *)[cache objectForKey:self.tokenKey];
	[darkAndLightTokenDic setObject:self.tokenDic forKey:@"light"];
	[cache setObject:darkAndLightTokenDic forKey:self.tokenKey];
}

#pragma mark - setter
- (void)setEnableDarkMode:(BOOL)enableDarkMode {
	if (enableDarkMode != _enableDarkMode) {
		_enableDarkMode = enableDarkMode;
		// 不支持暗黑 直接返回
		if (!self.supportDarkMode) return;
		if (@available(iOS 13.0, *)) {
			if (enableDarkMode) {
				[UIApplication sharedApplication].delegate.window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
				[[NSUserDefaults standardUserDefaults] setValue:self.darkModeUserDefaultsDarkValue forKey:self.darkModeUserDefaultsKey];
			} else {
				[UIApplication sharedApplication].delegate.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
				[[NSUserDefaults standardUserDefaults] setValue:self.darkModeUserDefaultsLightValue forKey:self.darkModeUserDefaultsKey];
			}
		} else {
			// Fallback on earlier versions
			[[NSUserDefaults standardUserDefaults] setValue:self.darkModeUserDefaultsLightValue forKey:self.darkModeUserDefaultsKey];
		}
	}
}

@end
