//
//  IBLComm.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/28.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^IBLCOMMDataBlock)(NSData *finaldata,IBLCommHeader header);
typedef void (^IBLCOMMErrorBlock)(IBLCommError code);

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
 解析数据

 @param orgData 收到的数据
 @param succ 解析成功后处理回调
 @param error 失败回调
 */
+ (void)deCodeData:(NSData *)orgData succ:(IBLCOMMDataBlock)succ fail:(IBLCOMMErrorBlock)error;

@end
