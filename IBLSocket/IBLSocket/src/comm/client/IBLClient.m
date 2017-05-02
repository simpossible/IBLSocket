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
#import "IBLSocketAddr.h"

@interface IBLClient ()<IBLSocketProtocol>

@property (nonatomic, strong) IBLUdpSocket * udpSocket;

@property (nonatomic, strong) IBLTcpSoket * tcpScokt;

@property (nonatomic, strong) NSTimer * broadCastTimer;

@property (nonatomic, strong) NSData * broadCastData;

/**广播端口*/
@property (nonatomic, assign) NSInteger broadCastPort;

/** 接收服务端udp 消息的端口 默认广播端口 + 1 */
@property (nonatomic, assign) NSInteger recvServerUdpPort;

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
        
        NSInteger recvServerport = port +1;
        [self.udpSocket bindOnIp:nil atPort:recvServerport error:^(int code, NSString *msg) {
            if (code == 0) {
                self.recvServerUdpPort = recvServerport;
                [self.udpSocket startReciveDataFromIp:nil andPort:port];
                [self.delegate toLogMsg:[NSString stringWithFormat:@"绑定成功 %@",msg]];
            }else {
                [self.delegate toLogMsg:[NSString stringWithFormat:@"绑定失败 %@",msg]];
            }
        }];

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
                          @"key":COMMLOOKFORSERVER,
                          @"count":@(clientcount),
                          @"port":@(self.recvServerUdpPort)
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




- (void)udpDataComes:(NSData *)data from:(IBLSocketAddr *)addr{
    
    NSLog(@"the data from is %@ %ld",addr.ip,addr.port);
    [IBLComm deCodeData:data succ:^(NSData *finaldata, IBLCommHeader commheader) {
        if (commheader.type == IBLCommTypeJson) {
            NSError *error;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:finaldata options:NSJSONReadingAllowFragments error:&error];
            if (!dic) {
                return ;
            }
            [self dealUpdJsonMessage:dic andMessageSender:addr];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(recvBroadast:)]) {
                    [self.delegate recvBroadast:[NSString stringWithFormat:@"%@",dic]];
                }
            });
            
        }
    } fail:^(IBLCommError code) {
        
    }];
}

/**
 *  udp 连接逻辑
 */
- (void)dealUpdJsonMessage:(NSDictionary *)info andMessageSender:(IBLSocketAddr *)senderAddr{
    NSString *key = info[COMMMODULEKEY];
    if ([key isEqualToString:COMMSERVERHERE]) {//有客户端在等待连接
        
        //停止广播进入tcp 连接状态
        [self.broadCastTimer invalidate];
        self.broadCastTimer = nil;
        
        NSInteger port = [info[@"port"] integerValue];        
        [self tcpLinkToIp:senderAddr.ip port:port];
        
    }
}


- (void)tcpLinkToIp:(NSString *)ip port:(NSInteger)port {

}

- (void)stop {
    [self.udpSocket stop];
}
@end
