//
//  IBLSocketConnector.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/20.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <netinet/in.h>
#import "IBLSocket.h"

@class IBLSocketConnector;
@protocol IBLSocketConnectorProtocol <NSObject>

- (void)dataComes:(NSData *)data from:(IBLSocketConnector *)connector;


/**
 连接失效
 */
- (void)connectorUnavailable;

@end

@interface IBLSocketConnector : NSObject

@property (nonatomic, copy) NSString *ip;

@property (nonatomic, assign) NSInteger port;

@property (nonatomic, assign,readonly) NSInteger index;//唯一标识

@property (nonatomic, copy) NSString * name;


+ (instancetype)connectorForAddr:(struct sockaddr_in )addr andIndex:(NSInteger)index;


@property (nonatomic, weak) id<IBLSocketConnectorProtocol> delegate;


/**
 开启数据通道，收集监听这个连接者发来的数据
 */
- (void)startRecvData;

@end
