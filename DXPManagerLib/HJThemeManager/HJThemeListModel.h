//
//  HJThemeListModel.h
//  HJControls
//
//  Created by mac on 2022/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJThemeItemModel : NSObject

@property (nonatomic, strong) NSString *themeId;
@property (nonatomic, strong) NSString *themeName;
@property (nonatomic, strong) NSString *themeCode;
@property (nonatomic, strong) NSString *themeCover;//主题封面
@property (nonatomic, strong) NSString *themeDesc;
@property (nonatomic, strong) NSString *themeSize;//主题大小，单位Byte
@property (nonatomic, strong) NSString *themeSizeDisplay;//主题大小展示，带上单位

@end

@interface HJThemeListModel : NSObject

@property (nonatomic, strong) NSArray <HJThemeItemModel *> *themeList;

@end

NS_ASSUME_NONNULL_END
