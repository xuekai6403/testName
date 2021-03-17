//
//  EFMyPageViewController.m
//  EcoFlow
//
//  Created by wanutoo.xiao on 2021/3/9.
//

#import "EFMyPageViewController.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
@interface EFMyPageViewController ()<GCDAsyncSocketDelegate>
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;

@end

@implementation EFMyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 隐藏导航栏
    self.zx_hideBaseNavBar = YES;
    self.view.backgroundColor = [UIColor blueColor];
    
    [self tcpConnect];
}
- (void)tcpConnect{
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    [self.clientSocket connectToHost:@"192.168.4.1" onPort:@"8055" error:&error];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    // 连接成功开启定时器
    // 连接后,可读取服务端的数据
    [self.clientSocket readDataWithTimeout:- 1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // 读取到服务端数据值后,能再次读取
    [self.clientSocket readDataWithTimeout:- 1 tag:0];
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
