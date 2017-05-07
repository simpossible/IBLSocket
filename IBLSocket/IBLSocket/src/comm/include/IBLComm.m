//
//  IBLComm.m
//  IBLSocket
//
//  Created by simpossible on 2017/4/28.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "IBLComm.h"

@implementation IBLComm

NSString * const  COMMMODULEKEY = @"key";
NSString * const  COMMLOOKFORSERVER = @"hi";
NSString * const  COMMSERVERHERE = @"yeah";
NSString * const  COMMLOGIN; = @"login";

+ (NSData *)dataForData:(NSData *)orgData header:(IBLCommHeader)header {
    if (orgData) {
        NSMutableData *data = [NSMutableData dataWithBytes:&header length:sizeof(header)];
        [data appendData:orgData];
        
        IBLCommHeader *header1 = [data bytes];
        return data;
    }
    return nil;
}

+ (NSData *)jsonDataForData:(NSData *)orgData {
    IBLCommHeader header;
    header.type = IBLCommTypeJson;
    return  [self dataForData:orgData header:header];
}

+ (NSData *)jsondataForData:(NSData *)orgData dest:(int)dest {
    IBLCommHeader header;
    header.type = IBLCommTypeJson;
    header.toId = dest;
    return [self dataForData:orgData header:header];
}

+ (NSData *)jsonDataForJsonObj:(NSDictionary *)dic {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    if (data) {
        return  [self jsonDataForData:data];
    }
    return data;
}

+ (NSData *)jsonDataForJsonObj:(NSDictionary *)dic dest:(int)dest {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    if (data) {
        return  [self jsondataForData:data dest:dest];
    }
    return data;
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
