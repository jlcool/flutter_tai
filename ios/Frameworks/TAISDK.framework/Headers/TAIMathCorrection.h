//
//  TAIMathCorrection.h
//  TAISDK
//
//  Created by kennethmiao on 2018/12/25.
//  Copyright © 2018年 kennethmiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TAICommonParam.h"
#import "TAIError.h"


@interface TAIMathCorrectionItem : NSObject
//计算结果
@property (nonatomic, assign) BOOL result;
//算式位置
@property (nonatomic, assign) CGRect rect;
//算式字符串
@property (nonatomic, strong) NSString *formula;
//推荐答案
@property (nonatomic, strong) NSString *answer;
@end


@interface TAIMathCorrectionRet : NSObject
//sessionId
@property (nonatomic, strong) NSString *sessionId;
//items
@property (nonatomic, strong) NSArray<TAIMathCorrectionItem *> *items;
@end



@interface TAIMathCorrectionParam : TAICommonParam
//业务应用id（默认为default）
@property (nonatomic, strong) NSString *hcmAppId;
//sessionId
@property (nonatomic, strong) NSString *sessionId;
//图片数据
@property (nonatomic, strong) NSData *imageData;
@end




typedef void (^TAIMathCorrectionCallback)(TAIError *error, TAIMathCorrectionRet *result);

@interface TAIMathCorrection : NSObject
/**
 * 速算题目批改
 * @param param 参数
 * @param callback 回调
 */
- (void)mathCorrection:(TAIMathCorrectionParam *)param callback:(TAIMathCorrectionCallback)callback;
/**
 * 获取签名所需字符串
 * @param timestamp 时间戳
 * @return NSString 签名
 */
- (NSString *)getStringToSign:(NSInteger)timestamp;
@end
