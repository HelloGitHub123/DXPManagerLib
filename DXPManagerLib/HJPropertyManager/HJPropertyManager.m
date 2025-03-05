//
//  HJPropertyManager.m
//  HJControls
//
//  Created by mac on 2022/9/22.
//

#import "HJPropertyManager.h"
#import <YYCache/YYCache.h>
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import "ManagerHeader.h"
#import "HJLanguageManager.h"

static HJPropertyManager *propertyManager = nil;

@interface HJPropertyManager ()

@property (nonatomic, strong) NSDictionary *propertyDic;
@property (nonatomic, strong) NSString *propertyKey;

@end

@implementation HJPropertyManager

+ (HJPropertyManager *)shareInstance {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        propertyManager = [[HJPropertyManager alloc] init];
    });
    return propertyManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.propertyKey = [NSString stringWithFormat:@"propery_%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        YYCache *cache = [[YYCache alloc] initWithName:@"APP_CACHE"];
        BOOL isContains = [cache containsObjectForKey:self.propertyKey];
        if (isContains) {
            self.propertyDic = (NSDictionary *)[cache objectForKey:self.propertyKey];
        } else {
			NSString *path = [[NSBundle mainBundle] pathForResource:@"Property" ofType:@"json"];
			if (path) {
				self.propertyDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];
			} else {
				self.propertyDic = @{};
			}
			[cache setObject:self.propertyDic forKey:self.propertyKey];
        }
    }
    return self;
}

- (NSDictionary *)getProperyJson {
    return self.propertyDic;
}

- (void)queryPropertyFile {
    [[DCNetAPIClient sharedClient] GET:kPropertyUrl paramaters:@{} CompleteBlock:^(id res, NSError *error) {
        if (res && [res isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *localDic = [NSMutableDictionary dictionaryWithDictionary:self.propertyDic];
            [self mergingWithNewDict:res localDict:localDic];
            self.propertyDic = [NSDictionary dictionaryWithDictionary:localDic];
            YYCache *cache = [[YYCache alloc] initWithName:@"APP_CACHE"];
            [cache setObject:self.propertyDic forKey:self.propertyKey];
            
            NSDictionary *globalDic = self.propertyDic[@"global"];
            NSString *appCode = globalDic[@"appCode"];
            if (!isEmptyString_mg(appCode)) {
                [[HJLanguageManager shareInstance] queryLanguageFile:appCode];
            }
            
            NSDictionary *loginDic = self.propertyDic[@"login"];
            NSArray *loginTypeArray = loginDic[@"loginType"];
            
            NSMutableDictionary * userInfo = [NSMutableDictionary new];
            [userInfo setValue:isEmptyString_mg([loginTypeArray firstObject])?@"":[loginTypeArray firstObject] forKey:@"loginType"];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"GotoLoginVCNotification" object:nil userInfo:userInfo];
        }
    }];
}

- (void)mergingWithNewDict:(NSDictionary *)newDict localDict:(NSMutableDictionary *)localDict {
    for (id key in [newDict allKeys]) {
        NSDictionary *obj = [newDict objectForKey:key];
        NSMutableDictionary *localObj = [NSMutableDictionary dictionaryWithDictionary:[localDict objectForKey:key]];
        if ([obj isKindOfClass:[NSDictionary class]] && [localObj isKindOfClass:[NSDictionary class]]) {
            for (id subKey in [obj allKeys]) {
                id subObj = [obj objectForKey:subKey];
                if (subObj) {
                    [localObj setObject:subObj forKey:subKey];
                    [localDict setObject:localObj forKey:key];
                }
            }
        }
    }
}

- (void)UpdatePropertyDic:(NSDictionary *)propertyDic {
	self.propertyDic = propertyDic;
}
@end
