//
//  IBLTcpSoket.m
//  IBLSocket
//
//  Created by simpossible on 2017/4/10.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLTcpSoket.h"
#import "IBLSocketAddr.h"
#import <arpa/inet.h>

@interface IBLTcpSoket ()

@property (nonatomic, strong) NSThread *recvThread;



@end

@implementation IBLTcpSoket {
    BOOL isConnector;//是否是被动连接的一方
}

- (instancetype)init {
    if (self = [super init]) {
        _socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    }
    return self;
}




- (void)startReciveData {
    
    if (!self.recvThread && isConnector) {
        self.recvThread = [[NSThread alloc] initWithTarget:self selector:@selector(reciveData) object:nil];
        [self.recvThread start];
    }
}

- (void)sendData:(NSData *)data ToConnector:(IBLSocketConnector *)connctor result:(IBLSocketError)result{
        
    int headerlen = sizeof(IBLScoketHeader);
    IBLScoketHeader *header = malloc(headerlen);
    header->len = headerlen + data.length;
    header->protoType =2;
    header->fromIp = inet_addr([_currentBindedIp UTF8String]);
    header->fromPort = (unsigned int)_currentBindedPort;
    
    void * protocolData = malloc(header->len);
    memcpy(protocolData, header, headerlen);//拷贝头
    memcpy(protocolData+headerlen, [data bytes], data.length);
    
    ssize_t size = send((int)connctor.index, protocolData,header->len, 0);
    if (size < 0) {
        if (result) {
            result(1,[NSString stringWithFormat:@"%s",strerror((int)size)]);
        }
    }else if (size == 0) {
        if (result) {
            result(2,@"连接已关闭");
        }
    }
    if (size != header->len) {
        if (result) {
            result(3,[NSString stringWithFormat:@"发送数据不符合期望。org :%ld sended :%ld",size,header->len]);
        }
    }
    
    free(header);
    free(protocolData);
}

- (void)connectToIp:(NSString *)ip atPort:(NSInteger)port error:(IBLSocketError)err {
    isConnector = YES;
    [super connectToIp:ip atPort:port error:err];
}


- (void)reciveData {
    
    while (true) {
        if (self.recvThread.isCancelled) {
            [NSThread exit];
        }
        char *buffer = malloc(sizeof(IBLScoketHeader));
        ssize_t len = recv(_socket, buffer, sizeof(IBLScoketHeader), 0);
        IBLScoketHeader *header = (IBLScoketHeader *)buffer;
        
        if (len < header->len) {
            size_t restLen = header->len - len;
            char *restBuffer = malloc(header->len);
            ssize_t lenght = recv(_socket, restBuffer, restLen, 0);
            if (lenght != restLen) {
                NSLog(@"数据接收异常");
            }            
            NSData *data = [[NSData alloc] initWithBytes:restBuffer length:restLen];
            if ([self.delegate respondsToSelector:@selector(dataComes:)]) {
                [self.delegate dataComes:data];
            }
            
            free(restBuffer);
            free(buffer);
        }else {
            free(buffer);
            continue;
        }
        
    }
}


- (void)startReciveDataForConnector:(IBLSocketConnector *)connector {
    connector.delegate = self.delegate;
    [connector startRecvData];
}


@end