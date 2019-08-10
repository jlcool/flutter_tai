//
//  TAIError.h
//  TAISDK
//
//  Created by kennethmiao on 2018/12/4.
//  Copyright © 2018年 kennethmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TAIErrCode)
{
    /*
     成功
     */
    TAIErrCode_Succ   =   0,
    /*
     参数错误
     */
    TAIErrCode_Param,
    /*
     json解析错误
     */
    TAIErrCode_Json,
    /*
     http请求错误
     */
    TAIErrCode_Https,
    /*
     服务器错误
     */
    TAIErrCode_Server,
};

@interface TAIError : NSObject
@property (nonatomic, assign) TAIErrCode code;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *requestId;
+ (id)errorCode:(NSInteger)code desc:(NSString *)desc requestId:(NSString *)requestId;
@end
