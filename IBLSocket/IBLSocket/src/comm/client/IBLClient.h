//
//  IBLClient.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/23.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IBLClientProtocol <IBLCommProtocol>

- (void)clientRecvData:(NSData *)data;

- (void)serverFinded:(NSString *)serverName;


@end

@interface IBLClient : NSObject

@property (nonatomic, weak) id<IBLClientProtocol> delegate;

/**开始*/
- (void)start;

- (void)findServerOnPort:(NSInteger)port;

- (void)connectToserver;


- (void)stop;
@end
