//
//  HJEntityRequestManager.m
//  HJControls
//
//  Created by mac on 2022/10/19.
//

#import "HJEntityRequestManager.h"
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import <YYModel/YYModel.h>
#import "ManagerHeader.h"

/**获取entity*/
#define kGeneralEntityUrl            @"/ecare/common/entity/%@/records"

@implementation HJEntityItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"TYPE_Entity":@"TYPE"};
}

@end

@implementation HJEntityListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"recordList" : [HJEntityItemModel class],
    };
}

@end



static HJEntityRequestManager *entityRequestManager = nil;

@implementation HJEntityRequestManager

+ (HJEntityRequestManager *)shareInstance {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        entityRequestManager = [[HJEntityRequestManager alloc] init];
    });
    return entityRequestManager;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)queryEntityWithCode:(NSString *)code block:(EntityBlock)block {
    NSString *urlStr = [NSString stringWithFormat:kGeneralEntityUrl, code];
    
    [[DCNetAPIClient sharedClient] GET:urlStr CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            if ([HTTP_Code_mg isEqualToString:HTTP_Success_mg] && !isEmptyString_mg(HTTP_Code_mg)){
                self.entityResponseModel = [HJEntityListModel yy_modelWithDictionary:HTTP_Data_mg];
                block(self.entityResponseModel.recordList);
            } else {
                block(@[]);
            }
        } else {
            block(@[]);
        }
    }];
}

@end
