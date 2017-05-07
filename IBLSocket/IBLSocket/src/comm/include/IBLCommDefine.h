//
//  IBLCommDefine.h
//  IBLSocket
//
//  Created by simpossible on 2017/4/28.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#ifndef IBLCommDefine_h
#define IBLCommDefine_h

/**
 server - client 通信协议
 */
typedef struct {
    int8_t type;//数据类型  0:text 1:json 2:image 3:pure data 4:voice 5:music 6
    int toId;//发送的目标客户端id 0 默认为收到的人处理。 其他则转发给其他客户端
    int fromId;//数据源头
}IBLCommHeader;


/**
 server 和client 交互的数据类型
 
 - IBLCommTypeText: 纯文本 utf-8
 - IBLCommTypeJson: json 格式
 - IBLCommTypeImage: 图片
 - IBLCommTypeData: 纯数据
 - IBLCommTypeVoice: 声音
 */
typedef NS_ENUM(int8_t,IBLCommType) {
    IBLCommTypeText = 0,
    IBLCommTypeJson,
    IBLCommTypeImage,
    IBLCommTypeData,
    IBLCommTypeVoice,
};


@protocol IBLCommProtocol <NSObject>

- (void)recvBroadast:(NSString*)msg;

- (void)toLogMsg:(NSString *)msg;

@end


typedef NS_ENUM(int8_t,IBLCommError){
    IBLCommErrorDataError,
} ;

#import "IBLComm.h"


FOUNDATION_EXTERN  NSString * const COMMMODULEKEY;
FOUNDATION_EXTERN  NSString * const COMMLOOKFORSERVER;//寻找服务器
FOUNDATION_EXTERN  NSString * const COMMSERVERHERE;//服务端回复寻找指令
FOUNDATION_EXTERN  NSString * const COMMLOGIN;

#endif /* IBLCommDefine_h */
