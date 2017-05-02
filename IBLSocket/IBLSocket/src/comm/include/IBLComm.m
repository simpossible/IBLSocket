//
//  IBLComm.m
//  IBLSocket
//
//  Created by simpossible on 2017/4/28.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLComm.h"

@implementation IBLComm

+ (NSData *)dataForData:(NSData *)orgData header:(IBLCommHeader)header {
    if (orgData) {
        NSLog(@"send data type %d",header.type);
        NSMutableData *data = [NSMutableData dataWithBytes:&header length:sizeof(header)];
        [data appendData:orgData];
        
        IBLCommHeader *header1 = [data bytes];
        NSLog(@"the buffer is %@",orgData);
        return data;
    }
    return nil;
}

+ (NSData *)jsonDataForData:(NSData *)orgData {
    IBLCommHeader header;
    header.type = IBLCommTypeJson;
    return  [self dataForData:orgData header:header];
}


+ (void)deCodeData:(NSData *)orgData succ:(IBLCOMMDataBlock)succ fail:(IBLCOMMErrorBlock)error {
    if (succ) {
        size_t headerLen = sizeof(IBLCommHeader);
        if (orgData && orgData.length > headerLen) {
            IBLCommHeader *header = malloc(headerLen);
            IBLCommHeader *header1 = (IBLCommHeader *)[orgData bytes];
            NSLog(@"header 1 yhtype i s%d ",header1->type);
            [orgData getBytes:header range:NSMakeRange(0, headerLen)];
            NSLog(@"the header type is %d",header->type);
            NSData *data = [orgData subdataWithRange:NSMakeRange(headerLen, orgData.length-headerLen)];
            succ(data,*header);
            free(header);
            
        }else {
            if (error) {
                error(IBLCommErrorDataError);
            }
        }
    }
}

@end
