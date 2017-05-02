//
//  ServerController.m
//  IBLSocket
//
//  Created by simpossible on 2017/4/28.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "ServerController.h"

#import "IBLServer.h"

@interface ServerController ()

@property (nonatomic, strong) IBLServer * server;

@property (nonatomic, strong) UITextView * textview;

@property (nonatomic, strong) UIButton * stopButton;

@end

@implementation ServerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textview = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textview.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.textview];
    
    self.server = [IBLServer serverWithBoradCastPort:43210];
    self.server.delegate = self;
    
    self.stopButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 60, 60)];
    [self.stopButton setTitle:@"stop" forState:UIControlStateNormal];
    self.stopButton.backgroundColor = [UIColor orangeColor];
    [self.stopButton addTarget:self action:@selector(tostop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.stopButton];
    // Do any additional setup after loading the view.
}

- (void)tostop {
    [self.server  stop];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)recvBroadast:(NSString*)msg {
    [self.textview setText:[self.textview.text stringByAppendingString:@"______________________\n"]];
    [self.textview setText:[self.textview.text stringByAppendingString:msg]];
}

- (void)toLogMsg:(NSString *)msg {
    [self.textview setText:[self.textview.text stringByAppendingString:@"______________________\n"]];
    [self.textview setText:[self.textview.text stringByAppendingString:msg]];
}

@end
