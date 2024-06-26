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

@property (nonatomic, strong) NSDictionary *tokenDic;

+ (HJTokenManager *)shareInstance;

- (UIColor *)getColorByToken:(NSString *)token;

- (UIColor *)getColorByToken:(NSString *)token alpha:(CGFloat)alpha;

- (NSString *)getValueByToken:(NSString *)token;

- (void)updateTokenJsonWithDic:(NSDictionary *)dic;
///判断是否渐变色使用
- (id)getColorDictByToken:(NSString *)token;

- (UIColor *)colorWithHex:(NSString *)hexColor;

- (void)setViewBackgroundColorWithToken:(NSString *)token view:(UIView *)view size:(CGSize)size;

- (void)setViewRadiusWithToken:(NSString *)token view:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
