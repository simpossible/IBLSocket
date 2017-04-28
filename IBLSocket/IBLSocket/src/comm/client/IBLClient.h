//
//  IBLClient.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/23.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IBLClientProtocol <NSObject>

- (void)clientRecvData:(NSData *)data;

- (void)serverFinded:(NSString *)serverName;


@end

@interface IBLClient : NSObject

/**开始*/
- (void)start;

- (void)findServerOnPort:(NSInteger)port;

- (void)connectToserver;



@end
