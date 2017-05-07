//
//  IBLSocket.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/10.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBLSocketConnector.h"




@interface IBLSocket : NSObject {
    @protected
    int _socket;
    NSString *_currentBindedIp;
    NSInteger _currentBindedPort;
}

@property (nonatomic, weak) id<IBLSocketProtocol> delegate;

- (instancetype)init;


/**
 绑定端口。如果需要接收他人的包。必须要绑定端口

 @param ip ip
 @param port 端口
 */
- (int)bindOnIp:(NSString *)ip atPort:(NSInteger)port ;

- (int)connectToIp:(NSString *)ip atPort:(NSInteger)port;

/**
 监听连接

 @param number 最大连接数
 @return result
 */
- (int)listen:(int)number;


/**
 开始接收连接
 */
- (void)accept;


/**
 发送数据到连接者
 所有发送数据都是异步接口
 @param data data
 @param connctor 连接着
 @param result 回调
 */
- (void)sendData:(NSData *)data ToConnector:(IBLSocketConnector *)connctor result:(IBLSocketError)result;


/**
 作为主动连接的一方。向连接者发送数据
 客户端->服务端      统一：所有发送数据接口都要为异步
 @param data data
 */
- (void)sendData:(NSData *)data result:(IBLSocketError)result;

/**
    接收当前连接者发来的数据->自己为连接方
 */
- (void)startReciveData;


/**
 接收当前链接者发来的出局->自己为被连接方
 */
- (void)startReciveDataForConnector:(IBLSocketConnector*)connector;

/**upd 方法*/
- (void)reciveFrom:(NSString *)ip atPort:(NSInteger)port;


/**
  点对点发送数据
  目前支持协议 udp
 @param data data
 @param ip 目标ip  如果ip 为nil 或者 @“” 那么会广播数据。广播数据 需要开启广播选项 setEnableBroadCast
 @param port 数据发送端口
 */
- (int)sendData:(NSData *)data ToIp:(NSString *)ip atPort:(NSInteger)port;


/**
 udp 点对点发送数据

 @param data data
 @param addr 对方地址
 @return 结果
 */
- (int)sendData:(NSData *)data toAddr:(IBLSocketAddr*)addr;

/**
 允许接收广播数据

 @param en enable
 */
- (void)setEnableBroadCast:(BOOL)en;

/**
 关闭socket
 */
- (void)stop;


- (void)reportError:(IBLSocketErrorCode)code msg:(NSString *)msg;

@end
