//
//  HJEntityRequestManager.h
//  HJControls
//
//  Created by mac on 2022/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EntityBlock)(NSArray *retrunArray);


@interface HJEntityItemModel : NSObject

@property (nonatomic, strong) NSString *TITLE;
@property (nonatomic, strong) NSString *VALUE;
@property (nonatomic, strong) NSString *TYPE_Entity;
@property (nonatomic, strong) NSString *CAN_COPY;

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *NAME;
@property (nonatomic, strong) NSString *rowId;
@end




@interface HJEntityListModel : NSObject

@property (nonatomic, strong) NSArray <HJEntityItemModel *> *recordList;

@end



@interface HJEntityRequestManager : NSObject

@property (nonatomic, strong) HJEntityListModel *entityResponseModel;// 仅仅用于获取列表的key，比如充值列表等等

+ (HJEntityRequestManager *)shareInstance;

- (void)queryEntityWithCode:(NSString *)code block:(EntityBlock)block;
@end


NS_ASSUME_NONNULL_END
