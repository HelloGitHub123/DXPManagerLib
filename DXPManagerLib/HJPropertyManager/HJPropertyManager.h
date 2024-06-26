//
//  HJPropertyManager.h
//  HJControls
//
//  Created by mac on 2022/9/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 此类用于调用Property接口，Property用于渲染界面布局；
 */

#define kPropertyUrl @"/property/cx/property.json"

@interface HJPropertyManager : NSObject

+ (HJPropertyManager *)shareInstance;

- (NSDictionary *)getProperyJson;

- (void)queryPropertyFile;

@end

NS_ASSUME_NONNULL_END
