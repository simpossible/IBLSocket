//
//  IBLUdpSocket.m
//  IBLSocket
//
//  Created by simpossible on 2017/4/10.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLSocketAddr.h"
#import "IBLUdpSocket.h"
#import <arpa/inet.h>
@interface IBLUdpSocket ()

@property (nonatomic, strong) NSThread * udpRecvThread;

@property (nonatomic, assign) NSInteger dataRecvPort;

@property (nonatomic, copy) NSString * dataRecvIp;

@end

@implementation IBLUdpSocket


- (instancetype)init {
    if (self = [super init]) {
      _socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    }
    return self;
}

- (void)startReciveData {

}

//udp 不支持
- (void)connectToIp:(NSString *)ip atPort:(NSInteger)port error:(IBLSocketError)err{

}

- (void)accept {
    
}

- (void)setEnableBroadCast:(BOOL)en {
    int n = en?1:0;
    setsockopt(_socket, SOL_SOCKET, SO_BROADCAST, &n, sizeof(n));
}

- (void)sendData:(NSData *)data ToIp:(NSString *)ip atPort:(NSInteger)port {
    
    int headerlen = sizeof(IBLScoketHeader);
    IBLScoketHeader *header = malloc(headerlen);
    header->len = headerlen + data.length;
    header->protoType =2;
    header->fromIp = inet_addr([_currentBindedIp UTF8String]);
    header->fromPort = (unsigned int)_currentBindedPort;
    
    void * protocolData = malloc(header->len);
    memcpy(protocolData, header, headerlen);//拷贝头
    memcpy(protocolData+headerlen, [data bytes], data.length);
    
    struct sockaddr_in addr = [IBLSocketAddr v4BoradCastAddrForPort:port];
   
   
    
    sendto(_socket, protocolData, header->len, 0, (struct sockaddr*)&addr, sizeof(addr));
    
    free(header);
    free(protocolData);
}


- (void)reciveFrom:(NSString *)ip atPort:(NSInteger)port {
    
    struct sockaddr_in server;
    if (ip || ![ip isEqualToString:@""]) {
        server = [IBLSocketAddr v4AddrForIp:ip andPort:port];
    }else {
        server = [IBLSocketAddr v4BoradCastAnyIpForPort:port];//广播
    }
    
    char *buffer = malloc(sizeof(IBLScoketHeader));
    unsigned int len = sizeof(server);
    ssize_t size =  recvfrom(_socket, buffer, sizeof(IBLScoketHeader), 0, (struct sockaddr *)&server, &len);
    IBLScoketHeader *header = (IBLScoketHeader *)buffer;
    
    if (size < header->len) {
        size_t restLen = header->len - len;
        char *restBuffer = malloc(header->len);
        ssize_t lenght =recvfrom(_socket, buffer, restLen, 0, (struct sockaddr *)&server, &len);
        if (lenght != restLen) {
            NSLog(@"数据接收异常");
        }
        NSData *data = [[NSData alloc] initWithBytes:restBuffer length:restLen];
        IBLSocketAddr *addr = [IBLSocketAddr addrForSocketAddr:&server];
        if ([self.delegate respondsToSelector:@selector(dataComes:)]) {
            [self.delegate dataComes:data];
        }
    }
}

- (void)startReciveDataFromIp:(NSString *)ip andPort:(NSInteger)port {
    self.dataRecvPort = port;
    self.dataRecvIp = ip;
    if (!self.udpRecvThread) {
        self.udpRecvThread = [[NSThread alloc] initWithTarget:self selector:@selector(reciveData) object:nil];
        [self.udpRecvThread start];
    }
}

- (void)reciveData {
    [self reciveFrom:self.dataRecvIp atPort:self.dataRecvPort];
}

@end
