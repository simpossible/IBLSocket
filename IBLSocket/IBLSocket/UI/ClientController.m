//
//  ClientController.m
//  IBLSocket
//
//  Created by simpossible on 2017/4/28.
//  Copyright © 2017年 Ahead. All rights reserved.
//

#import "ClientController.h"
#import "IBLClient.h"

@interface ClientController ()<IBLClientProtocol,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) IBLClient * client;

@property (nonatomic, strong) UITextView * textview;

@property (nonatomic, strong) UIButton * stopButton;

@property (nonatomic, strong) NSMutableArray * servers;

@property (nonatomic, strong) UITableView * serversTable;

@end

@implementation ClientController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.servers = [NSMutableArray array];
    
    self.textview = [[UITextView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.textview];
    
    self.client = [[IBLClient alloc] init];
    [self.client findServerOnPort:43210];
    
    self.client.delegate = self;

    
//    self.stopButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 60, 60)];
//    [self.stopButton setTitle:@"stop" forState:UIControlStateNormal];
//    self.stopButton.backgroundColor = [UIColor orangeColor];
//    [self.stopButton addTarget:self action:@selector(tostop) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.stopButton];
    
    self.serversTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height/2)];
    [self.view addSubview:self.serversTable];
    self.serversTable.delegate = self;
    self.serversTable.dataSource = self;
    
    // Do any additional setup after loading the view.
}

- (void)tostop {
    [self.client  stop];
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

- (void)clientRecvData:(NSData *)data {

}

- (void)serverFinded:(IBLServer *)server {
    [self.servers addObject:server];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.serversTable reloadData];
    });
}


- (void)clientStateChanged:(IBLClientState)state {
    [self toLogMsg:[NSString stringWithFormat:@"the client state change %lu",state]];
    
    if (state == IBLClientStateConnected) {
        [self.client loginWithName:@"simpossible"];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.servers.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"server"];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    IBLServer *server = [self.servers objectAtIndex:indexPath.row];
    cell.textLabel.text = server.serverName;
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IBLServer *server = [self.servers objectAtIndex:indexPath.row];
    [self.client connectToserver:server];
    [self.client loginWithName:@"hehe"];
}
@end
