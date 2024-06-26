//
//  HJLanguageManager.h
//  H3A
//
//  Created by mac on 2021/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 此类用于调用国际化接口；
 */

#define kLanguageUrl @"/i18n/app/%@/local.json"

@interface HJLanguageManager : NSObject

@property (nonatomic, strong) NSArray *langArray;

+ (HJLanguageManager *)shareInstance;

- (NSString *)getTextByKey:(NSString *)key;

- (NSString *)getLangNameByLangKey:(NSString *)langKey;

- (void)queryLanguageFile:(NSString *)appCode;

@end

NS_ASSUME_NONNULL_END
