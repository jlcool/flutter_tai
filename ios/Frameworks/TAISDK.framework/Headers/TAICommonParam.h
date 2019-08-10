//
//  TAICommonParam.h
//  TAISDK
//
//  Created by kennethmiao on 2018/12/25.
//  Copyright © 2018年 kennethmiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAICommonParam : NSObject
/**
 * 账号应用id
 */
@property (nonatomic, strong) NSString *appId;
/**
 * 超时时间（默认30秒）
 */
@property (nonatomic, assign) NSInteger timeout;
/**
 * 重试次数（默认0次）
 */
@property (nonatomic, assign) NSInteger retryTimes;
/**
 * secretId
 */
@property (nonatomic, strong) NSString *secretId;
/**
 * secretKey
 * @brief 使用内部签名，此处必填
 */
@property (nonatomic, strong) NSString *secretKey;
/**
 * token
 * @brief 临时secretKey方案此处必填
 */
@property (nonatomic, strong) NSString *token;
/**
 * 时间戳
 * @brief 使用外部签名，此处必填
 */
@property (nonatomic, assign) NSInteger timestamp;
/**
 * 签名
 * @brief 使用外部签名，此处必填（https://cloud.tencent.com/document/product/1004/30611 第三步）
 */
@property (nonatomic, strong) NSString *signature;
@end
