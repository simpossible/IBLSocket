//
//  ViewController.m
//  IMClient
//
//  Created by simp on 2019/5/21.
//  Copyright © 2019 Ahead. All rights reserved.
//

#import "ViewController.h"
#import "IBLClient.h"

@interface ViewController()<IBLClientProtocol>

@property (nonatomic, strong) IBLClient * client;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.client = [[IBLClient alloc] init];
    self.client.delegate = self;
    //    [self.client findServerOnPort:8877];
    [self.client connectToserver:[IBLServer serverWithName:@"hehe" andIp:@"127.0.0.1" andPort:8877]];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

//- (void)recvBroadast:(NSString*)msg {
//    [self.textview setText:[self.textview.text stringByAppendingString:@"broadcast______________________\n"]];
//    [self.textview setText:[self.textview.text stringByAppendingString:msg]];
//}
//
//- (void)toLogMsg:(NSString *)msg {
//    [self.textview setText:[self.textview.text stringByAppendingString:@"______________________\n"]];
//    [self.textview setText:[self.textview.text stringByAppendingString:msg]];
//}

- (void)clientRecvData:(NSData *)data {
    
}

//- (void)serverFinded:(IBLServer *)server {
//    [self.servers addObject:server];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.serversTable reloadData];
//    });
//}


- (void)clientStateChanged:(IBLClientState)state {
//    [self toLogMsg:[NSString stringWithFormat:@"the client state change %lu",state]];
    
    if (state == IBLClientStateConnected) {
        [self.client loginWithName:@"simpossible"];
    }
}



@end
