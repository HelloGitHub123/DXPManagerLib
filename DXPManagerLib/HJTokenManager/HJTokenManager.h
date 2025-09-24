//
//  HJTokenManager.h
//  HJControls
//
//  Created by mac on 2022/9/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 此类用于调用Token接口，用于换肤；
 */

@interface HJTokenManager : NSObject

@property (nonatomic, strong, readonly) NSDictionary *tokenDic;
@property (nonatomic, strong, readonly) NSDictionary *darkTokenDic;

@property (nonatomic, copy) NSString *darkModeUserDefaultsKey;  // 永久化存储的key 默认 cx_dark_mode
@property (nonatomic, copy) NSString *darkModeUserDefaultsDarkValue;  // 永久化存储的key对应的值 默认 dark
@property (nonatomic, copy) NSString *darkModeUserDefaultsLightValue;  // 永久化存储的key对应的值 默认 light
@property (nonatomic, assign) BOOL supportDarkMode;  // 是否支持暗黑
@property (nonatomic, assign) BOOL enableDarkMode;   // 应用暗黑

@property (nonatomic, class, readonly) HJTokenManager *shareInstance;

+ (HJTokenManager *)shareInstance;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (UIColor *)getColorByToken:(NSString *)token;

- (UIColor *)getColorByToken:(NSString *)token alpha:(CGFloat)alpha;

- (NSString *)getValueByToken:(NSString *)token;

- (void)updateTokenJsonWithDic:(NSDictionary *)dic;

- (void)updateTokenJsonWithDic:(NSDictionary *)dic cacheData:(BOOL)cacheData;

///判断是否渐变色使用
- (id)getColorDictByToken:(NSString *)token;

- (UIColor *)colorWithHex:(NSString *)hexColor;

- (void)setViewBackgroundColorWithToken:(NSString *)token view:(UIView *)view size:(CGSize)size;

- (void)setViewRadiusWithToken:(NSString *)token view:(UIView *)view borderColor:(UIColor *)borderColor borderWidth:(CGFloat )borderWidth;

// 暗黑模式的颜色 写死颜色的时候用到
- (UIColor *)dynamicColorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;
@end


typedef void(^DarkModeBlock)(BOOL isDark);

@interface UIView (DarkMode)

- (void)addDarkModeBlock:(DarkModeBlock)block;

@end

NS_ASSUME_NONNULL_END
