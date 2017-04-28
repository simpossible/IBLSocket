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

@interface IBLSocketConnector : NSObject

@property (nonatomic, copy) NSString *ip;

@property (nonatomic, assign) NSInteger port;

@property (nonatomic, assign,readonly) NSInteger index;//唯一标识


+ (instancetype)connectorForAddr:(struct sockaddr_in )addr andIndex:(NSInteger)index;


@property (nonatomic, weak) id<IBLSocketProtocol> delegate;

- (void)startRecvData;

@end
