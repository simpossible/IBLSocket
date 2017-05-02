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
#import "IBLSocketAddr.h"

@interface IBLServer ()<IBLSocketProtocol>

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
    self.udpSocket.delegate = self;
    [self.udpSocket setEnableBroadCast:YES];
    self.udpSocket.recvBuuferSize = 200;
    [self.udpSocket bindOnIp:nil atPort:port error:^(int code, NSString *msg) {
        if (code == 0) {
             [self.udpSocket startReciveDataFromIp:nil andPort:port];
              [self.delegate toLogMsg:[NSString stringWithFormat:@"绑定成功 %@",msg]];
        }else {
            [self.delegate toLogMsg:[NSString stringWithFormat:@"绑定失败 %@",msg]];
        }
    }];
}

+ (instancetype)serverWithBoradCastPort:(NSInteger)port {
    IBLServer *servere = [[self alloc] init];
    [servere initialBroadCastInPort:port];
    return servere;
}


/**udp 数据到达*/
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
    if ([key isEqualToString:COMMLOOKFORSERVER]) {//有客户端在等待连接
        //回复客户端 需要进行连接的端口
        NSInteger responsePort = [info[@"port"] integerValue];
        NSDictionary *dic = @{
                              @"key":COMMSERVERHERE,
                              @"port":@(11111),
                              };
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSData *jsondata =[IBLComm jsonDataForData:data];
        [self.udpSocket sendData:jsondata ToIp:senderAddr.ip atPort:responsePort];
        
    }
}

- (void)stop {
    [self.udpSocket stop];
}
@end
