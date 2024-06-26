//
//  HJThemeManager.m
//  HJControls
//
//  Created by mac on 2022/11/9.
//

#import "HJThemeManager.h"
#import "HJTokenManager.h"
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import <SSZipArchive/SSZipArchive.h>
#import <YYModel/YYModel.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ManagerHeader.h"

typedef void (^HJDownloadUrlBlock) (NSString *string);

static HJThemeManager *themeManager = nil;

@interface HJThemeManager() <SSZipArchiveDelegate>

@property (nonatomic, strong) SwitchThemeBlock switchThemeBlock;

@end

@implementation HJThemeManager

+ (HJThemeManager *)shareInstance {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        themeManager = [[HJThemeManager alloc] init];
    });
    return themeManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

#pragma mark - 一、查询所有主题列表
- (void)queryThemeList:(ThemeListBlock)block {
    [[DCNetAPIClient sharedClient] POST:@"/ecare/theme/pack/list" paramaters:@{} CompleteBlock:^(id res, NSError *error) {
        if (res && [res isKindOfClass:[NSDictionary class]]) {
            if ([HTTP_Code_mg isEqualToString:HTTP_Success_mg] && !isEmptyString_mg(HTTP_Code_mg)){
                self.themeListResponseModel = [HJThemeListModel yy_modelWithDictionary:HTTP_Data_mg];
                block(self.themeListResponseModel.themeList);
            } else {
                block(@[]);
            }
        } else {
            block(@[]);
        }
    }];
}

#pragma mark - 二、查询主题详情
- (void)queryThemeDetailWithThemeId:(NSString *)themeId block:(ThemeDetailBlock)block {    
    [[DCNetAPIClient sharedClient] POST:@"/ecare/theme/pack/detail" paramaters:@{@"themeId":themeId} CompleteBlock:^(id res, NSError *error) {
        if (res && [res isKindOfClass:[NSDictionary class]]) {
            if ([HTTP_Code_mg isEqualToString:HTTP_Success_mg] && !isEmptyString_mg(HTTP_Code_mg)){
                self.themeDetailResponseModel = [HJThemeDetailModel yy_modelWithDictionary:HTTP_Data_mg];
                block(self.themeDetailResponseModel);
            } else {
                block([[HJThemeDetailModel alloc] init]);
            }
        } else {
            block(([[HJThemeDetailModel alloc] init]));
        }
    }];
}

#pragma mark - 三、换肤
- (void)switchThemeWithPackageUrl:(NSString *)packageUrl themeCode:(NSString *)themeCode block:(SwitchThemeBlock)block {
    if (isEmptyString_mg(themeCode)) {
        //说明切换至默认皮肤
        NSUSER_DEF_SET_mg(@"", @"HJThemeCode");
        [[HJTokenManager shareInstance] updateTokenJsonWithDic:@{}];
        block(YES);
        return;
    }
    
	WS_mg(weakSelf);
    // 定义文件夹名称。压缩包名为文件夹名称,就是themeCode
//        NSString *folderName = [[packageUrl lastPathComponent] stringByDeletingPathExtension];
    NSString *folderName = themeCode;

    // 压缩包解压后的文件夹路径
    NSString *folderPath = [self.cachesPath stringByAppendingPathComponent:folderName];
    
    if ([self directoryExists:folderPath]) {
        [self getFilesByPath:folderPath folderName:folderName];
        NSUSER_DEF_SET_mg(folderName, @"HJThemeCode");
        block(YES);
    } else {
        // 不存在文件夹则下载、创建、解压
        self.switchThemeBlock = block;
        [self downloadField:packageUrl block:^(NSString *filePath) {
            if (filePath) {
                NSString *resultPath = [self.cachesPath stringByAppendingPathComponent:folderName];
                if ([weakSelf createFolderWithPath:resultPath]) {
                    [weakSelf releaseZipFiles:filePath unzipPath:resultPath];
                } else {
                    // 创建文件夹失败
                    block(NO);
                }
            } else {
                // 下载文件失败
                block(NO);
            }
        }];
    }
}

#pragma mark - 三、文件处理
#pragma mark - 3.1检测目录文件夹是否存在
- (BOOL)directoryExists:(NSString *)directoryPath {
    BOOL isDir = NO;
    BOOL isDirExist = [self.fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if (isDir && isDirExist) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 3.2 获取文件夹下所有文件列表
- (void)getFilesByPath:(NSString *)directoryPath folderName:(NSString *)folderName {
    // 压缩包中，token.json文件夹路径
    NSString *tokenPath = [directoryPath stringByAppendingPathComponent:@"/token.json"];
    NSData *tokenData = [self.fileManager contentsAtPath:tokenPath];
    NSDictionary *tokenDic = [NSJSONSerialization JSONObjectWithData:tokenData options:1 error:nil];
    if (tokenDic.count > 0 && [tokenDic isKindOfClass:[NSDictionary class]]) {
        // 更新本地缓存和内存中的token.json
        [[HJTokenManager shareInstance] updateTokenJsonWithDic:tokenDic];
    }
    
    //关于图片资源处理，查看HJImageManager
}

#pragma mark - 3.3下载文件。目录文件夹不存在，那么这步
- (void)downloadField:(NSString *)urlString block:(HJDownloadUrlBlock)block {
    // 创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 下载文件
    [[manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *fullPath = [self.cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        // 返回一个URL, 返回的这个URL就是文件的位置的完整路径
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (block) {
            block([filePath path]);
        }
    }] resume];
}

#pragma mark - 3.4创建文件夹。下载完文件，文件需要解压到这个文件夹
- (BOOL)createFolderWithPath:(NSString *)folderPath {
    // 在路径下创建文件夹
    return [self.fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
}


#pragma mark - 四、SSZipArchive
#pragma mark - 解压
- (void)releaseZipFiles:(NSString *)zipPath unzipPath:(NSString *)unzipPath {
    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath delegate:self]) {
        
    } else {
        // 解压失败
    }
}

#pragma mark - SSZipArchiveDelegate
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
    // 解压会出现多余的文件夹__MACOSX，删除掉吧
    NSString *invalidFolder = [unzippedPath stringByAppendingPathComponent:@"__MACOSX"];
    [self.fileManager removeItemAtPath:invalidFolder error:nil];
    /*
    // 或者过滤数组，只取所需要的png文件名
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH %@", @".png"];
    NSArray *reslutFilteredArray = [fileList filteredArrayUsingPredicate:predicate];
    */
    NSString *folderName = [[path lastPathComponent] stringByDeletingPathExtension];
    NSString *resultPath = [self.cachesPath stringByAppendingPathComponent:folderName];
    //删除解压包
    NSString *zipPath = stringFormat_mg(@"%@/%@.skin", self.cachesPath, folderName);
    [self.fileManager removeItemAtPath:zipPath error:nil];

    [self getFilesByPath:resultPath folderName:folderName];
    NSUSER_DEF_SET_mg(folderName, @"HJThemeCode");
    self.switchThemeBlock(YES);
}

@end
