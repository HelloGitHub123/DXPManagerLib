//
//  HJThemeListModel.m
//  HJControls
//
//  Created by mac on 2022/11/9.
//

#import "HJThemeListModel.h"

@implementation HJThemeItemModel

@end

@implementation HJThemeListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"themeList" : [HJThemeItemModel class],
    };
}

@end
