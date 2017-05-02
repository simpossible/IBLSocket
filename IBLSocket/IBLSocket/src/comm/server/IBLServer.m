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

- (void)dataComes:(NSData *)data {
    [IBLComm deCodeData:data succ:^(NSData *finaldata, IBLCommHeader header) {
        if (header.type == IBLCommTypeJson) {
            NSError *error;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:finaldata options:NSJSONReadingAllowFragments error:&error];
            if (!dic) {
                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(recvBroadast:)]) {
                    [self.delegate recvBroadast:[NSString stringWithFormat:@"%@",dic]];
                }
            });
            
        }
    } fail:^(IBLCommError code) {
        
    }];
}

- (void)stop {
    [self.udpSocket stop];
}
@end
