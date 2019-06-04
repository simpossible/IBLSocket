//
//  IBLRequest.m
//  IBLSocket
//
//  Created by simp on 2019/5/23.
//  Copyright © 2019 Ahead. All rights reserved.
//

#import "IBLRequest.h"

@interface IBLRequest()

@property (nonatomic, strong) NSData * sendData;

@property (nonatomic, assign) UInt32 cmd;

@property (nonatomic, assign) UInt32 seq;

@end

static UInt32 gloableSeq = 0;

@implementation IBLRequest

+ (IBLRequest *)requestWithData:(NSData *)data andCmd:(UInt32)cmd {
    IBLRequest *request = [[IBLRequest alloc] init];
    request.cmd = cmd;
    request.seq = ++ gloableSeq;
    [request generalSenDataWithData:data];
    return request;
}

- (void)generalSenDataWithData:(NSData *)data {
    NSMutableData *muteData = [NSMutableData dataWithCapacity:data.length + 8];
    UInt32 cmd = self.cmd;
    UInt32 aa = self.seq;
    [self appendInt:cmd toData:muteData];//增加命令号
    [self appendInt:aa toData:muteData];//增加序列号
    [muteData appendData:data];
    self.sendData = muteData;
}

- (void)appendInt:(UInt32)value toData:(NSMutableData *)data{
    Byte byte[4] = {};
    byte[0] =  (Byte) ((value>>24) & 0xFF);
    byte[1] =  (Byte) ((value>>16) & 0xFF);
    byte[2] =  (Byte) ((value>>8) & 0xFF);
    byte[3] =  (Byte) (value & 0xFF);
    [data appendBytes:byte length:4];
}


+ (IBLRequest *)requestWithPB:(GPBMessage *)pb andCmd:(UInt32)cmd {
    NSData *sendData = [pb data];
    return  [self requestWithData:sendData andCmd:cmd];
}

- (void)clear {
    self.sendData = nil;
}

@end
