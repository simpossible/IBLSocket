//
//  IBLSocketDefine.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/27.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#ifndef KIBLSocketDefine
#define KIBLSocketDefine 

#import <Foundation/Foundation.h>


static int16_t iblsocketversion = 1;

/**
 socket 通信协议 字节对齐 占用8个字节
 protoType 协议类型
 version 通信版本号
 */
typedef struct  {
    uint32_t len;//当前数据的总长度
    uint16_t protoType;// 1.tcp 2.udp
    uint16_t version;
    uint16_t verify;//校验码
}IBLSocketHeader;

extern void IBLSocketVerify(IBLSocketHeader * header);




@class IBLSocketConnector;
@class IBLSocketAddr;

typedef NS_ENUM(int,IBLSocketErrorCode) {
    IBLSocketErrorCodeUDPRecvSizeError,
    IBLSocketErrorCodeUDPRecvFail,
};

typedef void (^IBLSocketError)(int code,NSString *msg);

@protocol IBLSocketProtocol <NSObject>

@optional

- (void)dataComes:(NSData *)data;

- (void)socketError:(int)errCode message:(NSString *)msg;

- (void)connectorJoined:(IBLSocketConnector *)connector;



/**
 数据接收
 非基于连接的发送
 @param data data
 @param addr 发送方的地址
 */
- (void)udpDataComes:(NSData *)data from:(IBLSocketAddr*)addr;

@end

#endif
