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
        _recvBuuferSize = 102;//默认值
    }
    return self;
}

- (void)startReciveData {

}

- (void)bindOnIp:(NSString *)ip atPort:(NSInteger)port error:(IBLSocketError)err{
    
    struct sockaddr_in addr;
    if (ip && ![ip isEqualToString:@""]) {
        addr = [IBLSocketAddr v4AddrForIp:ip andPort:port];
    }else {
        addr = [IBLSocketAddr v4BoradCastAnyIpForPort:port];
    }
    int state = bind(_socket, (struct sockaddr *)&addr, sizeof(addr));
    if (state < 0) {
        char *errorstr = strerror(state);
        NSString *nstr = [NSString stringWithFormat:@"bind 错误 %s",errorstr];
        if (err) {
            err(state,nstr);
        }
    }else {
        if (err) {
            err(0,@"");
        }
    }
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

/**
 点对点发送数据
 目前支持协议 udp
 @param data data
 @param ip 目标ip  如果ip 为nil 或者 @“” 那么会广播数据。广播数据 需要开启广播选项 setEnableBroadCast
 @param port 数据发送端口
 */
- (int)sendData:(NSData *)data ToIp:(NSString *)ip atPort:(NSInteger)port {
    
    
    int headerlen = sizeof(IBLSocketHeader);
    IBLSocketHeader *header = malloc(headerlen);
    header->len = headerlen + data.length;
    header->protoType =2;
    
    void * protocolData = malloc(header->len);
    memcpy(protocolData, header, headerlen);//拷贝头
    memcpy(protocolData+headerlen, [data bytes], data.length);
    
    struct sockaddr_in addr = [IBLSocketAddr v4BoradCastAddrForPort:port];
   
    NSData *protocoldt = [NSData dataWithBytes:protocolData length:header->len];
    NSLog(@"the protocol data is %@",protocoldt);
    
    size_t state = sendto(_socket, protocolData, header->len, 0, (struct sockaddr*)&addr, sizeof(addr));
    
    int result = 0;
    if (state != header->len) {
        perror("udp 发送数据失败");
        result = 2;
        
    }
    free(header);
    free(protocolData);
    return 0;
}

- (int)sendData:(NSData *)data toAddr:(IBLSocketAddr *)addr {
    return [self sendData:data ToIp:addr.ip atPort:addr.port];
}


//udp有消息边界 一次recv from 就是一个包啦。所以不能以流的方式拿udp 数据
- (void)reciveFrom:(NSString *)ip atPort:(NSInteger)port {
    
    struct sockaddr_in sender;
    
    char *buffer = malloc(_recvBuuferSize);
    unsigned int len = sizeof(sender);
   
    ssize_t size =  recvfrom(_socket, buffer, _recvBuuferSize, 0, (struct sockaddr *)&sender, &len);
    
    IBLSocketHeader *header = (IBLSocketHeader *)buffer;
    int headerlen = sizeof(IBLSocketHeader);
    
    if (size != header->len) {
        //包和实际实际数据大小不匹配
        [self reportError:IBLSocketErrorCodeUDPRecvSizeError msg:@"size not fit"];
    }else {
        
        if (size > headerlen) {
            NSData *data = [[NSData alloc] initWithBytes:buffer+headerlen length:size-headerlen];
            
            IBLSocketAddr *addr = [IBLSocketAddr addrForSocketAddr:(struct sockaddr_in*)&sender];
            
            if ([self.delegate respondsToSelector:@selector(udpDataComes:from:)]) {
                [self.delegate udpDataComes:data from:addr];
            }
            
        }else {        
        }
    }
    free(buffer);
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
    while (1) {
        if ([self.udpRecvThread isCancelled]) {
            [NSThread exit];
        }
        [self reciveFrom:self.dataRecvIp atPort:self.dataRecvPort];
    }
}

- (void)stop {
    [self.udpRecvThread cancel];
    self.udpRecvThread = nil;
    close(_socket);
}

@end
