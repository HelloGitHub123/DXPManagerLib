//
//  ManagerHeader.h
//  DXPManagerLib
//
//  Created by 李标 on 2024/6/26.
//

#ifndef ManagerHeader_h
#define ManagerHeader_h


#define isNull_mg(x)                (!x || [x isKindOfClass:[NSNull class]])
#define isEmptyString_mg(x)         (isNull_mg(x) || [x isEqual:@""] || [x isEqual:@"(null)"] || [x isEqual:@"null"])
#define objectOrEmptyStr_mg(obj)    ((obj) ? (obj) : @"")

#define HTTP_Data_mg                (isNull_mg([res objectForKey:@"data"])?@"":[res objectForKey:@"data"])
#define HTTP_Code_mg                (isNull_mg([res objectForKey:@"code"])?@"":[res objectForKey:@"code"])
#define HTTP_Success_mg             @"200"

//将数据保存在本地
#define NSUSER_DEF_SET_mg(a,b) [[NSUserDefaults standardUserDefaults] setValue:a forKey:b]
//从本地读取数据
#define NSUSER_DEF_mg(a)  [[NSUserDefaults standardUserDefaults] valueForKey:a]

#define stringFormat_mg(s, ...)     [NSString stringWithFormat:(s),##__VA_ARGS__]

#define WS_mg(weakSelf)    __weak __typeof(&*self)weakSelf = self

#endif /* ManagerHeader_h */
