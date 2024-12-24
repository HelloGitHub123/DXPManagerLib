//
//  HJLanguageManager.m
//  H3A
//
//  Created by mac on 2021/10/9.
//

#import "HJLanguageManager.h"
#import <YYCache/YYCache.h>
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import "ManagerHeader.h"

static HJLanguageManager *languageManager = nil;

@interface HJLanguageManager ()

@property (nonatomic, strong) NSDictionary *langDic;
@property (nonatomic, strong) NSString *languageKey;

@end

@implementation HJLanguageManager

+ (HJLanguageManager *)shareInstance {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        languageManager = [[HJLanguageManager alloc] init];
    });
    return languageManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.languageKey = [NSString stringWithFormat:@"language_%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        YYCache *cache = [[YYCache alloc] initWithName:@"APP_CACHE"];
        BOOL isContains = [cache containsObjectForKey:self.languageKey];
        if (isContains) {
            self.langDic = (NSDictionary *)[cache objectForKey:self.languageKey];
        } else {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Language" ofType:@"json"];
            self.langDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
            [cache setObject:self.langDic forKey:self.languageKey];
        }
    }
    return self;
}

- (NSDictionary *)getAllLangDic {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Language" ofType:@"json"];
	NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
	return dic;
}

- (NSString *)getTextByKey:(NSString *)key {
    NSString *defaultLanguage = NSUSER_DEF_mg(@"cx_language");
    if (isEmptyString_mg(defaultLanguage)) defaultLanguage = @"en";

    if (![[self.langDic objectForKey:defaultLanguage] isKindOfClass:[NSDictionary class]]) return @"";
    NSDictionary *languageDic = [self.langDic objectForKey:defaultLanguage];
    NSString *text = [languageDic objectForKey:key];
    if (isEmptyString_mg(text)) return @"";
    return text;
}

- (void)setLangArray:(NSArray *)langArray {
	_langArray = langArray;
}

- (NSString *)getLangNameByLangKey:(NSString *)langKey {
//    if ([langKey isEqualToString:@"en"]) return @"English";
//    if ([langKey isEqualToString:@"my"]) return @"Malaysia";
    for (NSDictionary *dic in _langArray) {
        if ([langKey isEqualToString:dic[@"value"]]) {
            return dic[@"name"];
        }
    }
    return langKey;
}

- (void)queryLanguageFile:(NSString *)appCode {
    [[DCNetAPIClient sharedClient] GET:[NSString stringWithFormat:kLanguageUrl, appCode] paramaters:@{} CompleteBlock:^(id res, NSError *error) {
        if (res && [res isKindOfClass:[NSDictionary class]]) {
			NSMutableDictionary *endDic = [self.langDic mutableCopy]; //[[NSMutableDictionary alloc] init];
            NSArray *dictKeysArr = [res allKeys];
            for (int i = 0; i< dictKeysArr.count; i++) {
                NSString *key = dictKeysArr[i];
                NSMutableDictionary *localDic = [[self.langDic objectForKey:key] mutableCopy];
                NSMutableDictionary *serverDic = [[res objectForKey:key] mutableCopy];
                [serverDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [localDic setObject:objectOrEmptyStr_mg(obj) forKey:key];
                }];
                [endDic setValue:localDic forKey:key];
            }
            self.langDic = [NSDictionary dictionaryWithDictionary:endDic];
            YYCache *cache = [[YYCache alloc] initWithName:@"APP_CACHE"];
            [cache setObject:self.langDic forKey:self.languageKey];
        }
    }];
}

@end
