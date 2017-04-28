//
//  IBLServer.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/23.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBLServer : NSObject

/**
 * 接收广播的端口。客户端向这个端口发送广播。收到回应后进行tcp连接
 */
+ (instancetype)serverWithBoradCastPort:(NSInteger)port;

@end
