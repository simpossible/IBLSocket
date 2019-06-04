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
    NSMutableData *muteData = [NSMutableData dataWithCapacity:data.length + 4];
    int cmd = self.cmd;
    int aa = self.seq;
    [muteData appendBytes:&cmd length:4];//增加命令号
    [muteData appendBytes:&aa length:4];//增加序列号
    [muteData appendData:data];
    self.sendData = muteData;
}

+ (IBLRequest *)requestWithPB:(GPBMessage *)pb andCmd:(UInt32)cmd {
    NSData *sendData = [pb data];
    return  [self requestWithData:sendData andCmd:cmd];
}

- (void)clear {
    self.sendData = nil;
}

@end
