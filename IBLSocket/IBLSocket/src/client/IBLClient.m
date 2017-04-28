//
//  IBLClient.m
//  IBLSocket
//
//  Created by simpossible on 2017/4/23.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLClient.h"

#import "IBLUdpSocket.h"
#import "IBLTcpSoket.h"


@interface IBLClient ()

@property (nonatomic, strong) IBLUdpSocket * updSocket;

@property (nonatomic, strong) IBLTcpSoket * tcpScokt;

@end

@implementation IBLClient


- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)findServer {

}

@end
