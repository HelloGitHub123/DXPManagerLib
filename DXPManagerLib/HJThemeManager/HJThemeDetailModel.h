//
//  HJThemeDetailModel.h
//  DCBaseKitLib
//
//  Created by mac on 2023/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJThemePackageModel : NSObject

@property (nonatomic, strong) NSString *packageUrl;//主题包路径，APP使用

@end

@interface HJThemePreviewItemModel : NSObject

@property (nonatomic, strong) NSString *previewType;//主题预览类型
@property (nonatomic, strong) NSString *previewUrl;//主题预览URL

@end

@interface HJThemeDetailModel : NSObject

@property (nonatomic, strong) HJThemePackageModel *themePackage;
@property (nonatomic, strong) NSArray <HJThemePreviewItemModel *> *themePreviewList;

@end

NS_ASSUME_NONNULL_END
