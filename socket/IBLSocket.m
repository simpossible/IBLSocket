//
//  IBLSocket.m
//  IBLSocket
//
//  Created by simpossible on 2017/4/10.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLSocket.h"
#import "IBLSocketAddr.h"
#import <errno.h>
#import "IBLSocketConnector.h"
#import <netinet/in.h>
#import <arpa/inet.h>

@interface IBLSocket ()

@property (nonatomic, strong) NSThread *recvThread;

@property (nonatomic, strong) NSThread *acceptThread;//监听连接的线程

@property (nonatomic, copy) NSString * currentBindedIp;

@property (nonatomic, assign) NSInteger currentBindedPort;


@end

@implementation IBLSocket{
    uint32_t _bufferSize;
}

- (instancetype)init {
    if (self = [super init]) {
        _socket = 1;
    }
    return self;
}


- (int)bindOnIp:(NSString *)ip atPort:(NSInteger)port{
    self.currentBindedIp = ip;
    self.currentBindedPort = port;
    struct sockaddr_in addr;
    if (!ip || [ip isEqualToString:@""]) {
        addr = [IBLSocketAddr v4BoradCastAnyIpForPort:port];
    }else {
        addr = [IBLSocketAddr v4AddrForIp:ip andPort:port];
    }
    int state = bind(_socket, (struct sockaddr *)&addr, addr.sin_len);
    return state;
}

- (int)connectToIp:(NSString *)ip atPort:(NSInteger)port{
    struct sockaddr_in addr = [IBLSocketAddr v4AddrForIp:ip andPort:port];
    int state = connect(_socket, (struct sockaddr *)&addr, addr.sin_len);
    if (state == -1) {
        perror("tcp 链接失败");
    }
    return state;
}

- (int)listen:(int)number{
    int state = listen(_socket, number);
    return state;
}

- (void)accept {
    if (!self.acceptThread) {
        //创建一个串行队列 用来接收连接
        self.acceptThread = [[NSThread alloc] initWithTarget:self selector:@selector(toAccept) object:nil];
    }
    if (![self.acceptThread isExecuting]) {
        [self.acceptThread start];
    }
    
}

/**在次线程监听连接*/
- (void)toAccept {

    while (1) {
        if ([self.acceptThread isCancelled]) {
            [NSThread exit];
        }
        struct sockaddr_in client;
        socklen_t leng = sizeof(client);
        int acc = accept(_socket, (struct sockaddr*)&client, &leng);
        IBLSocketConnector *connector = [IBLSocketConnector connectorForAddr:client andIndex:acc];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(connectorJoined:)]) {
                [self.delegate connectorJoined:connector];
            }
        });
    }
}

- (void)sendData:(NSData *)data {

}

- (void)reciveFrom:(NSString *)ip atPort:(NSInteger)port {

}

- (void)stopstopSocket {
    close(_socket);
}

- (void)reportError:(IBLSocketErrorCode)code msg:(NSString *)msg {
    if ([self.delegate respondsToSelector:@selector(socketError:message:)]) {
        [self.delegate socketError:IBLSocketErrorCodeUDPRecvSizeError message:@"UDP：收到包与实际大小不匹配"];
    }
}
@end
