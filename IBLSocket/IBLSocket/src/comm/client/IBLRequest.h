//
//  IBLRequest.h
//  IBLSocket
//
//  Created by simp on 2019/5/23.
//  Copyright © 2019 Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IBLRequest : NSObject

@property (nonatomic, assign, readonly) UInt32 cmd;

@property (nonatomic, assign, readonly) UInt32 seq;

+ (IBLRequest *)withData:(NSData *)data andCmd:(UInt32)cmd;

@end

NS_ASSUME_NONNULL_END
