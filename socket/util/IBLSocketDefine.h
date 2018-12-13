//
//  IBLSocketDefine.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/27.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 socket 通信协议
 */
typedef struct  {
    size_t len;//当前数据的总长度
    int8_t protoType;// 1.tcp 2.udp    
}IBLSocketHeader;




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
