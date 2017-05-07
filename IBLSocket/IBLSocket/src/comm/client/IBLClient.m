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

@property (nonatomic, strong) NSMutableArray * servers;//发现的服务端

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
        self.servers = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 服务端客户端地址协商
- (void)findServerOnPort:(NSInteger)port {
    self.broadCastPort = port;
    if (!self.udpSocket) {
        self.udpSocket = [[IBLUdpSocket alloc] init];
        [self.udpSocket setEnableBroadCast:YES];
        
        NSInteger recvServerport = port +1;
        int state = [self.udpSocket bindOnIp:nil atPort:recvServerport];
        if (state == 0 ) {
            self.recvServerUdpPort = recvServerport;
            [self.udpSocket startReciveDataFromIp:nil andPort:port];
        }
        self.udpSocket.delegate = self;
    }
    
    if (!self.broadCastTimer) {
        self.broadCastTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(toBroadCast) userInfo:nil repeats:YES];
    }
    self.clientState = IBLClientStateFindingServer;
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
    if ([key isEqualToString:COMMSERVERHERE]) {//服务端发回自己的消息
        
        //停止广播进入tcp 连接状态
        [self.broadCastTimer invalidate];
        self.broadCastTimer = nil;
        NSInteger port = [info[@"port"] integerValue];
        NSString *name = info[@"name"]?:@"";
        
        IBLServer *server = [IBLServer serverWithName:name andIp:senderAddr.ip andPort:port];
        
        if ([self.delegate respondsToSelector:@selector(serverFinded:)]) {
            [self.delegate serverFinded:server];
        }
    }
}

#pragma mark - 开始进行tcp 连接

- (void)initialTcpSocket {
    if (!self.tcpScokt) {
        self.tcpScokt = [[IBLTcpSoket alloc] init];
    }
}

- (void)connectToserver:(IBLServer *)server {
    
    if (self.clientState != IBLClientStateConnecting  && self.clientState != IBLClientStateConnected) {
        self.clientState = IBLClientStateConnecting;
        [self initialTcpSocket];
        int state = [self.tcpScokt connectToIp:server.hostIp atPort:server.hostPort];
        if (state == 0) {
            self.clientState = IBLClientStateConnected;
            NSLog(@"连接服务器成功");
        }else {
            self.clientState = IBLClientStateConnFail;
            NSLog(@"连接服务器失败");
            NSString *error = [NSString stringWithFormat:@"error is %s",strerror(state)];
        }
    }
   
}

#pragma mark - 登录

- (void)loginWithName:(NSString *)name {
    if (self.clientState == IBLClientStateConnected) {
        NSDictionary *loginDic = @{
                                   @"key":@"login",
                                   @"name":name?:@"",
                                   };
        NSData *logData = [IBLComm jsonDataForJsonObj:loginDic dest:0];
        [self.tcpScokt sendData:logData result:^(int code, NSString *msg) {
            if (code == 0) {
                //连接已断开
            }
        }];
        
        
    }
}

#pragma mark - 停止
- (void)stop {
    [self.udpSocket stop];
}


- (void)setClientState:(IBLClientState)clientState {
    _clientState = clientState;
    if ([self.delegate respondsToSelector:@selector(clientStateChanged:)]) {
        [self.delegate clientStateChanged:clientState];
    }
}

- (void)dealloc {
    [self.tcpScokt stop];
}

@end
