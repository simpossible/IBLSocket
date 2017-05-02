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
                              @"a":@"b"
                              };
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        self.broadCastData = [IBLComm jsonDataForData:jsonData];
    }
    return self;
}


- (void)findServerOnPort:(NSInteger)port {
    self.broadCastPort = port;
    if (!self.udpSocket) {
        self.udpSocket = [[IBLUdpSocket alloc] init];
        [self.udpSocket setEnableBroadCast:YES];
        self.udpSocket.delegate = self;
    }
    
    if (!self.broadCastTimer) {
        self.broadCastTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(toBroadCast) userInfo:nil repeats:YES];
    }
}

- (NSData *)heartData {
    static int clientcount = 0;
    clientcount ++;
    NSDictionary *dic = @{
                          @"key":@"hi",
                          @"count":@(clientcount)
                          };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [IBLComm jsonDataForData:jsonData];
}

- (void)toBroadCast {
    int state =  [self.udpSocket sendData:[self heartData] ToIp:nil atPort:self.broadCastPort];
    
    
    if (state == 0) {
        if ([self.delegate respondsToSelector:@selector(toLogMsg:)]) {
            [self.delegate toLogMsg:[NSString stringWithFormat:@"客户端发送数据成功 len %ld",self.broadCastData.length]];
        }
    }
}


- (void)dataComes:(NSData *)data fromAddr:(IBLSocketAddr *)addr {
    
    [IBLComm deCodeData:data succ:^(NSData *finaldata, IBLCommHeader header) {
        if (header.type == IBLCommTypeJson) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:finaldata options:NSJSONReadingAllowFragments error:nil];
            if ([self.delegate respondsToSelector:@selector(recvBroadast:)]) {
                [self.delegate recvBroadast:[NSString stringWithFormat:@"%@",dic]];
            }

        }
    } fail:^(IBLCommError code) {
        
    }];
}

- (void)stop {
    [self.udpSocket stop];
}
@end
