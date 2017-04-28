//
//  IBLUdpSocket.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/10.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLSocket.h"

@interface IBLUdpSocket : IBLSocket

- (void)startReciveDataFromIp:(NSString *)ip andPort:(NSInteger)port;

@end
