//
//  IBLConnectorManager.h
//  IBLSocket
//
//  Created by simpossible on 2017/5/4.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBLSocketConnector.h"

@interface IBLConnectorManager : NSObject

- (NSArray *)allConnector;

- (void)addConnector:(IBLSocketConnector *)connector;

- (IBLSocketConnector *)connectorForId:(NSInteger)cid;

//- (IBLConnectorManager *)connectorForIp:(NSString *)ip andPort:(NSString *)port;

@end
