//
//  IBLSocketAddr.m
//  IBLSocket
//
//  Created by simpossible on 2017/4/10.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLSocketAddr.h"
#import <arpa/inet.h>

@implementation IBLSocketAddr

- (instancetype)initWithAddr:(struct sockaddr_in *)addr {
    if (self = [super init]) {
        char addrBuf[16];
        inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN);
        _ip = [NSString stringWithUTF8String:addrBuf];
        _port =ntohs(addr->sin_port);
    }
    return self;
}


+ (instancetype)addrForSocketAddr:(struct sockaddr_in *)addr {
    return [[self alloc] initWithAddr:addr];
}



+ (struct sockaddr_in)v4AddrForIp:(NSString *)ip andPort:(NSInteger)port {
     struct sockaddr_in addr;
    if (ip == nil) {
        return addr;
    }
   
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr([ip UTF8String]);
    addr.sin_len = sizeof(addr);
    addr.sin_port = port;
    memset(&addr.sin_zero, 0, 8);
    return addr;
}

+ (struct sockaddr_in)v4BoradCastAddrForPort:(NSInteger)port {
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr("255.255.255.255");
    return addr;
}

+ (struct sockaddr_in)v4BoradCastAnyIpForPort:(NSInteger)port {
    struct sockaddr_in si_recv;
    int addrlen = sizeof(si_recv);
    bzero(&si_recv,addrlen);
    si_recv.sin_family = AF_INET;
    si_recv.sin_port = htons(port);
    si_recv.sin_addr.s_addr = INADDR_ANY;
    return si_recv;
}
@end
