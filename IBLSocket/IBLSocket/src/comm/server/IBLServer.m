//
//  IBLServer.m
//  IBLSocket
//
//  Created by simpossible on 2017/4/23.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLServer.h"
#import "IBLSocket.h"
#import "IBLTcpSoket.h"
#import "IBLUdpSocket.h"

@interface IBLServer ()

@property (nonatomic, strong) IBLUdpSocket * udpSocket;

@end

@implementation IBLServer

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)initialBroadCastInPort:(NSInteger)port {
    self.udpSocket =[[IBLUdpSocket alloc] init];
    [self.udpSocket startReciveDataFromIp:nil andPort:port];
}

+ (instancetype)serverWithBoradCastPort:(NSInteger)port {
    IBLServer *servere = [[self alloc] init];
    [servere initialBroadCastInPort:port];
    return servere;
}

@end
