//
//  IBLServer.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/23.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IBLServerProtocol <IBLCommProtocol>


@end

@interface IBLServer : NSObject

@property (nonatomic, copy) NSString * serverName;

/**这个服务器的地址*/
@property (nonatomic, copy) NSString * hostIp;

/**这个服务器的tcp 连接端口*/
@property (nonatomic, assign) NSInteger hostPort;

- (instancetype)init __unavailable;

+ (instancetype)serverWithName:(NSString *)name andIp:(NSString *)ip andPort:(NSInteger)port;

#pragma mark - 作为服务端

@property (nonatomic, weak) id<IBLServerProtocol> delegate;

/**
 * 接收广播的端口。客户端向这个端口发送广播。收到回应后进行tcp连接
 */
+ (instancetype)serverWithBoradCastPort:(NSInteger)port;

- (void)start;

- (void)stop;

@end
