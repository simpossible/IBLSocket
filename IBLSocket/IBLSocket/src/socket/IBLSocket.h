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

- (void)bindOnIp:(NSString *)ip atPort:(NSInteger)port error:(IBLSocketError)err;

- (void)connectToIp:(NSString *)ip atPort:(NSInteger)port error:(IBLSocketError)err;

- (void)listen:(int)number error:(IBLSocketError)err;

- (void)accept;

- (void)sendData:(NSData *)data ToConnector:(IBLSocketConnector *)connctor result:(IBLSocketError)result;

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

- (void)sendData:(NSData *)data ToIp:(NSString *)ip atPort:(NSInteger)port;

- (void)setEnableBroadCast:(BOOL)en;


- (void)stop;

@end
