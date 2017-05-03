//
//  IBLClient.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/23.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBLServer.h"

typedef NS_ENUM(NSUInteger,IBLClientState) {
    IBLClientStateNone,
    IBLClientStateFindingServer,
    IBLClientStateConnecting,
    IBLClientStateConnFail,
    IBLClientStateConnected,
};

@protocol IBLClientProtocol <IBLCommProtocol>

- (void)clientRecvData:(NSData *)data;

- (void)serverFinded:(IBLServer *)server;

- (void)clientStateChanged:(IBLClientState)state;

@end



@interface IBLClient : NSObject

@property (nonatomic, weak) id<IBLClientProtocol> delegate;

@property (nonatomic, assign) IBLClientState clientState;

/**开始*/
- (void)start;

- (void)findServerOnPort:(NSInteger)port;

- (void)connectToserver:(IBLServer *)server;


/**
 登录服务器
 虽然连接成功-> 向服务器发送自己的信息
 @param name 他人显示的昵称
 */
- (void)loginWithName:(NSString *)name;

- (void)stop;
@end
