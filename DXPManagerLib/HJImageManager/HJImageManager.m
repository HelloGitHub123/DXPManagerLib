//
//  HJImageManager.m
//  HJControls
//
//  Created by mac on 2022/9/21.
//

#import "HJImageManager.h"
#import <YYCache/YYCache.h>
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import "ManagerHeader.h"

static HJImageManager *imageManager = nil;


@implementation HJImageManager

+ (HJImageManager *)shareInstance {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        imageManager = [[HJImageManager alloc] init];
    });
    return imageManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

- (UIImage *)getImageByName:(NSString *)name {
    if (!isEmptyString_mg(NSUSER_DEF_mg(@"HJThemeCode"))) {
        // 压缩包文件夹路径
//        NSString *zipPath = [self.cachesPath stringByAppendingPathComponent:NSUSER_DEF(@"HJThemeCode")];
        //解压后文件路径，解压后的文件与zip包文件名相同
        NSString *folderPath = [self.cachesPath stringByAppendingPathComponent:NSUSER_DEF_mg(@"HJThemeCode")];
        if ([name containsString:@"ic_"]) {
            NSString *iconPath = [folderPath stringByAppendingPathComponent:@"icon"];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:[iconPath stringByAppendingPathComponent:name]];
            if (image) return image;
        } else if ([name containsString:@"img_"]) {
            NSString *imgPath = [folderPath stringByAppendingPathComponent:@"image"];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:[imgPath stringByAppendingPathComponent:name]];
            if (image) return image;
        }
    }
    return [UIImage imageNamed:name];
}

@end