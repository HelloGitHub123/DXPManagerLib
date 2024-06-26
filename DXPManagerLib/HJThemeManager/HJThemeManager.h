//
//  HJThemeManager.h
//  HJControls
//
//  Created by mac on 2022/11/9.
//

#import <Foundation/Foundation.h>
#import "HJThemeListModel.h"
#import "HJThemeDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

/*
 * 此类用于主题包；
 */

typedef void(^ThemeListBlock) (NSArray *retrunArray);
typedef void(^ThemeDetailBlock) (HJThemeDetailModel *themeDetailModel);
typedef void(^SwitchThemeBlock) (BOOL isSuccess);

@interface HJThemeManager : NSObject 

+ (HJThemeManager *)shareInstance;

@property (nonatomic, strong) NSString *cachesPath;

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) HJThemeListModel *themeListResponseModel;
@property (nonatomic, strong) HJThemeDetailModel *themeDetailResponseModel;

- (void)queryThemeList:(ThemeListBlock)block;

- (void)queryThemeDetailWithThemeId:(NSString *)themeId block:(ThemeDetailBlock)block;

- (void)switchThemeWithPackageUrl:(NSString *)packageUrl themeCode:(NSString *)themeCode block:(SwitchThemeBlock)block;

@end

NS_ASSUME_NONNULL_END
