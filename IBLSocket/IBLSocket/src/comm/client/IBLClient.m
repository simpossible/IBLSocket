//
//  IBLClient.m
//  IBLSocket
//
//  Created by simpossible on 2017/4/23.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLClient.h"

#import "IBLUdpSocket.h"
#import "IBLTcpSoket.h"


@interface IBLClient ()<IBLSocketProtocol>

@property (nonatomic, strong) IBLUdpSocket * udpSocket;

@property (nonatomic, strong) IBLTcpSoket * tcpScokt;

@property (nonatomic, strong) NSTimer * broadCastTimer;

@property (nonatomic, strong) NSData * broadCastData;

/**广播端口*/
@property (nonatomic, assign) NSInteger broadCastPort;

@end

@implementation IBLClient

- (instancetype)init {
    if (self = [super init]) {
        NSDictionary *dic = @{
                              @"key":@"hi",
                              };
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        self.broadCastData = [IBLComm jsonDataForData:jsonData];
    }
    return self;
}


- (void)findServerOnPort:(NSInteger)port {
    if (!self.udpSocket) {
        self.udpSocket = [[IBLUdpSocket alloc] init];
        [self.udpSocket setEnableBroadCast:YES];
        self.udpSocket.delegate = self;
    }
    
    if (!self.broadCastTimer) {
        self.broadCastTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(toBroadCast) userInfo:nil repeats:YES];
    }
}

- (void)toBroadCast {
    [self.udpSocket sendData:self.broadCastData ToIp:nil atPort:self.broadCastPort];
}


- (void)dataComes:(NSData *)data fromAddr:(IBLSocketAddr *)addr {
    
    [IBLComm deCodeData:data succ:^(NSData *finaldata, IBLCommHeader header) {
        if (header.type == IBLCommTypeJson) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:finaldata options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"收到了udp消息 ： %@",dic);
        }
    } fail:^(IBLCommError code) {
        
    }];
}
@end
