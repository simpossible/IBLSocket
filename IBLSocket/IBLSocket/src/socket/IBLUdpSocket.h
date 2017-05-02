//
//  IBLUdpSocket.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/10.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLSocket.h"

#define udpbuffersize 200 //udp 包是一个一个接收。所以接收之前必须协商好每个包的最大大小

@interface IBLUdpSocket : IBLSocket


/**
 udp 的接收以包为单位。进行udp 通讯的时候 与发送发协商好发送包的最大长度
 */
@property (nonatomic, assign) uint32_t recvBuuferSize;

- (void)startReciveDataFromIp:(NSString *)ip andPort:(NSInteger)port;

@end
