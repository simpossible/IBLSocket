//
//  ViewController.m
//  IBLSocket
//
//  Created by simpossible on 2017/4/10.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "ViewController.h"
#import "ClientController.h"
#import "ServerController.h"

#import "IBLServer.h"
#import "IBLClient.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton * serverbutton;

@property (nonatomic, strong) UIButton * clientButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.serverbutton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 60, 60)];
    [self.serverbutton setTitle:@"server" forState:UIControlStateNormal];
    self.serverbutton.backgroundColor = [UIColor orangeColor];
    [self.serverbutton addTarget:self action:@selector(toserver) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.serverbutton];
    
    
    self.clientButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 60, 60)];
    [self.clientButton setTitle:@"client" forState:UIControlStateNormal];
    self.clientButton.backgroundColor = [UIColor orangeColor];
    [self.clientButton addTarget:self action:@selector(toclient) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clientButton];

}


- (void)toserver {
    [self presentViewController:[[ServerController alloc] init] animated:YES completion:nil];
}

- (void)toclient {
    [self presentViewController:[[ClientController alloc] init] animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
