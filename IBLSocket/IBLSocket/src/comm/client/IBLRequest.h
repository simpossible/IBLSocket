//
//  IBLRequest.h
//  IBLSocket
//
//  Created by simp on 2019/5/23.
//  Copyright © 2019 Ahead. All rights reserved.
//
#import <Foundation/Foundation.h>
#define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 1
#import <Protobuf/GPBProtocolBuffers.h>

@class IBLRequest;

NS_ASSUME_NONNULL_BEGIN

typedef void (^IBLClientReqCallBack)(NSError *error,IBLRequest *resp);

@interface IBLRequest : NSObject

@property (nonatomic, assign, readonly) UInt32 cmd;

@property (nonatomic, assign, readonly) UInt32 seq;

@property (nonatomic, strong, readonly) NSData * sendData;

@property (nonatomic, copy) IBLClientReqCallBack callBack;

+ (IBLRequest *)requestWithData:(NSData *)data andCmd:(UInt32)cmd;

+ (IBLRequest *)requestWithPB:(GPBMessage *)pb andCmd:(UInt32)cmd;

- (void)clear;



@end

NS_ASSUME_NONNULL_END
