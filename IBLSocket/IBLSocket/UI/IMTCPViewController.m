//
//  IMTCPViewController.m
//  IBLSocket
//
//  Created by simp on 2019/5/22.
//  Copyright © 2019 Ahead. All rights reserved.
//

#import "IMTCPViewController.h"
#import "IBLClient.h"
#import "Im.pbobjc.h"

@interface IMTCPViewController ()<IBLClientProtocol>
@property (weak, nonatomic) IBOutlet UIButton *startConnectButton;
@property (weak, nonatomic) IBOutlet UITextField *portFiled;
@property (weak, nonatomic) IBOutlet UITextField *dataField;
@property (weak, nonatomic) IBOutlet UIButton *tcpSendButton;
@property (weak, nonatomic) IBOutlet UIButton *udpSendButton;
@property (weak, nonatomic) IBOutlet UITextField *uidField;
@property (nonatomic, strong) IBLClient * client;
@end

@implementation IMTCPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.client = [[IBLClient alloc] init];
    self.client.delegate = self;
    self.portFiled.text = @"8877";
    //    [self.client findServerOnPort:8877];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)tcpSendClicked:(id)sender {
    NSString *str = self.dataField.text;
    NSData *data1 = [str dataUsingEncoding:NSUTF8StringEncoding];
    IBLBaseReq *req = [IBLBaseReq message];
    [req setAppId:1];
    [req setSendName:str];
    [req setMarketId:0];

//    [self.client sendTcpData:data];
    [self.client sendPBRequest:req withCMD:1 withCallBack:^(NSError * _Nonnull error, IBLRequest * _Nonnull resp) {
        NSLog(@"error");
    }];
}
- (IBAction)udpSendClicked:(id)sender {
}
- (IBAction)ConnectSendClicked:(id)sender {
    if (self.portFiled.text.length != 0) {
        [self.client connectToserver:[IBLServer serverWithName:@"hehe" andIp:@"127.0.0.1" andPort:self.portFiled.text.integerValue]];
    }
}



- (void)clientRecvData:(NSData *)data {
    
}

- (void)serverFinded:(IBLServer *)server {
  
}


- (void)clientStateChanged:(IBLClientState)state {
    
    if (state == IBLClientStateConnected) {
        self.startConnectButton.enabled = NO;
        [self.startConnectButton setTitle:@"已链接" forState:(UIControlStateNormal)];
    }else if (state == IBLClientStateConnecting) {
        self.startConnectButton.enabled = NO;
        [self.startConnectButton setTitle:@"链接中" forState:(UIControlStateNormal)];
    }else if (state == IBLClientStateNone) {
        self.startConnectButton.enabled = YES;
        [self.startConnectButton setTitle:@"链接" forState:(UIControlStateNormal)];
    }else if (state == IBLClientStateConnFail) {
        self.startConnectButton.enabled = YES;
        [self.startConnectButton setTitle:@"重新链接" forState:(UIControlStateNormal)];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
