//
//  HJImageManager.m
//  HJControls
//
//  Created by mac on 2022/9/21.
//

#import "HJImageManager.h"
#import <YYCache/YYCache.h>
//#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import "ManagerHeader.h"
#import <DXPCategoryLib/UIImage+Category.h>
#import <DXPCategoryLib/UIColor+Category.h>
#import <SVGKit/SVGKit.h>

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
#if __has_include(<DXPPageBuilderLib/DCPageBuildingViewController.h>)
	// 获取库的 bundle
	NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"DXPPageBuilderLib" ofType:@"bundle"];
	NSBundle *libraryBundle = [NSBundle bundleWithPath:bundlePath];
	// 从 bundle 中加载图片
	UIImage *image = [UIImage imageNamed:name inBundle:libraryBundle compatibleWithTraitCollection:nil];
	return image;
#endif
    return [UIImage imageNamed:name];
}

// 获取svg 图片
- (UIImage *)getSVGImageByName:(NSString *)name tintColor:(NSString *)colorStr {
	NSString *desiredColorHex = colorStr;
	if (!desiredColorHex || desiredColorHex.length == 0) {
		// 默认svg颜色
		desiredColorHex = @"FF5E00";
	}
#if __has_include(<DXPPageBuilderLib/DCPageBuildingViewController.h>)
	// 获取资源包的路径
	NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"DXPPageBuilderLib" ofType:@"bundle"]];
	// 加载 SVG 文件
	NSString *svgFilePath = [bundle pathForResource:name ofType:@"svg"];
	if (svgFilePath) {
		NSError *error = nil;
		NSString *svgContent = [NSString stringWithContentsOfFile:svgFilePath encoding:NSUTF8StringEncoding error:&error];
		if (error) {
			NSLog(@"Log:=== Error reading SVG file: %@", error.localizedDescription);
		} else {
			// 替换填充颜色
			svgContent = [svgContent stringByReplacingOccurrencesOfString:@"fill=\"FF5E00\"" withString:[NSString stringWithFormat:@"fill=\"%@\"", desiredColorHex]];
			
			// 将修改后的内容写入临时文件
			NSString *tempFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.svg"];
			[svgContent writeToFile:tempFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
			
			// 重新加载 SVG 内容
			SVGKImage *svgImage = [SVGKImage imageWithContentsOfFile:tempFilePath];
			return svgImage.UIImage;
		}
	}
#endif
	UIColor *svgColor = [UIColor colorWithHexString:desiredColorHex];
	return [UIImage svgImageNamed:name tintColor:svgColor];
}

@end
