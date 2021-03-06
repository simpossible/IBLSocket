//
//  IBLComm.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/28.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBLCommDefine.h"

typedef void (^IBLCOMMDataBlock)(NSData *finaldata,IBLCommHeader commheader);
typedef void (^IBLCOMMErrorBlock)(IBLCommError code);


/**
 通讯层
 */
@interface IBLComm : NSObject

/**
 通讯层数据

 @param orgData 原始数据 比如json
 @param header 原始数据的描述header
 @return 合并的数据
 */
+ (NSData *)dataForData:(NSData *)orgData header:(IBLCommHeader)header;


/**
 通讯层数据
 自动添加json 头部
 @param orgData 原始数据
 @return 编码后的数据
 */
+ (NSData *)jsonDataForData:(NSData *)orgData;


/**
 通讯层数据
 自动添加json 头部

 @param orgData 原始数据
 @param dest 目标的id
 @return 添加协议后的数据
 */
+ (NSData *)jsondataForData:(NSData *)orgData  dest:(int)dest;

+ (NSData *)jsonDataForJsonObj:(NSDictionary *)dic;


/**
 将数据添加上协议
 很多数据需要通过中转 每一个与服务器连接的人都有一个唯一的id
 @param dic dic
 @param dest 目标的序号
 @return 数据
 */
+ (NSData *)jsonDataForJsonObj:(NSDictionary *)dic dest:(int)dest;


/**
 解析数据

 @param orgData 收到的数据
 @param succ 解析成功后处理回调
 @param error 失败回调
 */
+ (void)deCodeData:(NSData *)orgData succ:(IBLCOMMDataBlock)succ fail:(IBLCOMMErrorBlock)error;

+ (NSData*)tcpSendDataForData:(NSData *)data;

@end
