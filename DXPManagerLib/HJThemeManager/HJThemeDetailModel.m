//
//  HJThemeDetailModel.m
//  DCBaseKitLib
//
//  Created by mac on 2023/6/19.
//

#import "HJThemeDetailModel.h"

@implementation HJThemePackageModel

@end

@implementation HJThemePreviewItemModel

@end

@implementation HJThemeDetailModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"themePreviewList" : [HJThemePreviewItemModel class],
    };
}

@end
