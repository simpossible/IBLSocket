//
//  IBLConnectorManager.m
//  IBLSocket
//
//  Created by simpossible on 2017/5/4.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLConnectorManager.h"

@interface IBLConnectorManager ()

@property (nonatomic, strong) NSMutableDictionary * allConnectors;

@end

@implementation IBLConnectorManager

- (instancetype)init {
    if (self = [super init]) {
        self.allConnectors = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray *)allConnector {
    return self.allConnectors.allValues;
}

- (void)addConnector:(IBLSocketConnector *)connector {
    [self.allConnectors setObject:connector forKey:@(connector.index)];
}

- (IBLSocketConnector *)connectorForId:(NSInteger)cid {
    return [self.allConnectors objectForKey:@(cid)];
}

- (void)deleteConnectorWithid:(NSInteger)cid {
    [self.allConnectors removeObjectForKey:@(cid)];
}

@end
