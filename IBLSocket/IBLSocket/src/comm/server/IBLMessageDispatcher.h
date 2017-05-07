//
//  IBLMessageDispatcher.h
//  IBLSocket
//
//  Created by simpossible on 2017/5/4.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBLSocketConnector.h"

@protocol IBLMessageDispatcherProtocol <NSObject>


/**
 处理这个数据
 如果toid 为0 则代表无法分发数据。需要处理
 @param data data 去掉socket 头后的数据
 */
- (void)dealData:(NSData *)data;

- (void)sendData:(NSData *)data toConnector:(NSInteger)cid;

@end

@interface IBLMessageDispatcher : NSObject<IBLSocketProtocol>

- (void)dataComes:(NSData *)datal;

- (void)dataComes:(NSData *)data from:(IBLSocketConnector *)connector;

@end
