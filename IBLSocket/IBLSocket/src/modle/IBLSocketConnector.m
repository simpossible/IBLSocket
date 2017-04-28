//
//  IBLSocketConnector.m
//  IBLSocket
//
//  Created by simpossible on 2017/4/20.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLSocketConnector.h"
#import <arpa/inet.h>

@interface IBLSocketConnector ()

@property (nonatomic, strong) NSThread * dataThread;//用于接收data 的thread

@end

@implementation IBLSocketConnector

- (instancetype)initWithAddr:(struct sockaddr_in )addr andIndex:(NSInteger)index{
    if (self = [super init]) {
        char addrBuf[16];
        inet_ntop(AF_INET, &addr.sin_addr, addrBuf, INET_ADDRSTRLEN);
        NSString *ip = [NSString stringWithUTF8String:addrBuf];
        _index = index;
    }
    return self;
}

+ (instancetype)connectorForAddr:(struct sockaddr_in )addr andIndex:(NSInteger)index{
    return [[IBLSocketConnector alloc] initWithAddr:addr andIndex:(NSInteger)index];
}

- (void)startRecvData {
    if (!self.dataThread) {
        self.dataThread = [[NSThread alloc] initWithTarget:self selector:@selector(toRecvData) object:nil];
        [self.dataThread start];
    }
}

- (void)toRecvData {
    while (true) {
        if (self.dataThread.isCancelled) {
            [NSThread exit];
        }
        char *buffer = malloc(sizeof(IBLScoketHeader));
        ssize_t len = recv((int)self.index, buffer, sizeof(IBLScoketHeader), 0);
        IBLScoketHeader *header = (IBLScoketHeader *)buffer;
        
        if (len < 0) {//失败
            NSLog(@"socket 连接异常");
            return;
        }
        
        if (len < header->len) {
            size_t restLen = header->len - len;
            char *restBuffer = malloc(header->len);
            ssize_t lenght = recv((int)self.index, restBuffer, restLen, 0);
            if (lenght != restLen) {
                NSLog(@"数据接收异常");
            }
            
            NSData *data = [[NSData alloc] initWithBytes:restBuffer length:restLen];
            if ([self.delegate respondsToSelector:@selector(dataComes:from:)]) {
                [self.delegate dataComes:data from:self];
            }
        }else {
            
        }
        
    }
}

@end
