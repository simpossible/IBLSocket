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



typedef NS_ENUM(int8_t,IBLCommError){
    IBLCommErrorDataError,
} ;

#import "IBLComm.h"



#endif /* IBLCommDefine_h */
