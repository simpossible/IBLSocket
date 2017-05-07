//
//  IBLMessageDispatcher.m
//  IBLSocket
//
//  Created by simpossible on 2017/5/4.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLMessageDispatcher.h"

@implementation IBLMessageDispatcher

- (void)dataComes:(NSData *)datal {
    [IBLComm deCodeData:datal succ:^(NSData *finaldata, IBLCommHeader commheader) {
        if (commheader.type == IBLCommTypeJson) {
            NSError *error;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:finaldata options:NSJSONReadingAllowFragments error:&error];
            if (!dic) {
                return ;
            }
//            [self dealUpdJsonMessage:dic andMessageSender:addr];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if ([self.delegate respondsToSelector:@selector(recvBroadast:)]) {
//                    [self.delegate recvBroadast:[NSString stringWithFormat:@"%@",dic]];
//                }
//            });
            
        }
    } fail:^(IBLCommError code) {
        
    }];
}


- (void)dataComes:(NSData *)data from:(IBLSocketConnector *)connector {
    [IBLComm deCodeData:data succ:^(NSData *finaldata, IBLCommHeader commheader) {
        if (commheader.toId == 0) {
            
        }
    } fail:^(IBLCommError code) {
        
    }];
}

@end
