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
#import "IBLMessageDispatcher.h"
#import "IBLConnectorManager.h"

@interface IBLServer ()<IBLSocketProtocol,IBLSocketConnectorProtocol>

@property (nonatomic, strong) IBLUdpSocket * udpSocket;


/**
 进行通讯的tcp socket。客户端的连接
 */
@property (nonatomic, strong) IBLTcpSoket * tcpSocket;

/**
 tcp的端口
 */
@property (nonatomic, assign) NSInteger tcpPort;

@property (nonatomic, strong) IBLMessageDispatcher * tcpDispatcher;

@property (nonatomic, strong) IBLConnectorManager * connectorManger;

@end

@implementation IBLServer

- (instancetype)init {
    if (self = [super init]) {
        self.serverName = @"IBLServer";
         _tcpPort = 33333;
    }
    return self;
}


- (instancetype)initName:(NSString *)name andIp:(NSString *)ip andPort:(NSInteger)port {
    if (self = [super init]) {
        _hostIp = ip;
        _hostPort = port;
        _serverName = name;
       
    }
    return self;
}

+ (instancetype)serverWithName:(NSString *)name andIp:(NSString *)ip andPort:(NSInteger)port {
    return [[IBLServer alloc] initName:name andIp:ip andPort:port];
}


#pragma mark - 服务端逻辑


+ (instancetype)serverWithBoradCastPort:(NSInteger)port {
    IBLServer *servere = [[self alloc] init];
    [servere initialBroadCastInPort:port];
    return servere;
}

- (void)initialBroadCastInPort:(NSInteger)port {
    self.udpSocket =[[IBLUdpSocket alloc] init];
    self.udpSocket.delegate = self;
    [self.udpSocket setEnableBroadCast:YES];
    self.udpSocket.recvBuuferSize = 200;
    int state = [self.udpSocket bindOnIp:nil atPort:port];
    
    if (state == 0) {
        [self.udpSocket startReciveDataFromIp:nil andPort:port];
    }
}


/**
 开启tcp 服务
 */
- (void)start {
    self.tcpSocket = [[IBLTcpSoket alloc] init];
    self.tcpSocket.delegate = self;
    self.tcpDispatcher = [[IBLMessageDispatcher alloc] init];

    
    int state = [self.tcpSocket bindOnIp:nil atPort:self.tcpPort];
    if (state == 0) {
       int lstate = [self.tcpSocket listen:10];
        [self.tcpSocket accept];
        if (lstate == 0) {
            
        }
    }else {
        NSLog(@"服务器绑定出错");
    }
}


#pragma mark -tcpSocketDelegate

- (void)connectorJoined:(IBLSocketConnector *)connector {
    
    [self.connectorManger addConnector:connector];
    
    connector.delegate = self;
    [connector startRecvData];
}



/**udp 数据到达*/
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
                              @"port":@(self.tcpPort),
                              @"name":self.serverName,
                              };
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSData *jsondata =[IBLComm jsonDataForData:data];
        [self.udpSocket sendData:jsondata ToIp:senderAddr.ip atPort:responsePort];
        
    }
}

#pragma mark tcp连接-

- (void)stop {
    [self.udpSocket stop];
}

#pragma mark - connector 数据转发与处理
- (void)dataComes:(NSData *)data from:(IBLSocketConnector *)connector {
    __weak typeof(self)wself = self;
    [IBLComm deCodeData:data succ:^(NSData *finaldata, IBLCommHeader commheader) {
        if (commheader.toId == 0) {
            NSLog(@"服务器处理数据");
            if (commheader.type == IBLCommTypeJson) {
                [wself serverDealJsonData:finaldata fromConnector:connector];
            }
        }else {
            [wself dispatchData:data toConnector:commheader.toId];
        }
    } fail:^(IBLCommError code) {
        
    }];
}

/**分发数据到其他客户端*/
- (void)dispatchData:(NSData *)data toConnector:(int)toId {
    IBLSocketConnector *toconnector = [self.connectorManger connectorForId:toId];
    [self.tcpSocket sendData:data ToConnector:toconnector result:^(int code, NSString *msg) {
        if (code == 0) {
            NSLog(@"发送失败");
        }
    }];
}

/**处理tcp 逻辑*/
- (void)serverDealJsonData:(NSData *)data fromConnector:(IBLSocketConnector *)connector{
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"json info");
     NSString *key = info[COMMMODULEKEY];
    if ([key isEqualToString:COMMLOGIN]) {
        NSLog(@"收到登录请求");
        NSString *name = [info objectForKey:@"name"]?:@"";
        connector.name = name;
        //向数据库获取 这个login 的好友
        //向好友发送上线消息
        //下发在线好友列表
    }
}

- (void)connectorUnavailable {

}


@end
