//
//  HJImageManager.h
//  HJControls
//
//  Created by mac on 2022/9/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 此类用于展示Image，用户换肤；
 */

@interface HJImageManager : NSObject

@property (nonatomic, strong) NSString *cachesPath;

@property (nonatomic, strong) NSFileManager *fileManager;

+ (HJImageManager *)shareInstance;

- (UIImage *)getImageByName:(NSString *)name;

// 获取svg 图片
- (UIImage *)getSVGImageByName:(NSString *)name tintColor:(NSString *)colorStr;

@end

NS_ASSUME_NONNULL_END
