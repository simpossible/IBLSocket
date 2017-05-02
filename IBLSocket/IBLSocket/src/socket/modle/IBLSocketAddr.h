//
//  IBLSocketAddr.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/10.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>

@interface IBLSocketAddr : NSObject

@property (nonatomic, copy, readonly) NSString *ip;

@property (nonatomic, assign, readonly) NSInteger port;

+ (instancetype)addrForSocketAddr:(struct sockaddr_in *)addr;

+ (instancetype)addrForHeader:(IBLSocketHeader *)header;

+ (struct sockaddr_in)v4AddrForIp:(NSString *)ip andPort:(NSInteger)port;
+ (struct sockaddr_in)v4BoradCastAddrForPort:(NSInteger)port;

+ (struct sockaddr_in)v4BoradCastAnyIpForPort:(NSInteger)port;
@end
